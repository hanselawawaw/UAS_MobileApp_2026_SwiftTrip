import '../models/chat_message.dart';

class ChatService {
  Future<List<ChatMessage>> getInitialMessages() async {
    return [
      const ChatMessage.text(type: MsgType.ai, text: 'What can i help?'),
      const ChatMessage.text(type: MsgType.user, text: 'To Jakarta'),
      const ChatMessage.ticket(
        ticket: TicketData(
          from: 'Jakarta',
          to: 'Solo',
          date: '19/2/2026',
          departure: '9:00',
          arrive: '11:00',
          train: '1234',
          carriage: '01',
          seat: 'B',
        ),
      ),
      const ChatMessage.ticket(
        ticket: TicketData(
          from: 'Malang',
          to: 'Surabaya',
          date: '19/2/2026',
          departure: '9:00',
          arrive: '11:00',
          train: '1234',
          carriage: '01',
          seat: 'B',
        ),
      ),
    ];
  }

  Future<ChatMessage> sendMessage(String text) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return const ChatMessage.text(
      type: MsgType.ai,
      text: 'I found some options for you. Let me know if you need more details!',
    );
  }
}
