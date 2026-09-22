import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_datasource.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../models/auth/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<User> login({required String email, required String password}) async {
    final userModel = await _remoteDataSource.login(email: email, password: password);
    if (userModel.token != null) {
      await _localDataSource.saveAuthData(token: userModel.token!, user: userModel);
    }
    return userModel.toEntity();
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final userModel = await _remoteDataSource.register(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    if (userModel.token != null) {
      await _localDataSource.saveAuthData(token: userModel.token!, user: userModel);
    }
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Ignore network errors on logout
    }
    await _localDataSource.clearAuthData();
  }

  @override
  Future<User?> getCurrentUser() async {
    final savedUser = await _localDataSource.getSavedUser();
    if (savedUser != null) {
      return savedUser.toEntity();
    }

    final token = await _localDataSource.getToken();
    if (token == null || token.isEmpty) return null;

    final userModel = await _remoteDataSource.getCurrentUser(token);
    if (userModel != null) {
      await _localDataSource.saveAuthData(token: token, user: userModel);
      return userModel.toEntity();
    }

    return null;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> switchDemoRole(UserRole role) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(role: role);
      await _localDataSource.saveUserRole(role.name);
      await _localDataSource.saveAuthData(
        token: currentUser.token ?? 'demo_token',
        user: UserModel(
          id: updatedUser.id,
          email: updatedUser.email,
          fullName: updatedUser.fullName,
          role: updatedUser.role.name,
          profilePhoto: updatedUser.profilePhoto,
          token: updatedUser.token,
          refreshToken: updatedUser.refreshToken,
        ),
      );
    }
  }
}
