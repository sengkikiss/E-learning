import '../entities/assignment.dart';
import '../entities/submission.dart';

abstract class AssignmentRepository {
  Future<List<Assignment>> getAssignmentsByCourse(String courseId);
  Future<Assignment> getAssignmentById(String assignmentId);
  Future<Submission> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  });
  Future<Submission?> getSubmission(String assignmentId, String studentId);
}
