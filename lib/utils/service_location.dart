import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceLocation {
  const ServiceLocation({
    required this.coordinates,
    required this.name,
  });

  final AppLocation coordinates;
  final String name;
}

class AppLocation {
  const AppLocation({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  LatLng get parse => LatLng(lat, lng);
}
