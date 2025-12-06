import 'package:barberly/core/models/barber.dart';
import 'package:barberly/core/models/nearest_barber.dart';
import 'package:barberly/features/barbers/repositories/barbers_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class NearestTenantState {
  final List<NearestBarber> nearestTenants;
  final Tenant? tenantDetail; // <-- добавили
  final AsyncValue<void> status;

  NearestTenantState({
    this.nearestTenants = const [],
    this.tenantDetail,
    this.status = const AsyncData(null),
  });

  NearestTenantState copyWith({
    List<NearestBarber>? nearestTenants,
    Tenant? tenantDetail,
    AsyncValue<void>? status,
  }) {
    return NearestTenantState(
      nearestTenants: nearestTenants ?? this.nearestTenants,
      tenantDetail: tenantDetail ?? this.tenantDetail,
      status: status ?? this.status,
    );
  }
}

class BarbersController extends StateNotifier<NearestTenantState> {
  final BarbersRepository repository;

  BarbersController(this.repository) : super(NearestTenantState());

  Future<void> fetchNearestBarber() async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final tenants = await repository.fetchNearestBarber();
      state = state.copyWith(
        nearestTenants: tenants,
        status: const AsyncData(null),
      );
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  Future<void> fetchBarberDetail(int id) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final tenant = await repository.fetchTenatById(id);

      state = state.copyWith(
        tenantDetail: tenant,
        status: const AsyncData(null),
      );
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }
}
