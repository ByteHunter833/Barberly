class NearestBarber {
  final int id;
  final String name;
  final double distanceKm;
  final double distanceMeters;
  final double latitude;
  final double longitude;

  // Новые поля для UI
  final String imageUrl;
  final double rating;
  final String startingPrice;
  final List<String> services;

  NearestBarber({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.distanceMeters,
    required this.latitude,
    required this.longitude,
    this.imageUrl = 'assets/images/nearbarber1.png',
    this.rating = 4.5,
    this.startingPrice = '—',
    this.services = const [],
  });

  factory NearestBarber.fromJson(Map<String, dynamic> json) {
    final locString = json['location'] as String;
    final coords = locString
        .replaceAll('LatLng(', '')
        .replaceAll(')', '')
        .split(',');

    return NearestBarber(
      id: json['id'],
      name: json['name'],
      distanceKm:
          double.tryParse((json['distance'] as String).replaceAll(' km', '')) ??
          0,
      distanceMeters: (json['distance_m'] as num).toDouble(),
      latitude: double.parse(coords[0]),
      longitude: double.parse(coords[1]),
    );
  }
}
