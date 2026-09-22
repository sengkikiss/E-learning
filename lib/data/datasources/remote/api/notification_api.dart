import '../notification_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/notification/notification_model.dart';

class RemoteNotificationDataSource implements NotificationDataSource {
  final ApiClient _client;

  RemoteNotificationDataSource(this._client);

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await _client.get(
      ApiConstants.notifications,
      queryParameters: {'userId': userId},
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final path = ApiConstants.markNotificationRead.replaceAll('{id}', notificationId);
    await _client.put(path);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _client.put('${ApiConstants.notifications}/read-all', queryParameters: {'userId': userId});
  }
}
