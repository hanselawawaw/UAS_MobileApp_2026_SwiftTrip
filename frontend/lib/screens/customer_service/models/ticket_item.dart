enum TicketStatus { pending, solved, replied }

class TicketItem {
  final String id;
  final String title;
  final String issuedDate;
  final String preview;
  final TicketStatus status;
  final bool isPublic;

  const TicketItem({
    required this.id,
    required this.title,
    required this.issuedDate,
    required this.preview,
    required this.status,
    required this.isPublic,
  });

  factory TicketItem.fromJson(Map<String, dynamic> json) {
    return TicketItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      issuedDate: json['issued_date'] as String,
      preview: json['preview'] as String,
      status: _parseStatus(json['status'] as String),
      isPublic: json['is_public'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issued_date': issuedDate,
      'preview': preview,
      'status': status.name,
      'is_public': isPublic,
    };
  }

  static TicketStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'solved':
        return TicketStatus.solved;
      case 'replied':
        return TicketStatus.replied;
      default:
        return TicketStatus.pending;
    }
  }
}
