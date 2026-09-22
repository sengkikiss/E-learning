import '../profile_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/student/student_model.dart';

class RemoteProfileDataSource implements ProfileDataSource {
  final ApiClient _client;

  RemoteProfileDataSource(this._client);

  @override
  Future<StudentModel> getStudentProfile(String studentId) async {
    final response = await _client.get(
      ApiConstants.profile,
      queryParameters: {'studentId': studentId},
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return StudentModel.fromJson(apiResponse.data!);
  }

  @override
  Future<StudentModel> updateProfile({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? profilePhoto,
  }) async {
    final response = await _client.put(
      ApiConstants.updateProfile,
      data: {
        'studentId': studentId,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'educationLevel': educationLevel,
        'profilePhoto': profilePhoto,
      },
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return StudentModel.fromJson(apiResponse.data!);
  }
}
