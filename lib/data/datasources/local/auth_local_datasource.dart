import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/storage/secure_storage.dart';
import '../../models/auth/user_model.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData({required String token, required UserModel user});
  Future<String?> getToken();
  Future<UserModel?> getSavedUser();
  Future<void> clearAuthData();
  Future<void> saveUserRole(String role);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;
  final LocalStorage _localStorage;

  AuthLocalDataSourceImpl({
    required SecureStorage secureStorage,
    required LocalStorage localStorage,
  })  : _secureStorage = secureStorage,
        _localStorage = localStorage;

  @override
  Future<void> saveAuthData({required String token, required UserModel user}) async {
    await _secureStorage.write(StorageKeys.authToken, token);
    await _localStorage.setString(StorageKeys.currentUserId, user.id);
    await _localStorage.setString(StorageKeys.currentUserRole, user.role);
    await _localStorage.setString('saved_user_json', jsonEncode(user.toJson()));
  }

  @override
  Future<String?> getToken() => _secureStorage.read(StorageKeys.authToken);

  @override
  Future<UserModel?> getSavedUser() async {
    final userJson = _localStorage.getString('saved_user_json');
    if (userJson == null) return null;
    try {
      final decoded = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    await _secureStorage.delete(StorageKeys.authToken);
    await _localStorage.remove(StorageKeys.currentUserId);
    await _localStorage.remove(StorageKeys.currentUserRole);
    await _localStorage.remove('saved_user_json');
  }

  @override
  Future<void> saveUserRole(String role) async {
    await _localStorage.setString(StorageKeys.currentUserRole, role);
  }
}
