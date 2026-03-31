import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swifttrip_frontend/core/constants.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
import 'package:swifttrip_frontend/screens/searching/services/mock_vehicle_service.dart';
import '../models/chat_message.dart';

class ChatService {
  Future<List<ChatMessage>> getInitialMessages([String context = 'home']) async {
    return [
      ChatMessage.text(
        type: MsgType.ai,
        text: context == 'home'
            ? 'Hello! Where would you like to travel today?'
            : 'Hello! How can I help you with your issue today?',
      ),
    ];
  }

  Future<ChatMessage> sendMessage(String text, [String context = 'home']) async {
    try {
      final baseUrlClean = Constants.baseUrl.replaceAll('/api/auth/', '');
      final url = Uri.parse('$baseUrlClean/api/support/ai-chat/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept-Language': 'en-US'},
        body: jsonEncode({
          'message': text,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final intent = data['intent'] as String?;

        if (intent == 'SEARCH' && data['type'] != null) {
          final type = (data['type'] as String).toLowerCase();
          
          if (type == 'flight') {
            final flights = data['flights'] as List<dynamic>? ?? [];
            if (flights.isEmpty) {
              return const ChatMessage.text(
                type: MsgType.ai,
                text: 'Sorry, I couldn\'t find any flights for that route.',
              );
            }
            
            final f = flights.first;
            final ticket = CartTicket(
              type: 'Plane Ticket',
              bookingId: 'FL-\${DateTime.now().millisecondsSinceEpoch}',
              classLabel: 'Economy',
              priceRp: (f['price'] ?? 0).toInt(),
              operator: f['airlineName'],
              flightNumber: f['flight_number'],
              from: f['origin'],
              to: f['destination'],
              date: (f['departure_time'] as String).length >= 10 ? (f['departure_time'] as String).substring(0, 10) : '--',
              departure: (f['departure_time'] as String).length >= 16 ? (f['departure_time'] as String).substring(11, 16) : '--',
              arrive: (f['arrival_time'] as String).length >= 16 ? (f['arrival_time'] as String).substring(11, 16) : '--',
            );
            return ChatMessage.ticket(ticket: ticket);
            
          } else {
             final pins = const MockVehicleService().getPinsForType(type);
             if (pins.isEmpty) {
                return ChatMessage.text(type: MsgType.ai, text: 'No vehicles found currently for $type.');
             }
             return ChatMessage.ticket(ticket: pins.first.ticket);
          }
        } 
        
        return ChatMessage.text(
          type: MsgType.ai,
          text: data['message'] ?? 'I have recorded your request.',
        );
      }
      
      return ChatMessage.text(
        type: MsgType.ai,
        text: 'Sorry, I had trouble connecting to the server. (${response.statusCode})',
      );
      
    } catch (e) {
      return ChatMessage.text(
        type: MsgType.ai,
        text: 'An error occurred. Please try again later.',
      );
    }
  }
}
