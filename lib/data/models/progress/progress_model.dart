import 'package:e_learning/domain/entities/course_progress.dart';

class CourseProgressModel {
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final int completedQuizzes;
  final int totalQuizzes;
  final int submittedAssignments;
  final int totalAssignments;
  final double percentage;
  final String lastActivity;

  const CourseProgressModel({
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.completedQuizzes,
    required this.totalQuizzes,
    required this.submittedAssignments,
    required this.totalAssignments,
    required this.percentage,
    required this.lastActivity,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      courseId: json['courseId'] as String? ?? '',
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      completedQuizzes: (json['completedQuizzes'] as num?)?.toInt() ?? 0,
      totalQuizzes: (json['totalQuizzes'] as num?)?.toInt() ?? 0,
      submittedAssignments: (json['submittedAssignments'] as num?)?.toInt() ?? 0,
      totalAssignments: (json['totalAssignments'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      lastActivity: json['lastActivity'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'completedQuizzes': completedQuizzes,
      'totalQuizzes': totalQuizzes,
      'submittedAssignments': submittedAssignments,
      'totalAssignments': totalAssignments,
      'percentage': percentage,
      'lastActivity': lastActivity,
    };
  }

  CourseProgress toEntity() {
    return CourseProgress(
      courseId: courseId,
      completedLessons: completedLessons,
      totalLessons: totalLessons,
      completedQuizzes: completedQuizzes,
      totalQuizzes: totalQuizzes,
      submittedAssignments: submittedAssignments,
      totalAssignments: totalAssignments,
      percentage: percentage,
      lastActivity: DateTime.tryParse(lastActivity) ?? DateTime.now(),
    );
  }
}
