import 'package:magiq/model/marker.dart';
import 'package:magiq/model/point.dart';

class Photo {
  final int id;
  final String url;
  final DateTime uploadedAt; // Changed to DateTime for Dart
  final Point point;
  final Marker marker;

  Photo({
    required this.id,
    required this.url,
    required this.uploadedAt,
    required this.point,
    required this.marker,
  });

  // Custom fromJson method
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      url: json['url'] as String,
      uploadedAt: DateTime.parse(
          json['uploaded_at'] as String), // Parse the date string
      point: Point.fromJson(json['point']
          as Map<String, dynamic>), // Assuming Point class has fromJson method
      marker: Marker.fromJson(json['marker']
          as Map<String, dynamic>), // Assuming Marker class has fromJson method
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'uploaded_at': uploadedAt.toIso8601String(), // Convert DateTime to string
      'point': point.toJson(), // Assuming Point class has toJson method
      'marker': marker.toJson(), // Assuming Marker class has toJson method
    };
  }
}
