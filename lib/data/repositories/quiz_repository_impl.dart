import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_attempt.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/remote/quiz_datasource.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizDataSource _dataSource;

  QuizRepositoryImpl(this._dataSource);

  @override
  Future<Quiz> getQuizByLesson(String lessonId) async {
    final model = await _dataSource.getQuizByLesson(lessonId);
    return model.toEntity();
  }

  @override
  Future<Quiz> getQuizById(String quizId) async {
    final model = await _dataSource.getQuizById(quizId);
    return model.toEntity();
  }

  @override
  Future<QuizAttempt> submitQuizAttempt({
    required String quizId,
    required String studentId,
    required Map<int, int> selectedAnswers,
  }) async {
    final model = await _dataSource.submitQuizAttempt(
      quizId: quizId,
      studentId: studentId,
      selectedAnswers: selectedAnswers,
    );
    return model.toEntity();
  }

  @override
  Future<List<QuizAttempt>> getQuizAttempts(String quizId) async {
    final models = await _dataSource.getQuizAttempts(quizId);
    return models.map((m) => m.toEntity()).toList();
  }
}
