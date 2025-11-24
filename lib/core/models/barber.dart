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
      name: json['name']?.toString() ?? '',
      imageUrl:
          json['imageUrl']?.toString() ??
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=300&fit=crop',

      // rating защищён от int, double, string
      rating: _parseRating(json['rating']),

      location: json['location']?.toString() ?? 'Jogja Expo Centre',
      distance: json['distance']?.toString() ?? '2 km',
      bio:
          json['bio']?.toString() ??
          'Experienced barber specializing in modern styles.',
      services: json['services'] ?? [],
      tenantId: json['tenant_id'], // динамик — можно оставить как есть
    );
  }

  static double _parseRating(dynamic rating) {
    if (rating == null) return 5.4;
    if (rating is num) return rating.toDouble();
    if (rating is String) return double.tryParse(rating) ?? 5.4;
    return 5.4;
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
      name: json['name']?.toString() ?? '',
      imageUrl:
          json['imageUrl']?.toString() ??
          'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=300&fit=crop',

      // rating защищён от int, double, string
      rating: _parseRating(json['rating']),

      location: json['location']?.toString() ?? 'Jogja Expo Centre',
      distance: json['distance']?.toString() ?? '2 km',
      bio:
          json['bio']?.toString() ??
          'Experienced barber specializing in modern styles.',
      services: json['services'] ?? [],
      tenantId: json['tenant_id'],
      barbers: (json['barbers'] as List<dynamic>? ?? [])
          .map((e) => Barber.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static double _parseRating(dynamic rating) {
    if (rating == null) return 5.4;
    if (rating is num) return rating.toDouble();
    if (rating is String) return double.tryParse(rating) ?? 5.4;
    return 5.4;
  }
}
