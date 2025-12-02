import 'package:barberly/core/models/nearest_barber.dart';
import 'package:barberly/features/barbers/repositories/barbers_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class NearestTenantState {
  final List<NearestBarber> nearestTenants;
  final AsyncValue<void> status;

  NearestTenantState({
    this.nearestTenants = const [],
    this.status = const AsyncData(null),
  });

  NearestTenantState copyWith({
    List<NearestBarber>? nearestTenants,
    AsyncValue<void>? status,
  }) {
    return NearestTenantState(
      nearestTenants: nearestTenants ?? this.nearestTenants,
      status: status ?? this.status,
    );
  }
}

class BarbersController extends StateNotifier<NearestTenantState> {
  final BarbersRepository repository;

  BarbersController(this.repository) : super(NearestTenantState());

  /// Получение ближайших барберов
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

  Future<void> fetchBarbers() async {}
}
