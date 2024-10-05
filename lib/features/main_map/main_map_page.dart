import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:magiq/features/create_new/create_new_page.dart';
import 'package:magiq/model/point.dart';
import 'package:magiq/model/user.dart';
import 'package:magiq/utils/auth_utils.dart';
import 'package:magiq/utils/hospitals.dart';
import 'package:magiq/utils/http/auth.dart';
import 'package:magiq/utils/http/point.dart';
import 'package:magiq/utils/location.dart';
import 'package:magiq/utils/service_location.dart';

class MainMapPage extends StatefulWidget {
  const MainMapPage({super.key});

  @override
  State<MainMapPage> createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  var initialLocation = const LatLng(14.613303, -90.535587);
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  String? selectedMapInfo;

  String? currentUser;

  final mapsInfoTypes = [
    /* 'Policía',
    'Bomberos', */
    'Hospitales',
    'Avisos',
    /* 
    'Todo', */
  ];

  @override
  void initState() {
    super.initState();
    _setInitialLocation();

    getUser();
  }

  Future<void> _setInitialLocation() async {
    try {
      // Request permission and get the current position
      final position = await AppLocationUtils.determinePosition();
      initialLocation = LatLng(position.latitude, position.longitude);
      setState(() {});
    } catch (e) {
      // If there's an error, fallback to the default initialLocation
      print('Error getting user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MagiQ'),
        leading: IconButton(
          onPressed: handleLogin,
          icon: (currentUser != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(currentUser!),
                )
              : const Icon(Icons.person),
        ),
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

              _controller.moveCamera(CameraUpdate.newLatLng(initialLocation));
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: ElevatedButton.icon(
                onPressed: navigateToAddEvent,
                label: const Text('Agregar evento'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return;
    }
    try {
      AuthUtils.auth();

      getUser();
    } catch (e) {
      log('Error during Google sign-in: $e');
    }
  }

  void getUser() async {
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      return;
    }

    final user = User(
      id: 0,
      username: fbUser.displayName ?? '',
      email: fbUser.email!,
      password: 'p)Aq9T{j/]m;5ur`NBgPt7',
      isVerified: false,
      createdAt: DateTime.now(),
    );

    currentUser = fbUser.photoURL;

    final result = await AuthService().auth(user);

    log(result.toString());

    setState(() {});
  }

  void onInfoMapTap(String value) async {
    _markers.clear();

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
    } else if (value == 'Avisos') {
      final points = await PointService.get();

      for (var it in points) {
        final marker = Marker(
          markerId: MarkerId(it.hashCode.toString()),
          position: it.location,
          infoWindow: InfoWindow(
            title: it.title,
          ),
          onTap: () => onPointTap(it),
        );

        _markers.add(marker);
      }
    }

    setState(() {});
  }

  void onPointTap(Point point) {}

  void navigateToAddEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewPage(
          position: initialLocation,
        ),
      ),
    );
  }
}
