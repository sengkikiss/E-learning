class ProgressCalculator {
  ProgressCalculator._();

  /// Calculates overall course progress percentage (0.0 to 100.0) based on
  /// completed lessons, quizzes, and assignments with weighted proportions.
  ///
  /// Default weights:
  /// - Lessons: 60%
  /// - Quizzes: 20%
  /// - Assignments: 20%
  static double calculateCourseProgress({
    required int completedLessons,
    required int totalLessons,
    int completedQuizzes = 0,
    int totalQuizzes = 0,
    int submittedAssignments = 0,
    int totalAssignments = 0,
  }) {
    if (totalLessons <= 0) return 0.0;

    final double lessonRatio = totalLessons > 0 ? (completedLessons / totalLessons).clamp(0.0, 1.0) : 0.0;
    final bool hasQuizzes = totalQuizzes > 0;
    final bool hasAssignments = totalAssignments > 0;

    // Dynamically adjust weights if there are no quizzes or assignments
    double lessonWeight = 0.60;
    double quizWeight = 0.20;
    double assignmentWeight = 0.20;

    if (!hasQuizzes && !hasAssignments) {
      lessonWeight = 1.0;
      quizWeight = 0.0;
      assignmentWeight = 0.0;
    } else if (!hasQuizzes && hasAssignments) {
      lessonWeight = 0.70;
      quizWeight = 0.0;
      assignmentWeight = 0.30;
    } else if (hasQuizzes && !hasAssignments) {
      lessonWeight = 0.70;
      quizWeight = 0.30;
      assignmentWeight = 0.0;
    }

    final double quizRatio = hasQuizzes ? (completedQuizzes / totalQuizzes).clamp(0.0, 1.0) : 0.0;
    final double assignmentRatio = hasAssignments ? (submittedAssignments / totalAssignments).clamp(0.0, 1.0) : 0.0;

    final double totalPercentage = (lessonRatio * lessonWeight +
            quizRatio * quizWeight +
            assignmentRatio * assignmentWeight) *
        100.0;

    return double.parse(totalPercentage.toStringAsFixed(1));
  }

  /// Calculates quiz score percentage and whether the attempt passed
  static QuizScoreResult calculateQuizScore({
    required int correctAnswers,
    required int totalQuestions,
    required double passingScorePercentage,
  }) {
    if (totalQuestions <= 0) {
      return const QuizScoreResult(
        score: 0,
        percentage: 0.0,
        passed: false,
        correctAnswers: 0,
        incorrectAnswers: 0,
      );
    }

    final double percentage = double.parse(((correctAnswers / totalQuestions) * 100.0).toStringAsFixed(1));
    final bool passed = percentage >= passingScorePercentage;
    final int incorrect = totalQuestions - correctAnswers;

    return QuizScoreResult(
      score: correctAnswers * 10,
      percentage: percentage,
      passed: passed,
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrect < 0 ? 0 : incorrect,
    );
  }
}

class QuizScoreResult {
  final int score;
  final double percentage;
  final bool passed;
  final int correctAnswers;
  final int incorrectAnswers;

  const QuizScoreResult({
    required this.score,
    required this.percentage,
    required this.passed,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });
}
