import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notification_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<List<AppNotification>> getNotifications(String userId) async {
    final models = await _dataSource.getNotifications(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) => _dataSource.markAsRead(notificationId);

  @override
  Future<void> markAllAsRead(String userId) => _dataSource.markAllAsRead(userId);
}
