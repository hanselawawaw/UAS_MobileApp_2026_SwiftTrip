class CsQuestion {
  final String username;
  final String subtitle;
  final String body;

  const CsQuestion({
    required this.username,
    required this.subtitle,
    required this.body,
  });

  factory CsQuestion.fromJson(Map<String, dynamic> json) {
    return CsQuestion(
      username: json['username'] as String,
      subtitle: json['subtitle'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'subtitle': subtitle,
      'body': body,
    };
  }
}

class CsFeedbackEntry {
  final String username;
  final String date;
  final String body;
  final bool isAnswered;

  const CsFeedbackEntry({
    required this.username,
    required this.date,
    required this.body,
    this.isAnswered = false,
  });

  factory CsFeedbackEntry.fromJson(Map<String, dynamic> json) {
    return CsFeedbackEntry(
      username: json['username'] as String,
      date: json['date'] as String,
      body: json['body'] as String,
      isAnswered: json['is_answered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'date': date,
      'body': body,
      'is_answered': isAnswered,
    };
  }
}
