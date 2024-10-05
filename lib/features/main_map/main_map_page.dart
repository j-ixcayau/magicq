import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMapPage extends StatelessWidget {
  const MainMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(14.613303, -90.535587),
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          /* _controller.complete(controller); */
        },
      ),
    );
  }
}
