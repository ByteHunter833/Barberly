class Barber {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String? location;
  final String? distance;
  final String? bio;

  Barber({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.location,
    this.distance,
    this.bio,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl:
          json['imageUrl'] ??
          'https://storage.googleapis.com/default-avatar.jpg',
      rating: double.tryParse(json['rating'] ?? '5.4') ?? 5.4,
      location: json['location'] ?? 'Jogja Expo Centre',
      distance: json['distance'] ?? '2 km',
      bio: json['bio'] ?? 'Experienced barber specializing in modern styles.',
    );
  }
}
