class CreateOrderResponse {
  final bool success;
  final String message;
  final Order data;
  final int calculatedPrice;
  final List<NearestTenant> nearestTenants;

  CreateOrderResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.calculatedPrice,
    required this.nearestTenants,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      success: json['success'],
      message: json['message'],
      data: Order.fromJson(json['data']),
      calculatedPrice: json['calculated_price'] ?? 0,
      nearestTenants: (json['nearest_tenants'] as List)
          .map((e) => NearestTenant.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'calculated_price': calculatedPrice,
      'nearest_tenants':
      nearestTenants.map((e) => e.toJson()).toList(),
    };
  }
}

class Order {
  final int tenantId;
  final int userId;
  final int barberId;
  final String status;
  final String orderedAt;
  final String updatedAt;
  final String createdAt;
  final int id;
  final List<Service> service;
  final dynamic userService;
  final Tenant tenant;
  final Barber barber;

  Order({
    required this.tenantId,
    required this.userId,
    required this.barberId,
    required this.status,
    required this.orderedAt,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.service,
    required this.userService,
    required this.tenant,
    required this.barber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      tenantId: json['tenant_id'],
      userId: json['user_id'],
      barberId: json['barber_id'],
      status: json['status'],
      orderedAt: json['ordered_at'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      service: (json['service'] as List)
          .map((e) => Service.fromJson(e))
          .toList(),
      userService: json['user_service'],
      tenant: Tenant.fromJson(json['tenant']),
      barber: Barber.fromJson(json['barber']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenant_id': tenantId,
      'user_id': userId,
      'barber_id': barberId,
      'status': status,
      'ordered_at': orderedAt,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
      'service': service.map((e) => e.toJson()).toList(),
      'user_service': userService,
      'tenant': tenant.toJson(),
      'barber': barber.toJson(),
    };
  }
}

class Service {
  final int id;
  final String name;
  final String price;
  final String serviceDuration;
  final String createdAt;
  final String updatedAt;
  final String? image;
  final Pivot pivot;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.serviceDuration,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.pivot,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      serviceDuration: json['service_duration'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'service_duration': serviceDuration,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
      'pivot': pivot.toJson(),
    };
  }
}
class Pivot {
  final int orderId;
  final int serviceId;
  final String price;
  final String createdAt;
  final String updatedAt;

  Pivot({
    required this.orderId,
    required this.serviceId,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      orderId: json['order_id'],
      serviceId: json['service_id'],
      price: json['price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'service_id': serviceId,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
class Tenant {
  final int id;
  final String name;
  final String adminName;
  final String phone;
  final String monthlyPrice;
  final int remainingBalance;
  final int lastPayment;
  final String balance;
  final int subscriptionPlanId;
  final String database;
  final String domain;
  final int? adminId;
  final String createdAt;
  final String updatedAt;
  final String? districtName;
  final String? streetName;
  final String? latitude;
  final String? longitude;

  Tenant({
    required this.id,
    required this.name,
    required this.adminName,
    required this.phone,
    required this.monthlyPrice,
    required this.remainingBalance,
    required this.lastPayment,
    required this.balance,
    required this.subscriptionPlanId,
    required this.database,
    required this.domain,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
    required this.districtName,
    required this.streetName,
    required this.latitude,
    required this.longitude,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      adminName: json['admin_name'],
      phone: json['phone'],
      monthlyPrice: json['monthly_price'],
      remainingBalance: json['remaining_balance'],
      lastPayment: json['last_payment'],
      balance: json['balance'],
      subscriptionPlanId: json['subscription_plan_id'],
      database: json['database'],
      domain: json['domain'],
      adminId: json['admin_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      districtName: json['district_name'],
      streetName: json['street_name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'admin_name': adminName,
      'phone': phone,
      'monthly_price': monthlyPrice,
      'remaining_balance': remainingBalance,
      'last_payment': lastPayment,
      'balance': balance,
      'subscription_plan_id': subscriptionPlanId,
      'database': database,
      'domain': domain,
      'admin_id': adminId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'district_name': districtName,
      'street_name': streetName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
class Barber {
  final int id;
  final String name;
  final String phone;
  final String balance;
  final String? phoneVerifiedAt;
  final int tenantId;
  final String? rememberToken;
  final String createdAt;
  final String updatedAt;
  final int points;
  final int addedBy;
  final String? location;
  final String? distance;
  final String rating;

  Barber({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
    required this.phoneVerifiedAt,
    required this.tenantId,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.points,
    required this.addedBy,
    required this.location,
    required this.distance,
    required this.rating,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      balance: json['balance'],
      phoneVerifiedAt: json['phone_verified_at'],
      tenantId: json['tenant_id'],
      rememberToken: json['remember_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      points: json['points'],
      addedBy: json['added_by'],
      location: json['location'],
      distance: json['distance'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'balance': balance,
      'phone_verified_at': phoneVerifiedAt,
      'tenant_id': tenantId,
      'remember_token': rememberToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'points': points,
      'added_by': addedBy,
      'location': location,
      'distance': distance,
      'rating': rating,
    };
  }
}
class NearestTenant {
  final int id;
  final String name;
  final String distance;
  final int distanceM;
  final String location;

  NearestTenant({
    required this.id,
    required this.name,
    required this.distance,
    required this.distanceM,
    required this.location,
  });

  factory NearestTenant.fromJson(Map<String, dynamic> json) {
    return NearestTenant(
      id: json['id'],
      name: json['name'],
      distance: json['distance'],
      distanceM: json['distance_m'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
      'distance_m': distanceM,
      'location': location,
    };
  }
}
