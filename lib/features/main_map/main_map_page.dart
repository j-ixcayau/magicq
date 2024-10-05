import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:magiq/features/create_new/create_new_page.dart';
import 'package:magiq/utils/hospitals.dart';

class MainMapPage extends StatefulWidget {
  const MainMapPage({super.key});

  @override
  State<MainMapPage> createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  final LatLng initialLocation = const LatLng(14.613303, -90.535587);
  late GoogleMapController _controller;

  final Set<Marker> _markers = {};

  String? selectedMapInfo;

  final mapsInfoTypes = [
    'Policía',
    'Bomberos',
    'Hospitales',
    'Noticias',
    'Todo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MagiQ'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.map),
            onSelected: (value) {
              onInfoMapTap(value);
            },
            itemBuilder: (BuildContext context) => mapsInfoTypes
                .map(
                  (it) => PopupMenuItem(
                    value: it,
                    child: Text(it),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: initialLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
            onTap: (LatLng position) {
              // Navigate to the new screen to add a marker
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewPage(
                    position: position,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onInfoMapTap(String value) {
    selectedMapInfo = value;

    if (value == 'Hospitales') {
      for (var it in HospitalsInfo().build()) {
        final marker = Marker(
          markerId: MarkerId(it.hashCode.toString()),
          position: it.coordinates.parse,
          infoWindow: InfoWindow(
            title: it.name,
          ),
        );

        _markers.add(marker);
      }
    }

    setState(() {});
  }

  void _addMarker(LatLng position, String name) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: name,
      ),
      /* icon: BitmapDescriptor.defaultMarkerWithHue(
        infoType == 'Policía'
            ? BitmapDescriptor.hueBlue
            : infoType == 'Bomberos'
                ? BitmapDescriptor.hueRed
                : infoType == 'Noticias'
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueMagenta,
      ), */
    );

    _markers.add(marker);
    setState(() {});
  }
}
