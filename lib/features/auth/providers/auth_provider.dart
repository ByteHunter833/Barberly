import 'package:barberly/core/network/api_service.dart';
import 'package:barberly/features/auth/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.read(apiServiceProvider)),
);
