



class PostLatlng {
  final int tenantId;
  final List<int> serviceIds;
  final int barberId;
  final double lat;
  final double lng;

  PostLatlng({
    required this.tenantId,
    required this.serviceIds,
    required this.barberId,
    required this.lat,
    required this.lng,


  });

  factory PostLatlng.fromJson(Map<String, dynamic> json) {
    return PostLatlng(
      tenantId: json['tenant_id'] as int,
      serviceIds: List<int>.from(json['service_ids']),
      barberId: json['barber_id'] as int,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenant_id': tenantId,
      'service_ids': serviceIds,
      'barber_id': barberId,
      'lat': lat,
      'lng': lng,
    };
  }
}


