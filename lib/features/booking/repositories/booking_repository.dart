import 'package:barberly/core/network/api_service.dart';

class BookingRepository {
  final ApiService api;

  BookingRepository(this.api);

  Future<Map<String, dynamic>> createOrder({
    required String barberId,
    required int tenantId,
    required List<String> serviceIds,
    required String dateTime,
  }) async {
    final body = {
      'barber_id': barberId,
      'tenant_id': tenantId,
      'service_ids': serviceIds,
      'scheduled_at': dateTime,
    };

    final res = await api.postData('orders', body);
    return res;
  }
}
