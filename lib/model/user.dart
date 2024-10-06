class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final bool isVerified;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isVerified: json['is_verified'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toRegisterJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'is_verified': isVerified,
    };
  }

  Map<String, dynamic> toAuthJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @Deprecated('Check if still needed')
  Map<String, dynamic> toJson() {
    return {};
  }
}
