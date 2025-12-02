import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:barberly/features/barbers/providers/current_location_provider.dart';

class MapScreen extends StatefulWidget {
  final LatLng? location;

  const MapScreen({super.key, required this.location});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // LatLng? currentLatLng;
  LatLng? origin;
  GoogleMapController? mapController;
  bool isOnline = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  // BitmapDescriptor? customIcon;
  Position? lastPosition;

  LatLng destination = const LatLng(41.565574, 60.646030);
  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  // }
  // Future<void> _loadCustomIcon() async {
  //   final Uint8List iconBytes = await getBytesFromAsset('assets/images/banner_logo.png', 100); // Adjust width as needed
  //   setState(() {
  //     customIcon = BitmapDescriptor.fromBytes(iconBytes);
  //   });
  // }

  // Future<void> getLocation() async {
  //   // _loadCustomIcon();
  //   try {
  //     final pos = await CurrentLocationProvider.determinePosition();
  //     setState(() {
  //       // currentLatLng =  LatLng(41.542452,60.632785);        //LatLng(pos.latitude, pos.longitude);
  //       _markers = {
  //         Marker(
  //           markerId: const MarkerId("myLocation"),
  //           position: currentLatLng!,
  //           infoWindow: const InfoWindow(title: "Mening joylashuvim"),
  //         )
  //       };
  //     });
  //     // Kamerani shu joyga olib borish
  //     mapController?.animateCamera(
  //       CameraUpdate.newLatLngZoom(currentLatLng!, 16),
  //     );
  //   } catch (e) {
  //     print("Xatolik: $e");
  //   }
  // }

  Future<void> _initializeMap() async {
    // await _loadCustomIcon();       // marker icon 1-bo‘lib yuklanadi
    // await getLocation();           // user joyi olinadi
    // await _getLocationAndDrawRoute(); // route + markerlar chiziladi
    listenLocationChanges();
  }

  @override
  void initState() {
    super.initState();
    // _loadCustomIcon();
    // getLocation();
    // _getLocationAndDrawRoute();

    _initializeMap();
  }

  // Future<void> _getLocationAndDrawRoute() async {
  //   Position pos = await Geolocator.getCurrentPosition();
  //
  //   currentLatLng = LatLng(pos.latitude, pos.longitude);
  //
  //   _markers.add(
  //     Marker(
  //       markerId: const MarkerId("origin"),
  //       position: currentLatLng!,
  //         icon: customIcon ?? BitmapDescriptor.defaultMarker,
  //       infoWindow: const InfoWindow(title: "Sizning joyingiz"),
  //     ),
  //   );
  //
  //   _markers.add(
  //     Marker(
  //       markerId: const MarkerId("destination"),
  //       position: destination,
  //       infoWindow: const InfoWindow(title: "Manzil"),
  //         icon: customIcon ?? BitmapDescriptor.defaultMarker
  //     ),
  //
  //   );
  //
  //   /// Directions API’dan polyline olish
  //   var routePoints = await CurrentLocationProvider.getRouteCoordinates(
  //     originLat: currentLatLng!.latitude,
  //     originLng: currentLatLng!.longitude,
  //     destLat:  destination.latitude,
  //     destLng:  destination.longitude,
  //   );
  //
  //   List<LatLng> polylineCoordinates = routePoints
  //       .map((p) => LatLng(p.latitude, p.longitude))
  //       .toList();
  //
  //   _polylines.add(
  //     Polyline(
  //       polylineId: const PolylineId("route"),
  //       width: 6,
  //       color: Colors.red,
  //       points: polylineCoordinates,
  //     ),
  //   );
  //
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: origin == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: origin!, zoom: 18),
              onMapCreated: (controller) => mapController = controller,
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }

  Stream<Position> locationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // 5 metr yurilganda trigger bo‘ladi
      ),
    );
  }

  /// Doimiy location kuzatish
  void listenLocationChanges() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 5, // 5 metr harakat bo'lsa trigger
        accuracy: LocationAccuracy.high,
      ),
    ).listen((Position position) {
      drawPolyline(position);
    });
  }

  /// Polyline chizishni update qilish
  Future<void> drawPolyline(Position pos) async {
    // Agar location o'zgarmagan bo'lsa — polyline qayta chizmaymiz!
    if (lastPosition != null) {
      final distance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        pos.latitude,
        pos.longitude,
      );

      if (distance < 5) return; // 5 metrdan kam o'zgarish bo’lsa skip
    }

    lastPosition = pos;

    origin = LatLng(pos.latitude, pos.longitude);

    // Polyline API chaqirish
    var points = await CurrentLocationProvider.getRouteCoordinates(
      originLat: pos.latitude,
      originLng: pos.longitude,
      destLat: destination.latitude,
      destLng: destination.longitude,
    );

    List<LatLng> coords = points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    setState(() {
      _polylines.clear(); // eski polylineni o'chirish

      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          width: 6,
          color: Colors.blue,
          points: coords,
        ),
      );

      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('me'),
          position: origin!,
          infoWindow: const InfoWindow(title: 'Siz'),
        ),
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('dest'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Manzil'),
        ),
      );
    });
  }

  // Future<void> checkLocationService(BuildContext context) async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //
  //   if (!serviceEnabled) {
  //     // GPS o‘chik — dialog chiqaramiz
  //     showDialog(
  //       context: context,
  //       builder: (context) =>
  //           AlertDialog(
  //             title: Text("Location o‘chirilgan"),
  //             content: Text("Iltimos, joylashuv (GPS) ni yoqing."),
  //             actions: [
  //               TextButton(
  //                 child: Text("Bekor qilish"),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //               TextButton(
  //                 child: Text("Location yoqish"),
  //                 onPressed: () async {
  //                   Navigator.pop(context);
  //                   await Geolocator.openLocationSettings();
  //                 },
  //               ),
  //             ],
  //           ),
  //     );
  //   }
  // }
}
