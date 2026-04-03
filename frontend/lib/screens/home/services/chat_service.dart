import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swifttrip_frontend/core/constants.dart';
import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';
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

  Future<ChatMessage> sendMessage(String text, List<ChatMessage> history, [String context = 'home']) async {
    try {
      final baseUrlClean = Constants.baseUrl.replaceAll('/api/auth/', '');
      final url = Uri.parse('$baseUrlClean/api/support/ai-chat/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'Accept-Language': 'en-US'},
        body: jsonEncode({
          'message': text,
          'history': history.map((m) => m.toJson()).toList(),
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
            final landOptions = data['land_options'] as List<dynamic>? ?? [];
            if (landOptions.isEmpty) {
              return ChatMessage.text(type: MsgType.ai, text: 'No vehicles found currently for $type.');
            }
            
            final f = landOptions.first;
            final ticket = CartTicket(
              type: f['type'] ?? 'Ticket',
              bookingId: f['bookingId'] ?? 'ID-\${DateTime.now().millisecondsSinceEpoch}',
              classLabel: f['classLabel'] ?? 'Regular',
              priceRp: (f['priceRp'] ?? 0).toInt(),
              operator: f['operator'],
              from: f['from'] ?? '--',
              to: f['to'] ?? '--',
              date: f['date'] ?? '--',
              departure: f['departure'] ?? '--',
              arrive: f['arrive'] ?? '--',
              busClass: f['busClass'],
              busNumber: f['busNumber'],
              carPlate: f['carPlate'],
              driverName: f['driverName'],
              carriage: f['carriage'],
              seat: f['seat'],
            );
            return ChatMessage.ticket(ticket: ticket);
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
