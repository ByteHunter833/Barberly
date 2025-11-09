import 'package:barberly/core/models/barber.dart';
import 'package:barberly/features/barbers/repositories/barbers_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class BarbersState {
  final List<Barber> barbers;
  final AsyncValue<void> status;

  BarbersState({this.barbers = const [], this.status = const AsyncData(null)});

  BarbersState copyWith({List<Barber>? barbers, AsyncValue<void>? status}) {
    return BarbersState(
      barbers: barbers ?? this.barbers,
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
}
