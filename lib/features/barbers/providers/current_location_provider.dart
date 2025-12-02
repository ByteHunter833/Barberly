import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CurrentLocationProvider {
  static const String apiKey = 'AIzaSyBou7yLG7rVTdVia1xOOD-sKrCcjIfnIhs';
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // GPS yoqilganmi?
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('GPS yoqilmagan!');
    }

    // Permission tekshirish
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission rad etildi!');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permission doimiy rad etilgan!');
    }

    // Lokatsiyani olish
    return await Geolocator.getCurrentPosition();
  }

  static Future<List<PointLatLng>> getRouteCoordinates({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=$originLat,$originLng&destination=$destLat,$destLng&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);

    if (data['status'] != 'OK') {
      throw Exception("Directions API error: ${data["error_message"]}");
    }

    String encodedPolyline = data['routes'][0]['overview_polyline']['points'];

    // PolylinePoints points = PolylinePoints(apiKey: apiKey);
    return PolylinePoints.decodePolyline(encodedPolyline);
  }
}
