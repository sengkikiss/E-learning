import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../../domain/entities/notification.dart';
import '../utils/date_formatter.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: notification.isRead
            ? (isDark ? AppColors.cardDark : Colors.white)
            : (isDark ? AppColors.primaryDark.withOpacity(0.2) : AppColors.primaryContainer.withOpacity(0.4)),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: notification.isRead
              ? (isDark ? AppColors.borderDark : AppColors.borderLight)
              : AppColors.primaryLight.withOpacity(0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdRadius,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            DateFormatter.timeAgo(notification.createdAt),
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.certificateEarned:
        return AppColors.warning;
      case NotificationType.assignmentGraded:
        return AppColors.success;
      case NotificationType.quizReminder:
        return AppColors.accentOrange;
      case NotificationType.courseUpdate:
      case NotificationType.general:
        return AppColors.primary;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.certificateEarned:
        return Icons.workspace_premium_rounded;
      case NotificationType.assignmentGraded:
        return Icons.grading_rounded;
      case NotificationType.quizReminder:
        return Icons.timer_outlined;
      case NotificationType.courseUpdate:
      case NotificationType.general:
        return Icons.notifications_active_outlined;
    }
  }
}
