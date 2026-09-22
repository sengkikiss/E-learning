import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/notification.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/auth/presentation/providers/auth_providers.dart';

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final userId = user?.id ?? 'usr_student_01';
  return ref.watch(getNotificationsUseCaseProvider).execute(userId);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final asyncNotifs = ref.watch(notificationsProvider);
  return asyncNotifs.maybeWhen(
    data: (list) => list.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});

class NotificationActionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  NotificationActionNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> markRead(String notificationId) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(markNotificationReadUseCaseProvider).execute(notificationId);
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllRead() async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      final userId = user?.id ?? 'usr_student_01';
      await _ref.read(markAllNotificationsReadUseCaseProvider).execute(userId);
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final notificationActionNotifierProvider = StateNotifierProvider<NotificationActionNotifier, AsyncValue<void>>((ref) {
  return NotificationActionNotifier(ref);
});
