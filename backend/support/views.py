from rest_framework import viewsets, status, decorators
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from .models import FAQ, SupportTicket, TicketReply
from .serializers import FAQSerializer, SupportTicketSerializer, TicketReplySerializer
from rest_framework.views import APIView

class FAQViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = FAQ.objects.all()
    serializer_class = FAQSerializer
    permission_classes = [AllowAny]

class SupportTicketViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = SupportTicket.objects.all()
    serializer_class = SupportTicketSerializer

    def get_queryset(self):
        # Users should only see their own tickets unless viewed through 'public'
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @decorators.action(detail=False, methods=['get'], permission_classes=[AllowAny])
    def public(self, request):
        # Mapping to 'Recent Questions' in Flutter
        public_tickets = self.queryset.filter(publish_type='Public')[:10]
        serializer = self.get_serializer(public_tickets, many=True)
        return Response(serializer.data)

    @decorators.action(detail=True, methods=['get'])
    def thread(self, request, pk=None):
        ticket = self.get_object()
        replies = ticket.replies.all().order_by('created_at')
        serializer = TicketReplySerializer(replies, many=True)
        return Response(serializer.data)

    @decorators.action(detail=True, methods=['post'])
    def reply(self, request, pk=None):
        ticket = self.get_object()
        body = request.data.get('body')
        if not body:
            return Response({"error": "Body is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        reply = TicketReply.objects.create(
            ticket=ticket,
            user=request.user,
            body=body
        )
        # Update ticket status to replied if user is not the owner (e.g. CSR)
        if request.user != ticket.user:
            ticket.status = 'replied'
            ticket.save()

        serializer = TicketReplySerializer(reply)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class MetadataView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        return Response({
            "problem_types": [choice[0] for choice in SupportTicket.PROBLEM_TYPES],
            "locations": [choice[0] for choice in SupportTicket.LOCATIONS],
            "publish_types": [choice[0] for choice in SupportTicket.PUBLISH_TYPES]
        })

import os
import json
import google.generativeai as genai
from travel_data.services.amadeus_service import AmadeusService

class GeminiChatView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        message = request.data.get('message', '')
        context = request.data.get('context', 'home')  # 'home' or 'support'
        
        if not message:
            return Response({"error": "Message is required"}, status=status.HTTP_400_BAD_REQUEST)

        genai.configure(api_key=os.environ.get("GEMINI_API_KEY"))
        model = genai.GenerativeModel("gemini-3-flash")
        
        system_instruction = f"""
        You are the SwiftTrip Assistant.
        Context: The user is messaging from the '{context}' screen. Prioritize your responses accordingly.
        If the user asks for travel (flight, car, bus, train), return ONLY a valid JSON: {{"intent": "SEARCH", "origin": "IATA Code or City", "destination": "IATA Code or City", "date": "YYYY-MM-DD", "type": "flight", "car", "bus", or "train"}}. Use standard 3-letter IATA for flights. For dates, default to future dates if implied.
        If the user asks for advice/consultation on trips, return ONLY JSON: {{"intent": "CONSULT", "message": "Your helpful advice here matching the user language", "needs_data": true}}.
        If the user reports a bug or explicitly needs customer support, return ONLY JSON: {{"intent": "SUPPORT", "message": "Your polite response acknowledging the report", "action": "CREATE_TICKET"}}.
        Do not include ANY markdown block quotes (e.g. ```json). Your entire output must be raw valid JSON.
        """
        
        # We pass system_instruction into generate_content explicitly as part of generation_config or model initialization.
        # However, to be perfectly safe with various SDK versions, we prepend it as a system block.
        prompt = f"System: {system_instruction}\n\nUser: {message}"
        
        try:
            response = model.generate_content(prompt)
            json_text = response.text.strip()
            
            # Failsafe string parsing
            if json_text.startswith("```json"):
                json_text = json_text[7:]
            if json_text.endswith("```"):
                json_text = json_text[:-3]
            json_text = json_text.strip()
                
            intent_data = json.loads(json_text)
            intent = intent_data.get('intent', 'UNKNOWN')
            
            # If SEARCH and flight, do backend Amadeus search. 
            if intent == 'SEARCH' and intent_data.get('type', '').lower() == 'flight':
                origin = intent_data.get('origin', '')
                destination = intent_data.get('destination', '')
                date = intent_data.get('date', '')
                
                flights = []
                if len(origin) == 3 and len(destination) == 3 and date:
                    amadeus = AmadeusService()
                    flights = amadeus.search_flights(origin, destination, date) or []
                
                intent_data['flights'] = flights
                
            return Response(intent_data)
        
        except Exception as e:
            text_val = getattr(response, 'text', 'No text') if 'response' in locals() else 'No response'
            print("GEMINI ERROR:", e, text_val)
            return Response({
                "intent": "SUPPORT", 
                "message": "Sorry, I didn't quite catch that. Could you describe your query or issue more clearly?",
                "action": "CREATE_TICKET"
            })

