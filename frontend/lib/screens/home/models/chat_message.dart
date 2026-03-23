enum MsgType { ai, user, ticket }

class TicketData {
  final String from;
  final String to;
  final String date;
  final String departure;
  final String arrive;
  final String train;
  final String carriage;
  final String seat;

  const TicketData({
    required this.from,
    required this.to,
    required this.date,
    required this.departure,
    required this.arrive,
    required this.train,
    required this.carriage,
    required this.seat,
  });

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(
      from: json['from'] as String,
      to: json['to'] as String,
      date: json['date'] as String,
      departure: json['departure'] as String,
      arrive: json['arrive'] as String,
      train: json['train'] as String,
      carriage: json['carriage'] as String,
      seat: json['seat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'date': date,
      'departure': departure,
      'arrive': arrive,
      'train': train,
      'carriage': carriage,
      'seat': seat,
    };
  }
}

class ChatMessage {
  final MsgType type;
  final String? text;
  final TicketData? ticket;

  const ChatMessage.text({required this.type, required String this.text})
    : ticket = null;

  const ChatMessage.ticket({required TicketData this.ticket})
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
        ticket: TicketData.fromJson(json['ticket'] as Map<String, dynamic>),
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
