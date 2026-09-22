import '../../entities/assignment.dart';
import '../../entities/submission.dart';
import '../../repositories/assignment_repository.dart';

class GetAssignmentsUseCase {
  final AssignmentRepository repository;
  GetAssignmentsUseCase(this.repository);

  Future<List<Assignment>> execute(String courseId) => repository.getAssignmentsByCourse(courseId);
}

class GetAssignmentDetailUseCase {
  final AssignmentRepository repository;
  GetAssignmentDetailUseCase(this.repository);

  Future<Assignment> execute(String assignmentId) => repository.getAssignmentById(assignmentId);
}

class SubmitAssignmentUseCase {
  final AssignmentRepository repository;
  SubmitAssignmentUseCase(this.repository);

  Future<Submission> execute({
    required String assignmentId,
    required String studentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  }) {
    return repository.submitAssignment(
      assignmentId: assignmentId,
      studentId: studentId,
      textSubmission: textSubmission,
      submissionFile: submissionFile,
      comment: comment,
    );
  }
}

class GetSubmissionUseCase {
  final AssignmentRepository repository;
  GetSubmissionUseCase(this.repository);

  Future<Submission?> execute(String assignmentId, String studentId) {
    return repository.getSubmission(assignmentId, studentId);
  }
}
