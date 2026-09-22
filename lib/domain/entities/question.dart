class QuizQuestion {
  final String id;
  final String quizId;
  final String questionText;
  final String type; // multiple_choice, true_false
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}
