import 'package:barberly/features/auth/providers/auth_provider.dart';
import 'package:barberly/features/barbers/controllers/barbers_controller.dart';
import 'package:barberly/features/barbers/repositories/barbers_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Репозиторий
final barbersRepositoryProvider = Provider<BarbersRepository>((ref) {
  final api = ref.read(apiServiceProvider);
  return BarbersRepository(api);
});

// Controller
final barbersControllerProvider =
    StateNotifierProvider<BarbersController, NearestTenantState>(
      (ref) => BarbersController(ref.read(barbersRepositoryProvider)),
    );
