from rest_framework import viewsets, status, decorators
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from .models import FAQ, SupportTicket, TicketReply
from .serializers import FAQSerializer, SupportTicketSerializer, TicketReplySerializer
from rest_framework.views import APIView
from rest_framework.throttling import AnonRateThrottle, UserRateThrottle

class FAQViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = FAQ.objects.all()
    serializer_class = FAQSerializer
    permission_classes = [AllowAny]

class SupportTicketViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = SupportTicket.objects.all()
    serializer_class = SupportTicketSerializer

    def get_queryset(self):
        return self.queryset.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @decorators.action(detail=False, methods=['get'], permission_classes=[AllowAny])
    def public(self, request):
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
from travel_data.services.mock_land_service import MockLandService

class GeminiChatView(APIView):
    permission_classes = [AllowAny]
    throttle_classes = [AnonRateThrottle, UserRateThrottle]

    def post(self, request):
        message = request.data.get('message', '')
        history_raw = request.data.get('history', [])
        context = request.data.get('context', 'home')
        
        if not message:
            greetings = {
                'support': {"intent": "CHITCHAT", "message": "Hi! I can help with app issues, FAQs, or file a support ticket. What's going on?"},
                'home': {"intent": "CHITCHAT", "message": "Hi! I can search flights, compare destinations, or give travel advice. What are you planning?"},
            }
            return Response(greetings.get(context, greetings['home']))

        client = genai.Client(
            api_key=os.environ.get("GEMINI_API_KEY"),
            http_options={'api_version': 'v1beta'}
        )
        
        model_id = "gemini-2.5-flash"

        if context == 'support':
            persona_rules = 'Focus on app troubleshooting, FAQ, and bug reporting. If a user reports a bug, suggest creating a SupportTicket.'
        else:
            persona_rules = 'Focus on travel discovery, flight/land vehicle searches, and trip advice (Consultation).'
        
        system_instruction = f"""
You are a travel and support assistant.
Role: {persona_rules}

Classify the user's input and return ONLY raw JSON with an "intent" field.

Categories:
- SEARCH: User wants to find flights or transport. 
  Return: {{"intent": "SEARCH", "origin": "...", "destination": "...", "date": "YYYY-MM-DD", "type": "flight|car|bus|train"}}
- CONSULTATION: User wants travel advice or comparisons.
  Return: {{"intent": "CONSULTATION", "message": "your helpful response here"}}
- SUPPORT: User has an app problem or bug.
  Return: {{"intent": "SUPPORT", "message": "...", "action": "CREATE_TICKET"}}
- CHITCHAT: Greetings or general talk.
  Return: {{"intent": "CHITCHAT", "message": "your friendly response + briefly mention your capabilities"}}
- OOT: Off-topic. Refuse politely.
  Return: {{"intent": "OOT", "message": "polite refusal"}}

Return ONLY raw JSON. No markdown, no backticks.
"""
        
        # Efficiency Guardrail: Limit history to last 10 messages
        history_limited = history_raw[-10:]
        
        # Format history for Gemini contents
        contents = []
        for h in history_limited:
            role = "user" if h.get('type') == 'user' else "model"
            text = h.get('text', '')
            if text:
                contents.append({"role": role, "parts": [{"text": text}]})
        
        # Add the newest message
        contents.append({"role": "user", "parts": [{"text": message}]})
        
        try:
            response = client.models.generate_content(
                model=model_id,
                contents=contents,
                config=types.GenerateContentConfig(
                    system_instruction=system_instruction,
                    temperature=0.1
                )
            )
            
            json_text = response.text.strip()
            
            if json_text.startswith("```json"):
                json_text = json_text[7:]
            if json_text.endswith("```"):
                json_text = json_text[:-3]
            json_text = json_text.strip()
                
            intent_data = json.loads(json_text)
            intent = intent_data.get('intent', 'UNKNOWN')
            
            if intent == 'OOT':
                return Response(intent_data)
            
            if intent == 'CHITCHAT':
                return Response(intent_data)

            if intent == 'SEARCH':
                search_type = intent_data.get('type', '').lower()
                origin = intent_data.get('origin', '')
                destination = intent_data.get('destination', '')
                date = intent_data.get('date', '')

                has_required = all(
                    v and v.upper() != 'UNKNOWN'
                    for v in [origin, destination, date]
                )   

                if search_type == 'flight':
                    flights = []
                    if has_required:
                        amadeus = AmadeusService()
                        flights = amadeus.search_flights(origin, destination, date) or []
                    intent_data['flights'] = flights

                elif search_type in ['car', 'bus', 'train']:
                    mock_land = MockLandService()
                    intent_data['land_options'] = mock_land.search_land_tickets(search_type, origin, destination)

                else:
                    intent_data['message'] = f"Search type '{search_type}' not recognized."

            return Response(intent_data)
        
        except Exception as e:
            text_val = getattr(response, 'text', 'No response') if 'response' in locals() else 'No response'
            print("GEMINI ERROR:", e, text_val)
            
            if "429" in str(e) or "RESOURCE_EXHAUSTED" in str(e).upper():
                return Response({
                    "intent": "SUPPORT", 
                    "message": "I'm a bit overwhelmed right now! Please try asking me again in a few minutes.",
                    "action": "WAIT"
                })
                
            return Response({
                "intent": "SUPPORT", 
                "message": "Sorry, I didn't quite catch that. Could you describe your query or issue more clearly?",
                "action": "CREATE_TICKET"
            })

