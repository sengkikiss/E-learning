import '../assignment_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/assignment/assignment_model.dart';
import 'package:e_learning/core/error/app_exception.dart';

class FakeAssignmentDataSource implements AssignmentDataSource {
  final FakeApiClient _client;

  FakeAssignmentDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<List<AssignmentModel>> getAssignmentsByCourse(String courseId) async {
    final response = await _client.request<List<AssignmentModel>>(
      dataFetcher: () {
        return FakeDatabase.assignments.where((a) => a.courseId == courseId).toList();
      },
      successMessage: 'Assignments retrieved successfully',
    );
    return response.data ?? [];
  }

  @override
  Future<AssignmentModel> getAssignmentById(String assignmentId) async {
    final response = await _client.request<AssignmentModel>(
      dataFetcher: () {
        final match = FakeDatabase.assignments.cast<AssignmentModel?>().firstWhere(
              (a) => a?.id == assignmentId,
              orElse: () => null,
            );
        if (match == null) {
          throw NotFoundException('Assignment with id "$assignmentId" not found');
        }
        return match;
      },
      successMessage: 'Assignment details retrieved successfully',
    );
    return response.data!;
  }

  @override
  Future<SubmissionModel> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  }) async {
    final response = await _client.request<SubmissionModel>(
      dataFetcher: () {
        if (textSubmission.trim().isEmpty && (submissionFile == null || submissionFile.isEmpty)) {
          throw const ValidationException('Please provide either text submission or an uploaded file');
        }

        // Check if an existing submission exists to update or replace
        FakeDatabase.submissions.removeWhere(
          (s) => s.assignmentId == assignmentId && s.studentId == studentId,
        );

        final newSubmission = SubmissionModel(
          id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
          assignmentId: assignmentId,
          studentId: studentId,
          submissionDate: DateTime.now().toIso8601String(),
          textSubmission: textSubmission,
          submissionFile: submissionFile ?? 'assignment_submission.zip',
          comment: comment,
          status: 'submitted',
          score: null,
          grade: null,
          feedback: null,
          reviewedDate: null,
        );

        FakeDatabase.submissions.add(newSubmission);
        return newSubmission;
      },
      successMessage: 'Assignment submitted successfully',
    );
    return response.data!;
  }

  @override
  Future<SubmissionModel?> getSubmission(String assignmentId, String studentId) async {
    final response = await _client.request<SubmissionModel?>(
      dataFetcher: () {
        return FakeDatabase.submissions.cast<SubmissionModel?>().firstWhere(
              (s) => s?.assignmentId == assignmentId && s?.studentId == studentId,
              orElse: () => null,
            );
      },
      successMessage: 'Submission retrieved',
    );
    return response.data;
  }
}
