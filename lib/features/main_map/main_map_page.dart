import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:magiq/features/create_new/create_new_page.dart';
import 'package:magiq/utils/hospitals.dart';

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
    'Noticias',
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
      Position position = await _determinePosition();
      initialLocation = LatLng(position.latitude, position.longitude);
      setState(() {});
    } catch (e) {
      // If there's an error, fallback to the default initialLocation
      print('Error getting user location: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
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

  void getUser() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    currentUser = FirebaseAuth.instance.currentUser!.photoURL;
    setState(() {});
  }

  void handleLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return;
    }

    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web login flow
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // Android login flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          // The user canceled the sign-in
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Authenticate with Firebase
        userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
      }

      getUser();

      print('Successfully logged in: ${userCredential.user?.displayName}');
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }

  void onInfoMapTap(String value) {
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
    }

    setState(() {});
  }

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

  void _addMarker(LatLng position, String name) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: name,
      ),
    );

    _markers.add(marker);
    setState(() {});
  }
}
