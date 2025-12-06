import 'package:barberly/core/models/barber.dart';
import 'package:barberly/core/models/nearest_barber.dart';
import 'package:barberly/core/network/api_service.dart';
import 'package:barberly/features/barbers/providers/current_location_provider.dart';

class BarbersRepository {
  final ApiService api;

  BarbersRepository(this.api);

  Future<List<NearestBarber>> fetchNearestBarber() async {
    final position = await CurrentLocationProvider.determinePosition();

    final response = await api.getData(
      'tenants/nearest?lat=${position.latitude}&lng=${position.longitude}',
    );

    if (response == null || response['data'] == null) {
      throw Exception('Failed to fetch nearest barbers');
    }

    final tenants = response['data'] as List<dynamic>;

    return tenants
        .map((json) => NearestBarber.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Tenant> fetchTenatById(int id) async {
    final response = await api.getData('tenants/$id');

    if (response == null) {
      throw Exception('Failed to fetch tenant');
    }
    final tenant = response['tenant'];
    return Tenant.fromJson(tenant);
  }
}
