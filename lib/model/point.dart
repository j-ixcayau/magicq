import 'package:magiq/model/category.dart';
import 'package:magiq/model/comment.dart';
import 'package:magiq/model/notification.dart';
import 'package:magiq/model/photo.dart';
import 'package:magiq/model/user.dart';

class Point {
  final int id;
  final String title;
  final String description;
  final String location;
  final Category category;
  final String status;
  final String link;
  final DateTime createdAt; // Changed to DateTime for Dart
  final User user;
  final List<Photo> photos;
  final List<Comment> comments;
  final List<Notification> notifications;

  Point({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.status,
    required this.link,
    required this.createdAt,
    required this.user,
    required this.photos,
    required this.comments,
    required this.notifications,
  });

  // Custom fromJson method
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      category: Category.fromJson(json['category'] as Map<String,
          dynamic>), // Assuming Category class has fromJson method
      status: json['status'] as String,
      link: json['link'] as String,
      createdAt:
          DateTime.parse(json['created_at'] as String), // Parse the date string
      user: User.fromJson(json['user']
          as Map<String, dynamic>), // Assuming User class has fromJson method
      photos: (json['photos'] as List<dynamic>)
          .map((photo) => Photo.fromJson(photo as Map<String, dynamic>))
          .toList(), // Assuming Photo class has fromJson method
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
      'title': title,
      'description': description,
      'location': location,
      'category':
          category.toJson(), // Assuming Category class has toJson method
      'status': status,
      'link': link,
      'created_at': createdAt.toIso8601String(), // Convert DateTime to string
      'user': user.toJson(), // Assuming User class has toJson method
      'photos': photos
          .map((photo) => photo.toJson())
          .toList(), // Assuming Photo class has toJson method
      'comments': comments
          .map((comment) => comment.toJson())
          .toList(), // Assuming Comment class has toJson method
      'notifications': notifications
          .map((notification) => notification.toJson())
          .toList(), // Assuming Notification class has toJson method
    };
  }
}
