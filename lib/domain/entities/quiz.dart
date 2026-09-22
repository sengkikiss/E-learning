import 'question.dart';

class Quiz {
  final String id;
  final String lessonId;
  final String courseId;
  final String title;
  final String description;
  final int totalQuestions;
  final int timeLimitMinutes;
  final double passingScore;
  final int maximumAttempts;
  final List<QuizQuestion> questions;

  const Quiz({
    required this.id,
    required this.lessonId,
    required this.courseId,
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.timeLimitMinutes,
    required this.passingScore,
    required this.maximumAttempts,
    this.questions = const [],
  });
}
