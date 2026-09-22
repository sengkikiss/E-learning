import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/notification_card.dart';
import '../providers/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationActionNotifierProvider.notifier).markAllRead();
            },
            child: const Text('Mark All Read'),
          ),
        ],
      ),
      body: SafeArea(
        child: notifsAsync.when(
          data: (notifications) {
            if (notifications.isEmpty) {
              return const EmptyView(
                title: 'No notifications',
                message: 'You are completely caught up! Updates and reminders will appear here.',
                icon: Icons.notifications_none_rounded,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return NotificationCard(
                  notification: notif,
                  onTap: () {
                    ref.read(notificationActionNotifierProvider.notifier).markRead(notif.id);
                  },
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading notifications...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(notificationsProvider)),
        ),
      ),
    );
  }
}
