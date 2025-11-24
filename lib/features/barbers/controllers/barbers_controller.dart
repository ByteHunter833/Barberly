import 'package:barberly/core/models/barber.dart';
import 'package:barberly/features/barbers/repositories/barbers_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class BarbersState {
  final List<Barber> barbers;
  final List<Tenant> tenants;
  final Tenant? selectedTenant; // НОВОЕ: Отдельное поле для одного арендатора
  final AsyncValue<void> status;

  BarbersState({
    this.barbers = const [],
    this.tenants = const [],
    this.selectedTenant, // НОВОЕ
    this.status = const AsyncData(null),
  });

  BarbersState copyWith({
    List<Barber>? barbers,
    List<Tenant>? tenants,
    Tenant? selectedTenant, // НОВОЕ
    AsyncValue<void>? status,
  }) {
    return BarbersState(
      barbers: barbers ?? this.barbers,
      tenants: tenants ?? this.tenants,
      selectedTenant: selectedTenant ?? this.selectedTenant, // НОВОЕ
      status: status ?? this.status,
    );
  }
}

class BarbersController extends StateNotifier<BarbersState> {
  final BarbersRepository repository;

  BarbersController(this.repository) : super(BarbersState());

  Future<void> loadBarbers() async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final barbers = await repository.fetchBarbers();
      state = state.copyWith(barbers: barbers, status: const AsyncData(null));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  // boss barbers
  Future<void> fecthTenats() async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final tenants = await repository.fetchTenats();
      state = state.copyWith(tenants: tenants, status: const AsyncData(null));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  //fetch by id
  Future<void> fetchTenantById(int id) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final tenant = await repository.fetchTenantById(id);
      state = state.copyWith(
        selectedTenant:
            tenant, // ИЗМЕНЕНО: Устанавливаем selectedTenant вместо tenants
        status: const AsyncData(null),
      );
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }
}
