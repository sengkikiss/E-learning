import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/assignment.dart';
import '../../../../domain/entities/submission.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/auth/presentation/providers/auth_providers.dart';

final assignmentsProvider = FutureProvider.family<List<Assignment>, String>((ref, courseId) async {
  return ref.watch(getAssignmentsUseCaseProvider).execute(courseId);
});

final assignmentDetailProvider = FutureProvider.family<Assignment, String>((ref, assignmentId) async {
  return ref.watch(getAssignmentDetailUseCaseProvider).execute(assignmentId);
});

final submissionProvider = FutureProvider.family<Submission?, String>((ref, assignmentId) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(getSubmissionUseCaseProvider).execute(assignmentId, studentId);
});

class AssignmentSubmissionNotifier extends StateNotifier<AsyncValue<Submission?>> {
  final Ref _ref;

  AssignmentSubmissionNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> submit({
    required String assignmentId,
    required String textSubmission,
    String? submissionFile,
    String? comment,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      final studentId = user?.id ?? 'usr_student_01';

      final submission = await _ref.read(submitAssignmentUseCaseProvider).execute(
            assignmentId: assignmentId,
            studentId: studentId,
            textSubmission: textSubmission,
            submissionFile: submissionFile,
            comment: comment,
          );

      _ref.invalidate(submissionProvider(assignmentId));
      state = AsyncValue.data(submission);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final assignmentSubmissionNotifierProvider = StateNotifierProvider<AssignmentSubmissionNotifier, AsyncValue<Submission?>>((ref) {
  return AssignmentSubmissionNotifier(ref);
});
