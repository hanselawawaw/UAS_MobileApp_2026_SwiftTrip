class RecentQuestion {
  final String username;
  final String question;

  const RecentQuestion({required this.username, required this.question});

  factory RecentQuestion.fromJson(Map<String, dynamic> json) {
    return RecentQuestion(
      username: json['username'] as String,
      question: json['question'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'question': question,
    };
  }
}
