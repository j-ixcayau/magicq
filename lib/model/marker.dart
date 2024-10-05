import 'package:magiq/model/photo.dart';
import 'package:magiq/model/user.dart';

class Marker {
  final int id;
  final String phoneNumber; // Changed to camelCase
  final String location;
  final String address;
  final String link;
  final DateTime createdAt; // Changed to DateTime for Dart
  final User user;
  final List<Photo> photos;

  Marker({
    required this.id,
    required this.phoneNumber,
    required this.location,
    required this.address,
    required this.link,
    required this.createdAt,
    required this.user,
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
      user: User.fromJson(json['user']
          as Map<String, dynamic>), // Assuming User class has fromJson method
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
      'user': user.toJson(), // Assuming User class has toJson method
      'photos': photos
          .map((photo) => photo.toJson())
          .toList(), // Assuming Photo class has toJson method
    };
  }
}
