import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberly/features/barbers/providers/current_location_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  LatLng? currentLatLng;
  GoogleMapController? mapController;
  bool isOnline = true;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  LatLng destination = const LatLng(41.565574,60.646030);

  Future<void> getLocation() async {

    try {
      final pos = await CurrentLocationProvider.determinePosition();
      setState(() {
        currentLatLng = LatLng(pos.latitude, pos.longitude);
        _markers = {
          Marker(
            markerId: const MarkerId("myLocation"),
            position: currentLatLng!,
            infoWindow: const InfoWindow(title: "Mening joylashuvim"),
          )
        };
      });
      // Kamerani shu joyga olib borish
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng!, 16),
      );
    } catch (e) {
      print("Xatolik: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    _getLocationAndDrawRoute();
  }


  Future<void> _getLocationAndDrawRoute() async {
    Position pos = await Geolocator.getCurrentPosition();

    currentLatLng = LatLng(pos.latitude, pos.longitude);

    _markers.add(
      Marker(
        markerId: const MarkerId("origin"),
        position: currentLatLng!,
        infoWindow: const InfoWindow(title: "Sizning joyingiz"),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId("destination"),
        position: destination,
        infoWindow: const InfoWindow(title: "Manzil"),
      ),

    );

    /// Directions API’dan polyline olish
    var routePoints = await CurrentLocationProvider.getRouteCoordinates(
      originLat: currentLatLng!.latitude,
      originLng: currentLatLng!.longitude,
      destLat: destination.latitude,
      destLng: destination.longitude,
    );

    List<LatLng> polylineCoordinates = routePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        width: 6,
        color: Colors.red,
        points: polylineCoordinates,
      ),
    );

    setState(() {});
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body:currentLatLng == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLatLng!,
          zoom: 18,
            ),
        onMapCreated: (controller) => mapController = controller,
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
          ),


    );
  }



  Future<void> checkLocationService(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // GPS o‘chik — dialog chiqaramiz
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location o‘chirilgan"),
          content: Text("Iltimos, joylashuv (GPS) ni yoqing."),
          actions: [
            TextButton(
              child: Text("Bekor qilish"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Location yoqish"),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        ),
      );
    }
  }



}
