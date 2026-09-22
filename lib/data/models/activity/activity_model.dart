import 'package:e_learning/domain/entities/learning_activity.dart';

class LearningActivityModel {
  final String id;
  final String userId;
  final String courseId;
  final String courseTitle;
  final String type;
  final String title;
  final String timestamp;
  final String? scoreOrDetail;

  const LearningActivityModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.type,
    required this.title,
    required this.timestamp,
    this.scoreOrDetail,
  });

  factory LearningActivityModel.fromJson(Map<String, dynamic> json) {
    return LearningActivityModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      courseTitle: json['courseTitle'] as String? ?? '',
      type: json['type'] as String? ?? 'lessonCompleted',
      title: json['title'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      scoreOrDetail: json['scoreOrDetail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'type': type,
      'title': title,
      'timestamp': timestamp,
      'scoreOrDetail': scoreOrDetail,
    };
  }

  LearningActivity toEntity() {
    ActivityType actType;
    switch (type) {
      case 'quizAttempted':
        actType = ActivityType.quizAttempted;
        break;
      case 'assignmentSubmitted':
        actType = ActivityType.assignmentSubmitted;
        break;
      case 'courseEnrolled':
        actType = ActivityType.courseEnrolled;
        break;
      case 'lessonCompleted':
      default:
        actType = ActivityType.lessonCompleted;
        break;
    }

    return LearningActivity(
      id: id,
      userId: userId,
      courseId: courseId,
      courseTitle: courseTitle,
      type: actType,
      title: title,
      timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      scoreOrDetail: scoreOrDetail,
    );
  }
}
