import 'package:e_learning/domain/entities/notification.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'general',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  AppNotification toEntity() {
    NotificationType notifType;
    switch (type.toLowerCase()) {
      case 'courseupdate':
        notifType = NotificationType.courseUpdate;
        break;
      case 'quizreminder':
        notifType = NotificationType.quizReminder;
        break;
      case 'assignmentgraded':
        notifType = NotificationType.assignmentGraded;
        break;
      case 'certificateearned':
        notifType = NotificationType.certificateEarned;
        break;
      case 'general':
      default:
        notifType = NotificationType.general;
        break;
    }

    return AppNotification(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: notifType,
      isRead: isRead,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}
