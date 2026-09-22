import '../../entities/quiz.dart';
import '../../entities/quiz_attempt.dart';
import '../../repositories/quiz_repository.dart';

class GetQuizUseCase {
  final QuizRepository repository;
  GetQuizUseCase(this.repository);

  Future<Quiz> execute(String lessonId) => repository.getQuizByLesson(lessonId);
}

class GetQuizByIdUseCase {
  final QuizRepository repository;
  GetQuizByIdUseCase(this.repository);

  Future<Quiz> execute(String quizId) => repository.getQuizById(quizId);
}

class SubmitQuizAttemptUseCase {
  final QuizRepository repository;
  SubmitQuizAttemptUseCase(this.repository);

  Future<QuizAttempt> execute({
    required String quizId,
    required String studentId,
    required Map<int, int> selectedAnswers,
  }) {
    return repository.submitQuizAttempt(
      quizId: quizId,
      studentId: studentId,
      selectedAnswers: selectedAnswers,
    );
  }
}

class GetQuizAttemptsUseCase {
  final QuizRepository repository;
  GetQuizAttemptsUseCase(this.repository);

  Future<List<QuizAttempt>> execute(String quizId) => repository.getQuizAttempts(quizId);
}
