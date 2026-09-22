import '../auth_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/auth/user_model.dart';
import 'package:e_learning/core/error/app_exception.dart';

class FakeAuthDataSource implements AuthDataSource {
  final FakeApiClient _client;

  FakeAuthDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final response = await _client.request<UserModel>(
      dataFetcher: () {
        final match = FakeDatabase.users.cast<UserModel?>().firstWhere(
              (u) => u?.email.toLowerCase() == email.trim().toLowerCase(),
              orElse: () => null,
            );

        if (match == null) {
          // If not found, default to student or throw if password is invalid
          if (password.length < 6) {
            throw const ValidationException('Password must be at least 6 characters');
          }
          return UserModel(
            id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
            email: email,
            fullName: email.split('@').first,
            role: 'student',
            token: 'fake_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
            refreshToken: 'fake_refresh_${DateTime.now().millisecondsSinceEpoch}',
          );
        }

        return match;
      },
      successMessage: 'User logged in successfully',
    );
    return response.data!;
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final response = await _client.request<UserModel>(
      dataFetcher: () {
        final existing = FakeDatabase.users.any((u) => u.email.toLowerCase() == email.trim().toLowerCase());
        if (existing) {
          throw const ValidationException('User with this email already exists');
        }

        final newUser = UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          fullName: fullName,
          role: 'student',
          profilePhoto: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
          token: 'fake_jwt_token_new_${DateTime.now().millisecondsSinceEpoch}',
          refreshToken: 'fake_refresh_token_new_${DateTime.now().millisecondsSinceEpoch}',
        );
        FakeDatabase.users.add(newUser);
        return newUser;
      },
      successMessage: 'Account registered successfully',
    );
    return response.data!;
  }

  @override
  Future<void> logout() async {
    await _client.request<bool>(
      dataFetcher: () => true,
      successMessage: 'User logged out successfully',
    );
  }

  @override
  Future<UserModel?> getCurrentUser(String token) async {
    final response = await _client.request<UserModel?>(
      dataFetcher: () {
        return FakeDatabase.users.cast<UserModel?>().firstWhere(
              (u) => u?.token == token,
              orElse: () => FakeDatabase.users.first,
            );
      },
    );
    return response.data;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.request<bool>(
      dataFetcher: () {
        if (newPassword.length < 6) {
          throw const ValidationException('New password must be at least 6 characters');
        }
        return true;
      },
      successMessage: 'Password changed successfully',
    );
  }
}
