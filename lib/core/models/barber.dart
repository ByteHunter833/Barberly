import 'package:google_maps_flutter/google_maps_flutter.dart';

class Barber {
  final dynamic tenantId;
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String? location;
  final String? distance;
  final String? bio;
  final String? phone;
  final String? email;
  final dynamic services;
  final String? firebaseuid;

  Barber({
    required this.firebaseuid,
    required this.id,
    required this.phone,
    required this.email,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.location,
    this.distance,
    this.bio,
    this.services,
    this.tenantId,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      firebaseuid: json['firebaseuid']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      imageUrl:
          json['image']?.toString() ??
          json['imageUrl']?.toString() ??
          'https://placehold.co/200x200', // fallback

      rating: _parseRating(json['rating']),

      location: 'Joga Expo Centre  (2 km)',
      distance: json['distance']?.toString() ?? '',
      bio: json['bio']?.toString() ?? 'Experienced Barber',
      services: json['services'] ?? [],
      tenantId: json['tenant_id'],
    );
  }

  static double _parseRating(dynamic rating) {
    if (rating == null) return 5.0;
    if (rating is num) return rating.toDouble();
    if (rating is String) return double.tryParse(rating) ?? 5.0;
    return 5.0;
  }
}

class Tenant {
  final dynamic tenantId;
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String? location;
  final String? distance;
  final String? bio;
  final String? phone;
  final String? email;
  final dynamic services;
  final String? firebaseuid;
  final List<Barber>? barbers;

  Tenant({
    required this.firebaseuid,
    this.barbers,
    required this.id,
    required this.phone,
    required this.email,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.location,
    this.distance,
    this.bio,
    this.services,
    this.tenantId,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      firebaseuid: json['firebaseuid']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      imageUrl:
          json['image']?.toString() ??
          json['imageUrl']?.toString() ??
          'https://placehold.co/200x200',

      rating: _parseRating(json['rating']),
      location: 'Joga Expo Centre  (2 km)',
      distance: json['distance']?.toString() ?? '',

      bio: json['bio']?.toString() ?? 'Experiendced Barber',
      services: json['services'] ?? [],
      tenantId: json['tenant_id'],

      barbers: (json['barbers'] as List<dynamic>? ?? [])
          .map((e) => Barber.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static double _parseRating(dynamic rating) {
    if (rating == null) return 5.0;
    if (rating is num) return rating.toDouble();
    if (rating is String) return double.tryParse(rating) ?? 5.0;
    return 5.0;
  }
}

// ignore: unused_element
LatLng? _parseLatLng(Map<String, dynamic> json) {
  try {
    if (json['location'] != null) {
      final txt = json['location'].toString();
      final match = RegExp(r'LatLng\((.*?), (.*?)\)').firstMatch(txt);
      if (match != null) {
        return LatLng(
          double.parse(match.group(1)!),
          double.parse(match.group(2)!),
        );
      }
    }

    if (json['latitude'] != null && json['longitude'] != null) {
      return LatLng(
        double.tryParse(json['latitude'].toString()) ?? 0.0,
        double.tryParse(json['longitude'].toString()) ?? 0.0,
      );
    }
  } catch (_) {}

  return null;
}
