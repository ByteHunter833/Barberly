import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  final LatLng _center = const LatLng(41.3111, 69.2797); // Tashkent

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Column(children: [
        Expanded(
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
            ),
          ),
        ),
      ],),
    );
  }
}
