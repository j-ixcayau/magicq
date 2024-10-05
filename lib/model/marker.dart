import 'package:magiq/model/photo.dart';

class Marker {
  final int id;
  final String phoneNumber; // Changed to camelCase
  final String location;
  final String address;
  final String link;
  final DateTime createdAt; // Changed to DateTime for Dart
  final String userId;
  final List<Photo> photos;

  Marker({
    required this.id,
    required this.phoneNumber,
    required this.location,
    required this.address,
    required this.link,
    required this.createdAt,
    required this.userId,
    required this.photos,
  });

  // Custom fromJson method
  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'] as int,
      phoneNumber: json['phone_number'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      link: json['link'] as String,
      createdAt:
          DateTime.parse(json['created_at'] as String), // Parse the date string
      userId: json['userId'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map((photo) => Photo.fromJson(photo as Map<String, dynamic>))
          .toList(), // Assuming Photo class has fromJson method
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'location': location,
      'address': address,
      'link': link,
      'created_at': createdAt.toIso8601String(), // Convert DateTime to string
      'userId': userId,
      'photos': photos
          .map((photo) => photo.toJson())
          .toList(), // Assuming Photo class has toJson method
    };
  }
}
