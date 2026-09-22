import '../assignment_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/assignment/assignment_model.dart';

class RemoteAssignmentDataSource implements AssignmentDataSource {
  final ApiClient _client;

  RemoteAssignmentDataSource(this._client);

  @override
  Future<List<AssignmentModel>> getAssignmentsByCourse(String courseId) async {
    final path = ApiConstants.assignmentsByCourse.replaceAll('{courseId}', courseId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => AssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<AssignmentModel> getAssignmentById(String assignmentId) async {
    final path = ApiConstants.assignmentDetail.replaceAll('{id}', assignmentId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return AssignmentModel.fromJson(apiResponse.data!);
  }

  @override
  Future<SubmissionModel> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  }) async {
    final path = ApiConstants.submitAssignment.replaceAll('{id}', assignmentId);
    final response = await _client.post(
      path,
      data: {
        'studentId': studentId,
        'textSubmission': textSubmission,
        'submissionFile': submissionFile,
        'comment': comment,
      },
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return SubmissionModel.fromJson(apiResponse.data!);
  }

  @override
  Future<SubmissionModel?> getSubmission(String assignmentId, String studentId) async {
    final path = ApiConstants.mySubmissions.replaceAll('{id}', assignmentId);
    final response = await _client.get(path, queryParameters: {'studentId': studentId});
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return apiResponse.data != null ? SubmissionModel.fromJson(apiResponse.data!) : null;
  }
}
