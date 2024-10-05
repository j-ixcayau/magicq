import 'package:magiq/model/comment.dart';
import 'package:magiq/model/marker.dart';
import 'package:magiq/model/notification.dart';
import 'package:magiq/model/point.dart';
import 'package:magiq/model/user_point.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final bool isVerified; // Changed to camelCase
  final DateTime createdAt; // Changed to DateTime for Dart
  final List<UserPoints> userPoints;
  final List<Marker> markers;
  final List<Point> points;
  final List<Comment> comments;
  final List<Notification> notifications;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.createdAt,
    required this.userPoints,
    required this.markers,
    required this.points,
    required this.comments,
    required this.notifications,
  });

  // Custom fromJson method
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isVerified: json['is_verified'] as bool,
      createdAt:
          DateTime.parse(json['created_at'] as String), // Parse the date string
      userPoints: (json['userPoints'] as List<dynamic>)
          .map((userPoint) =>
              UserPoints.fromJson(userPoint as Map<String, dynamic>))
          .toList(), // Assuming UserPoints class has fromJson method
      markers: (json['markers'] as List<dynamic>)
          .map((marker) => Marker.fromJson(marker as Map<String, dynamic>))
          .toList(), // Assuming Marker class has fromJson method
      points: (json['points'] as List<dynamic>)
          .map((point) => Point.fromJson(point as Map<String, dynamic>))
          .toList(), // Assuming Point class has fromJson method
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment as Map<String, dynamic>))
          .toList(), // Assuming Comment class has fromJson method
      notifications: (json['notifications'] as List<dynamic>)
          .map((notification) =>
              Notification.fromJson(notification as Map<String, dynamic>))
          .toList(), // Assuming Notification class has fromJson method
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(), // Convert DateTime to string
      'userPoints': userPoints
          .map((userPoint) => userPoint.toJson())
          .toList(), // Assuming UserPoints class has toJson method
      'markers': markers
          .map((marker) => marker.toJson())
          .toList(), // Assuming Marker class has toJson method
      'points': points
          .map((point) => point.toJson())
          .toList(), // Assuming Point class has toJson method
      'comments': comments
          .map((comment) => comment.toJson())
          .toList(), // Assuming Comment class has toJson method
      'notifications': notifications
          .map((notification) => notification.toJson())
          .toList(), // Assuming Notification class has toJson method
    };
  }
}
