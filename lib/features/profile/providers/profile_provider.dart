import 'package:barberly/core/models/user.dart';
import 'package:barberly/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../controllers/profile_controller.dart';
import '../repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final api = ref.read(apiServiceProvider);

  return ProfileRepository(api);
});

final profileControllerProvider =
    StateNotifierProvider<ProfileController, AsyncValue<User?>>((ref) {
      final repository = ref.read(profileRepositoryProvider);
      return ProfileController(repository);
    });
