import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:magiq/model/photo.dart';

class Marker {
  final int id;
  final String phoneNumber;
  final LatLng location;
  final String address;
  final String link;
  final String userId;
  final List<Photo> photos;

  Marker({
    required this.id,
    required this.phoneNumber,
    required this.location,
    required this.address,
    required this.link,
    required this.userId,
    required this.photos,
  });

  // Custom fromJson method
  factory Marker.fromJson(Map<String, dynamic> json) {
    return Marker(
      id: json['id'] as int,
      phoneNumber: json['phone_number'] as String,
      location: LatLng(
        json['lat'],
        json['long'],
      ),
      address: json['address'] as String,
      link: json['link'] as String,
      userId: json['userId'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map((photo) => Photo.fromJson(photo as Map<String, dynamic>))
          .toList(), // Assuming Photo class has fromJson method
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'lat': location.latitude,
      'long': location.longitude,
      'address': address,
      'link': link,
      'userId': userId,
      'photos': photos.map((photo) => photo.toJson()).toList(),
    };
  }
}
