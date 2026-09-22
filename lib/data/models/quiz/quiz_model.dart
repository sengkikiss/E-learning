import 'package:e_learning/domain/entities/question.dart';
import 'package:e_learning/domain/entities/quiz.dart';
import 'package:e_learning/domain/entities/quiz_attempt.dart';

class QuestionModel {
  final String id;
  final String quizId;
  final String questionText;
  final String type;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuestionModel({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String? ?? '',
      quizId: json['quizId'] as String? ?? '',
      questionText: json['questionText'] as String? ?? '',
      type: json['type'] as String? ?? 'multiple_choice',
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'questionText': questionText,
      'type': type,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }

  QuizQuestion toEntity() {
    return QuizQuestion(
      id: id,
      quizId: quizId,
      questionText: questionText,
      type: type,
      options: options,
      correctAnswerIndex: correctAnswerIndex,
      explanation: explanation,
    );
  }
}

class QuizModel {
  final String id;
  final String lessonId;
  final String courseId;
  final String title;
  final String description;
  final int totalQuestions;
  final int timeLimitMinutes;
  final double passingScore;
  final int maximumAttempts;
  final List<QuestionModel> questions;

  const QuizModel({
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

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      timeLimitMinutes: (json['timeLimitMinutes'] as num?)?.toInt() ?? 15,
      passingScore: (json['passingScore'] as num?)?.toDouble() ?? 70.0,
      maximumAttempts: (json['maximumAttempts'] as num?)?.toInt() ?? 3,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'courseId': courseId,
      'title': title,
      'description': description,
      'totalQuestions': totalQuestions,
      'timeLimitMinutes': timeLimitMinutes,
      'passingScore': passingScore,
      'maximumAttempts': maximumAttempts,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  Quiz toEntity() {
    return Quiz(
      id: id,
      lessonId: lessonId,
      courseId: courseId,
      title: title,
      description: description,
      totalQuestions: totalQuestions,
      timeLimitMinutes: timeLimitMinutes,
      passingScore: passingScore,
      maximumAttempts: maximumAttempts,
      questions: questions.map((q) => q.toEntity()).toList(),
    );
  }
}

class QuizAttemptModel {
  final String id;
  final String quizId;
  final String studentId;
  final int score;
  final double percentage;
  final int correctAnswers;
  final int incorrectAnswers;
  final bool passed;
  final String attemptDate;
  final Map<String, dynamic> selectedAnswers;

  const QuizAttemptModel({
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

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['id'] as String? ?? '',
      quizId: json['quizId'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      correctAnswers: (json['correctAnswers'] as num?)?.toInt() ?? 0,
      incorrectAnswers: (json['incorrectAnswers'] as num?)?.toInt() ?? 0,
      passed: json['passed'] as bool? ?? false,
      attemptDate: json['attemptDate'] as String? ?? DateTime.now().toIso8601String(),
      selectedAnswers: json['selectedAnswers'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'studentId': studentId,
      'score': score,
      'percentage': percentage,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'passed': passed,
      'attemptDate': attemptDate,
      'selectedAnswers': selectedAnswers,
    };
  }

  QuizAttempt toEntity() {
    final Map<int, int> answers = {};
    selectedAnswers.forEach((key, value) {
      final intKey = int.tryParse(key);
      final intVal = (value as num?)?.toInt();
      if (intKey != null && intVal != null) {
        answers[intKey] = intVal;
      }
    });

    return QuizAttempt(
      id: id,
      quizId: quizId,
      studentId: studentId,
      score: score,
      percentage: percentage,
      correctAnswers: correctAnswers,
      incorrectAnswers: incorrectAnswers,
      passed: passed,
      attemptDate: DateTime.tryParse(attemptDate) ?? DateTime.now(),
      selectedAnswers: answers,
    );
  }
}
