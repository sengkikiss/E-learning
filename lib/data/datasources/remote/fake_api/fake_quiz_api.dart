import '../quiz_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/quiz/quiz_model.dart';
import 'package:e_learning/core/error/app_exception.dart';
import 'package:e_learning/core/utils/progress_calculator.dart';

class FakeQuizDataSource implements QuizDataSource {
  final FakeApiClient _client;

  FakeQuizDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<QuizModel> getQuizByLesson(String lessonId) async {
    final response = await _client.request<QuizModel>(
      dataFetcher: () {
        final match = FakeDatabase.quizzes.cast<QuizModel?>().firstWhere(
              (q) => q?.lessonId == lessonId,
              orElse: () => FakeDatabase.quizzes.first,
            );
        return match!;
      },
      successMessage: 'Quiz retrieved successfully',
    );
    return response.data!;
  }

  @override
  Future<QuizModel> getQuizById(String quizId) async {
    final response = await _client.request<QuizModel>(
      dataFetcher: () {
        final match = FakeDatabase.quizzes.cast<QuizModel?>().firstWhere(
              (q) => q?.id == quizId,
              orElse: () => null,
            );
        if (match == null) {
          throw NotFoundException('Quiz with id "$quizId" not found');
        }
        return match;
      },
      successMessage: 'Quiz details retrieved successfully',
    );
    return response.data!;
  }

  @override
  Future<QuizAttemptModel> submitQuizAttempt({
    required String quizId,
    required String studentId,
    required Map<int, int> selectedAnswers,
  }) async {
    final response = await _client.request<QuizAttemptModel>(
      dataFetcher: () {
        final quiz = FakeDatabase.quizzes.firstWhere((q) => q.id == quizId);
        int correctCount = 0;

        for (int i = 0; i < quiz.questions.length; i++) {
          final userChoice = selectedAnswers[i];
          if (userChoice != null && userChoice == quiz.questions[i].correctAnswerIndex) {
            correctCount++;
          }
        }

        final scoreResult = ProgressCalculator.calculateQuizScore(
          correctAnswers: correctCount,
          totalQuestions: quiz.questions.length,
          passingScorePercentage: quiz.passingScore,
        );

        final Map<String, dynamic> stringMap = {};
        selectedAnswers.forEach((k, v) => stringMap[k.toString()] = v);

        final newAttempt = QuizAttemptModel(
          id: 'att_${DateTime.now().millisecondsSinceEpoch}',
          quizId: quizId,
          studentId: studentId,
          score: scoreResult.score,
          percentage: scoreResult.percentage,
          correctAnswers: scoreResult.correctAnswers,
          incorrectAnswers: scoreResult.incorrectAnswers,
          passed: scoreResult.passed,
          attemptDate: DateTime.now().toIso8601String(),
          selectedAnswers: stringMap,
        );

        FakeDatabase.quizAttempts.add(newAttempt);
        return newAttempt;
      },
      successMessage: 'Quiz submitted successfully',
    );
    return response.data!;
  }

  @override
  Future<List<QuizAttemptModel>> getQuizAttempts(String quizId) async {
    final response = await _client.request<List<QuizAttemptModel>>(
      dataFetcher: () {
        return FakeDatabase.quizAttempts.where((a) => a.quizId == quizId).toList();
      },
      successMessage: 'Quiz history retrieved successfully',
    );
    return response.data ?? [];
  }
}
