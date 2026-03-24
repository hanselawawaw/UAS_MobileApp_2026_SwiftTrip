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

class AIChatView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        message = request.data.get('message', '')
        if not message:
            return Response({"error": "Message is required"}, status=status.HTTP_400_BAD_REQUEST)

        language = request.headers.get('Accept-Language', 'en-US')
        genai.configure(api_key=os.environ.get("GEMINI_API_KEY"))
        
        # We use gemini-1.5-flash as the standard fast model
        model = genai.GenerativeModel("gemini-1.5-flash")
        
        extraction_prompt = f"""
        Extract the origin IATA code, destination IATA code, and the departure date (YYYY-MM-DD) from this message.
        Message: "{message}"
        Return ONLY a JSON object with keys "origin", "destination", "date". Return empty strings if not found.
        """
        
        try:
            extraction_response = model.generate_content(extraction_prompt)
            json_text = extraction_response.text.strip().replace('```json', '').replace('```', '').strip()
            params = json.loads(json_text)
            origin = params.get('origin', '')
            destination = params.get('destination', '')
            date = params.get('date', '')
        except Exception as e:
            text_val = getattr(extraction_response, 'text', 'No text') if 'extraction_response' in locals() else 'No response'
            print("EXTRACTION ERROR:", e, text_val)
            return Response({"error": "Failed to parse query", "details": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
        flights = []
        if len(origin) == 3 and len(destination) == 3 and date:
            amadeus = AmadeusService()
            flights = amadeus.search_flights(origin, destination, date) or []

        summary_prompt = f"""
        User asked: "{message}"
        Flight search results: {len(flights)} flights found.
        If flights > 0, summarize the best option briefly.
        If flights == 0, politely state no flights were found.
        Respond in language matching: {language}.
        Keep it friendly and very concise.
        """
        
        try:
            summary_response = model.generate_content(summary_prompt)
            final_message = summary_response.text.strip()
        except Exception:
            final_message = "Here are the flights we found for you." if flights else "Sorry, we couldn't find any flights."

        return Response({
            "message": final_message,
            "flights": flights
        })
