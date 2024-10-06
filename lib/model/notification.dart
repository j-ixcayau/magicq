import 'package:magiq/model/point.dart';
import 'package:magiq/model/user.dart';

class Notification {
  final int id;
  final String type;
  final String message;
  final DateTime createdAt;
  final User user;
  final Point point;

  Notification({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.user,
    required this.point,
  });

  // Custom fromJson method
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as int,
      type: json['type'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      point: Point.fromJson(json['point'] as Map<String, dynamic>),
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'user': user.toJson(),
      'point': point.toJson(),
    };
  }
}
