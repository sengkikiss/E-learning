class QuizAttempt {
  final String id;
  final String quizId;
  final String studentId;
  final int score;
  final double percentage;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool passed;
  final DateTime attemptDate;
  final Map<int, int> selectedAnswers; // questionIndex -> selectedOptionIndex

  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.score,
    required this.percentage,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.passed,
    required this.attemptDate,
    this.selectedAnswers = const {},
  });
}
