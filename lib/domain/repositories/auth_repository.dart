import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> switchDemoRole(UserRole role);
}
