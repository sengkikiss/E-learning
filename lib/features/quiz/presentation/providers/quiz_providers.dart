import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/quiz.dart';
import '../../../../domain/entities/quiz_attempt.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/auth/presentation/providers/auth_providers.dart';

final quizByLessonProvider = FutureProvider.family<Quiz, String>((ref, lessonId) async {
  return ref.watch(getQuizUseCaseProvider).execute(lessonId);
});

final quizDetailProvider = FutureProvider.family<Quiz, String>((ref, quizId) async {
  return ref.watch(getQuizByIdUseCaseProvider).execute(quizId);
});

final quizAttemptsProvider = FutureProvider.family<List<QuizAttempt>, String>((ref, quizId) async {
  return ref.watch(getQuizAttemptsUseCaseProvider).execute(quizId);
});

class QuizSubmissionNotifier extends StateNotifier<AsyncValue<QuizAttempt?>> {
  final Ref _ref;

  QuizSubmissionNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<QuizAttempt?> submitQuiz({
    required String quizId,
    required Map<int, int> selectedAnswers,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      final studentId = user?.id ?? 'usr_student_01';

      final attempt = await _ref.read(submitQuizAttemptUseCaseProvider).execute(
            quizId: quizId,
            studentId: studentId,
            selectedAnswers: selectedAnswers,
          );

      _ref.invalidate(quizAttemptsProvider(quizId));
      state = AsyncValue.data(attempt);
      return attempt;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final quizSubmissionNotifierProvider = StateNotifierProvider<QuizSubmissionNotifier, AsyncValue<QuizAttempt?>>((ref) {
  return QuizSubmissionNotifier(ref);
});
