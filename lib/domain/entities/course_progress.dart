class CourseProgress {
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final int completedQuizzes;
  final int totalQuizzes;
  final int submittedAssignments;
  final int totalAssignments;
  final double percentage;
  final DateTime lastActivity;

  const CourseProgress({
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

  bool get isCompleted => percentage >= 100.0;
}
