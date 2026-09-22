import '../../models/quiz/quiz_model.dart';

abstract class QuizDataSource {
  Future<QuizModel> getQuizByLesson(String lessonId);
  Future<QuizModel> getQuizById(String quizId);
  Future<QuizAttemptModel> submitQuizAttempt({
    required String quizId,
    required String studentId,
    required Map<int, int> selectedAnswers,
  });
  Future<List<QuizAttemptModel>> getQuizAttempts(String quizId);
}
