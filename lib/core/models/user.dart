import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  final int id;
  final String name;
  final String phone;
  final String balance;
  final LatLng? location;
  final String rating;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
    this.location,
    required this.rating,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      balance: json['balance'],
      location: json['location'] ?? 'Bucharest, Romania',
      rating: json['rating'],
    );
  }
}
