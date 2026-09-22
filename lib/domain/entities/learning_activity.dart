enum ActivityType {
  lessonCompleted,
  quizAttempted,
  assignmentSubmitted,
  courseEnrolled,
}

class LearningActivity {
  final String id;
  final String userId;
  final String courseId;
  final String courseTitle;
  final ActivityType type;
  final String title;
  final DateTime timestamp;
  final String? scoreOrDetail;

  const LearningActivity({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.type,
    required this.title,
    required this.timestamp,
    this.scoreOrDetail,
  });
}
