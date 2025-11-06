import 'dart:async';

import 'package:barberly/services/api_service.dart';
import 'package:barberly/services/localstorage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ApiService();

  // ← достаём сохранённый токен асинхронно и устанавливаем его, когда он станет доступен
  LocalStorage.getToken().then((token) {
    if (token != null) {
      api.setToken(token);
    }
  });

  return api;
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
  // Login user
  Future<void> login(String phone, String password) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.postData('login', {
        'phone': phone,
        'password': password,
      });

      final token = res['data']['token'];
      await LocalStorage.saveToken(token);
      api.setToken(token);
      final user = res['data']['user']['name'];
      await LocalStorage.saveUsername(user);
      state = state.copyWith(user: user, status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  // Register user
  Future<void> register(String name, String phone, String password) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.postData('register', {
        'name': name,
        'phone': phone,
        'password': password,
      });

      state = state.copyWith(user: null, status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  // Verify OTP code
  Future<void> verifyOtp(String phone, String code) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.postData('verify', {'phone': phone, 'code': code});

      final token = res['data']['token'];
      await LocalStorage.saveToken(token);
      api.setToken(token);
      final user = res['data']['user']['name'];
      await LocalStorage.saveUsername(user);

      state = state.copyWith(user: user, status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  //Resend OTP code
  Future<void> resendCode(String phone) async {
    state = state.copyWith(status: const AsyncLoading());
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.postData('resend', {'phone': phone});

      state = state.copyWith(status: AsyncData(res));
    } catch (e, st) {
      state = state.copyWith(status: AsyncError(e, st));
    }
  }

  // Logout user
  Future<void> logOut() async {
    state = state.copyWith(status: const AsyncLoading());

    try {
      final api = ref.read(apiServiceProvider);

      print('Token before logout: ${await LocalStorage.getToken()}');
      await api.postData('logout', {});
      print('Logout request success, clearing storage...');

      // Clear everything in correct order
      await LocalStorage.clearToken();
      await LocalStorage.clearUserInfo();
      api.clearToken();

      // Important: Set BOTH user=null AND status=AsyncData to trigger navigation
      state = AuthState(
        user: null,
        status: const AsyncData({'success': true, 'message': 'Logged out'}),
      );
    } catch (e, st) {
      print('Logout error: $e');
      state = state.copyWith(status: AsyncError(e, st));
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref);
  },
);
