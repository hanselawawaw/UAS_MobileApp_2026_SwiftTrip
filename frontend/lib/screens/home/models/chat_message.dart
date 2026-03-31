import 'package:swifttrip_frontend/screens/cart/models/cart_models.dart';

enum MsgType { ai, user, ticket }

class ChatMessage {
  final MsgType type;
  final String? text;
  final CartTicket? ticket;

  const ChatMessage.text({required this.type, required String this.text})
      : ticket = null;

  const ChatMessage.ticket({required CartTicket this.ticket})
      : type = MsgType.ticket,
        text = null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = MsgType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => MsgType.user, // fallback
    );

    if (type == MsgType.ticket) {
      return ChatMessage.ticket(
        ticket: CartTicket.fromJson(json['ticket'] as Map<String, dynamic>),
      );
    } else {
      return ChatMessage.text(
        type: type,
        text: json['text'] as String,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (text != null) 'text': text,
      if (ticket != null) 'ticket': ticket!.toJson(),
    };
  }
}
