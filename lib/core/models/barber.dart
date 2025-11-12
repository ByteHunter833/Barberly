class Barber {
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
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      firebaseuid: json['firebaseuid'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl:
          json['imageUrl'] ??
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=300&fit=crop',
      rating: double.tryParse(json['rating'] ?? '5.4') ?? 5.4,
      location: json['location'] ?? 'Jogja Expo Centre',
      distance: json['distance'] ?? '2 km',
      bio: json['bio'] ?? 'Experienced barber specializing in modern styles.',
      services: json['services'] ?? [],
    );
  }
}
