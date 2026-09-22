import '../../models/notification/notification_model.dart';

abstract class NotificationDataSource {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}
