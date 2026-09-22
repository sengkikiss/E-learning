import '../../domain/entities/assignment.dart';
import '../../domain/entities/submission.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../datasources/remote/assignment_datasource.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentDataSource _dataSource;

  AssignmentRepositoryImpl(this._dataSource);

  @override
  Future<List<Assignment>> getAssignmentsByCourse(String courseId) async {
    final models = await _dataSource.getAssignmentsByCourse(courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Assignment> getAssignmentById(String assignmentId) async {
    final model = await _dataSource.getAssignmentById(assignmentId);
    return model.toEntity();
  }

  @override
  Future<Submission> submitAssignment({
    required String assignmentId,
    required String studentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  }) async {
    final model = await _dataSource.submitAssignment(
      assignmentId: assignmentId,
      studentId: studentId,
      textSubmission: textSubmission,
      submissionFile: submissionFile,
      comment: comment,
    );
    return model.toEntity();
  }

  @override
  Future<Submission?> getSubmission(String assignmentId, String studentId) async {
    final model = await _dataSource.getSubmission(assignmentId, studentId);
    return model?.toEntity();
  }
}
