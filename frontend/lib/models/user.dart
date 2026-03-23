class User {
  final String email;
  final String firstName;
  final String lastName;

  User({required this.email, required this.firstName, required this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toJson() {
    return {'email': email, 'first_name': firstName, 'last_name': lastName};
  }
}
