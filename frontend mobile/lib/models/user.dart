class User {
  final String username;
  final String email;
  final String password;
  final String role;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });

  // To map the user data from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

  // To convert the user object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
