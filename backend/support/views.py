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
from google import genai
from google.genai import types
from travel_data.services.amadeus_service import AmadeusService

class GeminiChatView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        message = request.data.get('message', '')
        context = request.data.get('context', 'home')  # 'home' or 'support'
        
        if not message:
            return Response({"error": "Message is required"}, status=status.HTTP_400_BAD_REQUEST)

        client = genai.Client(
            api_key=os.environ.get("GEMINI_API_KEY"),
            http_options={'api_version': 'v1beta'}
        )
        
        # Choosing gemini-2.5-flash as it's the latest available model in 2026-standard list
        model_id = "gemini-2.5-flash"
        
        system_instruction = f"""
        You are the SwiftTrip Assistant, a professional travel and app support bot.
        
        Your task is to classify the user input into one of three categories:
        1. GREETING: If the user says hi, hello, or asks how you are. 
           Return JSON: {{"intent": "GREETING", "message": "A friendly travel-themed greeting"}}
        2. COMPLEX_TRAVEL: If the user asks for flights, buses, trains, or car rentals.
           Return JSON: {{"intent": "SEARCH", "origin": "IATA/City", "destination": "IATA/City", "date": "YYYY-MM-DD", "type": "flight"|"bus"|"train"|"car"}}
        3. OOT (Out-of-Topic): If the user asks about personal life, politics, jokes, or anything non-travel/app related.
           Return JSON: {{"intent": "OOT", "message": "I can only assist with travel bookings and app-related support. How can I help you with your trip today?"}}
        
        Context: User is on '{context}' screen.
        Rules: 
        - Return ONLY raw JSON. 
        - No markdown blocks.
        - For COMPLEX_TRAVEL searches, if parameters are missing, use "UNKNOWN".
        """
        
        try:
            # Fix: Using system_instruction inside GenerateContentConfig as per Python SDK standard
            # We explicitly pass it here to avoid the camelCase conversion error in some environments
            response = client.models.generate_content(
                model=model_id,
                contents=message,
                config=types.GenerateContentConfig(
                    system_instruction=system_instruction,
                    temperature=0.1 # Low temperature for consistent JSON output
                )
            )
            
            json_text = response.text.strip()
            
            # Failsafe string parsing
            if json_text.startswith("```json"):
                json_text = json_text[7:]
            if json_text.endswith("```"):
                json_text = json_text[:-3]
            json_text = json_text.strip()
                
            intent_data = json.loads(json_text)
            intent = intent_data.get('intent', 'UNKNOWN')
            
            # Task 3: Refuse OOT - Do not call external services
            if intent == 'OOT':
                return Response(intent_data)
            
            # Handle GREETING
            if intent == 'GREETING':
                return Response(intent_data)

            # If SEARCH and flight, do backend Amadeus search. 
            if intent == 'SEARCH' and intent_data.get('type', '').lower() == 'flight':
                origin = intent_data.get('origin', '')
                destination = intent_data.get('destination', '')
                date = intent_data.get('date', '')
                
                flights = []
                if origin != 'UNKNOWN' and destination != 'UNKNOWN' and date != 'UNKNOWN':
                    amadeus = AmadeusService()
                    flights = amadeus.search_flights(origin, destination, date) or []
                
                intent_data['flights'] = flights
                
            return Response(intent_data)
        
        except Exception as e:
            text_val = getattr(response, 'text', 'No response') if 'response' in locals() else 'No response'
            print("GEMINI ERROR:", e, text_val)
            return Response({
                "intent": "SUPPORT", 
                "message": "Sorry, I didn't quite catch that. Could you describe your query or issue more clearly?",
                "action": "CREATE_TICKET"
            })

