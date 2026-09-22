import '../progress_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/progress/progress_model.dart';
import 'package:e_learning/data/models/activity/activity_model.dart';
import 'package:e_learning/data/models/certificate/certificate_model.dart';

class RemoteProgressDataSource implements ProgressDataSource {
  final ApiClient _client;

  RemoteProgressDataSource(this._client);

  @override
  Future<CourseProgressModel> getCourseProgress(String courseId, String studentId) async {
    final path = ApiConstants.courseProgress.replaceAll('{courseId}', courseId);
    final response = await _client.get(path, queryParameters: {'studentId': studentId});
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return CourseProgressModel.fromJson(apiResponse.data!);
  }

  @override
  Future<List<LearningActivityModel>> getLearningHistory(String studentId) async {
    final response = await _client.get(
      ApiConstants.learningHistory,
      queryParameters: {'studentId': studentId},
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => LearningActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CertificateModel>> getCertificates(String studentId) async {
    final response = await _client.get(
      ApiConstants.certificates,
      queryParameters: {'studentId': studentId},
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<CertificateModel?> getCertificateById(String certificateId) async {
    final response = await _client.get('${ApiConstants.certificates}/$certificateId');
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return apiResponse.data != null ? CertificateModel.fromJson(apiResponse.data!) : null;
  }
}
