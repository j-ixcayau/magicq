import 'package:magiq/model/medal.dart';
import 'package:magiq/model/user.dart';

class UserPoints {
  final int id;
  final int points;
  final DateTime achievedAt; // Changed to DateTime for Dart
  final User user;
  final Medal medal;

  UserPoints({
    required this.id,
    required this.points,
    required this.achievedAt,
    required this.user,
    required this.medal,
  });

  // Custom fromJson method
  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      id: json['id'] as int,
      points: json['points'] as int,
      achievedAt: DateTime.parse(
          json['achieved_at'] as String), // Parse the date string
      user: User.fromJson(json['user']
          as Map<String, dynamic>), // Assuming User class has fromJson method
      medal: Medal.fromJson(json['medal']
          as Map<String, dynamic>), // Assuming Medal class has fromJson method
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'achieved_at': achievedAt.toIso8601String(), // Convert DateTime to string
      'user': user.toJson(), // Assuming User class has toJson method
      'medal': medal.toJson(), // Assuming Medal class has toJson method
    };
  }
}
