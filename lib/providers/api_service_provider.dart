import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:barberly/services/api_service.dart';

final apiServiceprovider = Provider<ApiService>((ref) {
  return ApiService();
});

class AuthState {
  final dynamic user;
  final AsyncValue<dynamic> status;

  AuthState({this.user, this.status = const AsyncData(null)});

  AuthState copyWith({dynamic user, AsyncValue<dynamic>? status}) {
    return AuthState(user: user ?? this.user, status: status ?? this.status);
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(AuthState());

  final Ref ref;

  Future<void> login(String phone, String password) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceprovider);
      final res = await api.postData('login', {
        'phone': phone,
        'password': password,
      });

      final user = res['user'];

      state = state.copyWith(user: user, status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  Future<void> register(String name, String phone, String password) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceprovider);
      final res = await api.postData('register', {
        'name': name,
        'phone': phone,
        'password': password,
      });

      final user = res['user'];

      state = state.copyWith(user: user, status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  Future<void> resendCode(String phone) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceprovider);
      final res = await api.postData('resend', {'phone': phone});

      state = state.copyWith(status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceprovider);
      final res = await api.postData('verify', {'phone': phone, 'code': code});

      final user = res['user'];

      state = state.copyWith(user: user, status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref);
  },
);
