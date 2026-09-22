import '../notification_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/notification/notification_model.dart';

class FakeNotificationDataSource implements NotificationDataSource {
  final FakeApiClient _client;
  final Set<String> _readNotificationIds = {'notif_03'};

  FakeNotificationDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await _client.request<List<NotificationModel>>(
      dataFetcher: () {
        return FakeDatabase.notifications.map((n) {
          return NotificationModel.fromJson({
            ...n.toJson(),
            'isRead': _readNotificationIds.contains(n.id) || n.isRead,
          });
        }).toList();
      },
      successMessage: 'Notifications retrieved',
    );
    return response.data ?? [];
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _client.request<bool>(
      dataFetcher: () {
        _readNotificationIds.add(notificationId);
        return true;
      },
      successMessage: 'Notification marked as read',
    );
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _client.request<bool>(
      dataFetcher: () {
        for (final n in FakeDatabase.notifications) {
          _readNotificationIds.add(n.id);
        }
        return true;
      },
      successMessage: 'All notifications marked as read',
    );
  }
}
