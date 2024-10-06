import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:magiq/features/create_new/create_new_page.dart';
import 'package:magiq/features/curiosity/curiosity_page.dart';
import 'package:magiq/features/main_map/map_point_dialog.dart';
import 'package:magiq/features/medal/medal_page.dart';
import 'package:magiq/features/point/point_screen.dart';
import 'package:magiq/model/marker.dart' as marker;
import 'package:magiq/model/medal.dart';
import 'package:magiq/model/point.dart';
import 'package:magiq/model/user.dart';
import 'package:magiq/utils/auth_utils.dart';
import 'package:magiq/utils/http/auth.dart';
import 'package:magiq/utils/http/climate.dart';
import 'package:magiq/utils/http/marker.dart';
import 'package:magiq/utils/http/medal.dart';
import 'package:magiq/utils/http/point.dart';
import 'package:magiq/utils/location.dart';

class MainMapPage extends StatefulWidget {
  const MainMapPage({super.key});

  static int userId = -1;

  @override
  State<MainMapPage> createState() => _MainMapPageState();
}

class _MainMapPageState extends State<MainMapPage> {
  var initialLocation = const LatLng(14.613303, -90.535587);
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  String? selectedMapInfo;

  String? userImageUrl;
  String? userName;

  (int, List<Medal>)? medalInfo;

  final mapsInfoTypes = [
    'Ayuda',
    'Avisos',
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
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userImageUrl != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onMedalTap,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        userImageUrl!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (medalInfo?.$1 != null)
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          '${medalInfo!.$1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      )
                  ],
                ),
              )
            ] else
              IconButton(
                onPressed: handleLogin,
                icon: const Icon(Icons.person),
              ),
          ],
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
              padding: const EdgeInsets.all(16), // Add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: navigateToCuriosityInfo,
                    label: const Text('Curiosidades de mi ubicación'),
                    icon: const Icon(Icons.info), // Added icon
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 48), // Full width
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: navigateToAddEvent,
                    label: const Text('Agregar aviso'),
                    icon: const Icon(Icons.add), // Added icon
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 48), // Full width
                    ),
                  ),
                ],
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
      await AuthUtils.auth();

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
      password: r'Abcd123$',
      isVerified: false,
      createdAt: DateTime.now(),
    );

    userImageUrl = fbUser.photoURL;
    userName = fbUser.displayName;

    final userId = await AuthService().auth(user) ?? -1;
    MainMapPage.userId = userId;

    setState(() {});

    medalInfo = await MedalService.get(userId);
    setState(() {});
  }

  void onInfoMapTap(String value) async {
    _markers.clear();

    selectedMapInfo = value;

    if (value == 'Ayuda') {
      final markers = await MarkerService.get();

      for (var it in markers) {
        final marker = Marker(
          markerId: MarkerId(it.hashCode.toString()),
          position: it.location,
          infoWindow: InfoWindow(
            title: it.address,
          ),
          onTap: () => onMarkerTap(it),
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

  void onPointTap(Point point) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          point: point,
        ),
      ),
    );
  }

  void onMarkerTap(marker.Marker marker) {
    showCustomDialog(context, marker.address, null);
  }

  void navigateToAddEvent() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateNewPage(
          position: initialLocation,
        ),
      ),
    );

    getUser();
  }

  void navigateToCuriosityInfo() async {
    final info = await ClimateService.get(initialLocation, userName ?? 'MagiQ');

    if (info == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CuriosityPage(
          info: info,
        ),
      ),
    );
  }

  void onMedalTap() {
    final medals = medalInfo?.$2 ?? [];

    if (medals.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedalListScreen(
          puntos: medalInfo?.$1 ?? 0,
          medals: getUniqueMedals(medals),
        ),
      ),
    );
  }

  List<Medal> getUniqueMedals(List<Medal> medals) {
    final seenPoints = <int>{};
    return medals.where((medal) {
      // Check if the requiredPoints has been seen before
      if (seenPoints.contains(medal.requiredPoints)) {
        return false; // Exclude this medal
      }
      seenPoints.add(medal.requiredPoints);
      return true; // Include this medal
    }).toList();
  }
}
