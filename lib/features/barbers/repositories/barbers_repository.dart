import 'package:barberly/core/models/barber.dart';
import 'package:barberly/core/network/api_service.dart';

class BarbersRepository {
  final ApiService api;

  BarbersRepository(this.api);

  Future<List<Barber>> fetchBarbers() async {
    final res = await api.getData('barber-all');
    if (res['success'] == true && res['data'] != null) {
      final List data = res['data'];
      return data.map((b) => Barber.fromJson(b)).toList();
    } else {
      return [];
    }
  }

  Future<List<Tenant>> fetchTenats() async {
    final res = await api.getData('tenants');
    if (res['tenant'] != null) {
      final List data = res['tenant'];
      return data.map((b) => Tenant.fromJson(b)).toList();
    } else {
      return [];
    }
  }

  Future<Tenant?> fetchTenantById(int id) async {
    final res = await api.getData('tenants/$id');

    if (res['tenant'] != null) {
      return Tenant.fromJson(res['tenant']);
    }
    return null;
  }
}
