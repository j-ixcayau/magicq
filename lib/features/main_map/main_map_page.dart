import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapPage extends StatefulWidget {
  const MainMapPage({super.key});

  @override
  State<MainMapPage> createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  final initialLocation = const LatLng(14.613303, -90.535587);
  late GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: initialLocation,
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          controller = controller;
          setState(() {});
        },
      ),
    );
  }
}
