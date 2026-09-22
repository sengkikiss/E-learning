import 'package:flutter_test/flutter_test.dart';
import 'package:e_learning/core/utils/progress_calculator.dart';

void main() {
  group('ProgressCalculator Tests', () {
    test('calculateCourseProgress with lessons only', () {
      final progress = ProgressCalculator.calculateCourseProgress(
        completedLessons: 5,
        totalLessons: 10,
      );
      expect(progress, 50.0);
    });

    test('calculateCourseProgress with zero lessons returns 0.0', () {
      final progress = ProgressCalculator.calculateCourseProgress(
        completedLessons: 0,
        totalLessons: 0,
      );
      expect(progress, 0.0);
    });

    test('calculateCourseProgress with full completion', () {
      final progress = ProgressCalculator.calculateCourseProgress(
        completedLessons: 10,
        totalLessons: 10,
        completedQuizzes: 2,
        totalQuizzes: 2,
        submittedAssignments: 1,
        totalAssignments: 1,
      );
      expect(progress, 100.0);
    });

    test('calculateQuizScore calculates passing result', () {
      final result = ProgressCalculator.calculateQuizScore(
        correctAnswers: 8,
        totalQuestions: 10,
        passingScorePercentage: 70.0,
      );

      expect(result.score, 80);
      expect(result.percentage, 80.0);
      expect(result.passed, isTrue);
      expect(result.correctAnswers, 8);
      expect(result.incorrectAnswers, 2);
    });

    test('calculateQuizScore calculates failing result', () {
      final result = ProgressCalculator.calculateQuizScore(
        correctAnswers: 5,
        totalQuestions: 10,
        passingScorePercentage: 70.0,
      );

      expect(result.score, 50);
      expect(result.percentage, 50.0);
      expect(result.passed, isFalse);
      expect(result.correctAnswers, 5);
      expect(result.incorrectAnswers, 5);
    });
  });
}
