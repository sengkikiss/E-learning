import 'package:flutter_test/flutter_test.dart';
import 'package:e_learning/data/datasources/remote/fake_api/fake_quiz_api.dart';
import 'package:e_learning/data/datasources/remote/fake_api/fake_api_client.dart';
import 'package:e_learning/data/repositories/quiz_repository_impl.dart';

void main() {
  group('QuizRepository & FakeQuizDataSource Tests', () {
    late FakeQuizDataSource fakeDataSource;
    late QuizRepositoryImpl repository;

    setUp(() {
      final client = FakeApiClient(simulatedDelayMs: 0);
      fakeDataSource = FakeQuizDataSource(client);
      repository = QuizRepositoryImpl(fakeDataSource);
    });

    test('getQuizByLesson retrieves seeded quiz and questions', () async {
      final quiz = await repository.getQuizByLesson('les_01_02');
      expect(quiz.id, isNotEmpty);
      expect(quiz.title, isNotEmpty);
      expect(quiz.questions, isNotEmpty);
      expect(quiz.questions.first.options.length, 4);
    });

    test('submitQuizAttempt grades answers correctly and records attempt', () async {
      final quiz = await repository.getQuizById('quiz_01');

      // Map correct answers
      final Map<int, int> answers = {};
      for (int i = 0; i < quiz.questions.length; i++) {
        answers[i] = quiz.questions[i].correctAnswerIndex;
      }

      final attempt = await repository.submitQuizAttempt(
        quizId: quiz.id,
        studentId: 'usr_student_01',
        selectedAnswers: answers,
      );

      expect(attempt.passed, isTrue);
      expect(attempt.score, equals(quiz.questions.length * 10));
      expect(attempt.percentage, 100.0);
    });
  });
}
