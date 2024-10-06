import 'package:google_maps_flutter/google_maps_flutter.dart';

class Point {
  final int id;
  final String title;
  final String description;
  final LatLng location;
  final int categoryId;
  final String status;
  final String link;
  final int userId;

  Point({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.categoryId,
    required this.status,
    required this.link,
    required this.userId,
  });

  // Custom fromJson method
  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      location: LatLng(
        json['lat'],
        json['lng'],
      ),
      categoryId: json['categoryId'] as int,
      status: json['status'] as String,
      link: json['link'] as String,
      userId: json['userId'] as int,
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'lat': location.latitude,
      'long': location.longitude,
      'categoryId': categoryId,
      'status': status,
      'link': link,
      'userId': userId,
    };
  }
}
