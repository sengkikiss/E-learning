import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';
import '../../../../core/di/dependency_injection.dart';

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthStateNotifier(this._ref) : super(const AsyncValue.loading()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(getCurrentUserUseCaseProvider).execute();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(loginUseCaseProvider).execute(email, password);
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(registerUseCaseProvider).execute(
            fullName: fullName,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
          );
      state = AsyncValue.data(user);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(logoutUseCaseProvider).execute();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> switchDemoRole(UserRole role) async {
    try {
      await _ref.read(authRepositoryProvider).switchDemoRole(role);
      await checkCurrentUser();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  return AuthStateNotifier(ref);
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).valueOrNull;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});
