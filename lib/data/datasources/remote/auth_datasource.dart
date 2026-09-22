import '../../models/auth/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser(String token);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
