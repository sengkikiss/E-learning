import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  Future<List<AppNotification>> execute(String userId) {
    return repository.getNotifications(userId);
  }
}

class MarkNotificationReadUseCase {
  final NotificationRepository repository;
  MarkNotificationReadUseCase(this.repository);

  Future<void> execute(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}

class MarkAllNotificationsReadUseCase {
  final NotificationRepository repository;
  MarkAllNotificationsReadUseCase(this.repository);

  Future<void> execute(String userId) {
    return repository.markAllAsRead(userId);
  }
}
