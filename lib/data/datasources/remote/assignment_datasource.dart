import '../../models/assignment/assignment_model.dart';

abstract class AssignmentDataSource {
  Future<List<AssignmentModel>> getAssignmentsByCourse(String courseId);
  Future<AssignmentModel> getAssignmentById(String assignmentId);
  Future<SubmissionModel> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  });
  Future<SubmissionModel?> getSubmission(String assignmentId, String studentId);
}
