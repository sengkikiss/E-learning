import '../enrollment_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/enrollment/enrollment_model.dart';
import 'package:e_learning/data/models/course/course_model.dart';

class RemoteEnrollmentDataSource implements EnrollmentDataSource {
  final ApiClient _client;

  RemoteEnrollmentDataSource(this._client);

  @override
  Future<EnrollmentModel> enrollInCourse(String courseId, String studentId) async {
    final response = await _client.post(
      ApiConstants.enrollCourse,
      data: {'courseId': courseId, 'studentId': studentId},
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return EnrollmentModel.fromJson(apiResponse.data!);
  }

  @override
  Future<List<CourseModel>> getEnrolledCourses(String studentId) async {
    final response = await _client.get(
      ApiConstants.myEnrollments,
      queryParameters: {'studentId': studentId},
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<bool> isEnrolled(String courseId, String studentId) async {
    final response = await _client.get(
      '${ApiConstants.enrollments}/check',
      queryParameters: {'courseId': courseId, 'studentId': studentId},
    );
    final apiResponse = ApiResponse<bool>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as bool,
    );
    return apiResponse.data ?? false;
  }

  @override
  Future<EnrollmentModel?> getEnrollment(String courseId, String studentId) async {
    final response = await _client.get(
      '${ApiConstants.enrollments}/detail',
      queryParameters: {'courseId': courseId, 'studentId': studentId},
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return apiResponse.data != null ? EnrollmentModel.fromJson(apiResponse.data!) : null;
  }
}
