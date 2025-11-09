import 'package:barberly/core/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/profile_repository.dart';

class ProfileController extends StateNotifier<AsyncValue<User?>> {
  final ProfileRepository _repository;

  ProfileController(this._repository) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final user = await _repository.getProfile();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
