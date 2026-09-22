import '../auth_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/auth/user_model.dart';

class RemoteAuthDataSource implements AuthDataSource {
  final ApiClient _client;

  RemoteAuthDataSource(this._client);

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final response = await _client.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return UserModel.fromJson(apiResponse.data!);
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final response = await _client.post(
      ApiConstants.register,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      },
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return UserModel.fromJson(apiResponse.data!);
  }

  @override
  Future<void> logout() async {
    await _client.post(ApiConstants.logout);
  }

  @override
  Future<UserModel?> getCurrentUser(String token) async {
    final response = await _client.get(ApiConstants.currentUser);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return apiResponse.data != null ? UserModel.fromJson(apiResponse.data!) : null;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.post(
      ApiConstants.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
