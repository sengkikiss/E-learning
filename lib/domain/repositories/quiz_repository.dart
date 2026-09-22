import '../entities/quiz.dart';
import '../entities/quiz_attempt.dart';

abstract class QuizRepository {
  Future<Quiz> getQuizByLesson(String lessonId);
  Future<Quiz> getQuizById(String quizId);
  Future<QuizAttempt> submitQuizAttempt({
    required String quizId,
    required String studentId,
    required Map<int, int> selectedAnswers,
  });
  Future<List<QuizAttempt>> getQuizAttempts(String quizId);
}
