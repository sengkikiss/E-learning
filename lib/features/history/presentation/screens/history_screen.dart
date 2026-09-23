import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../domain/entities/learning_activity.dart';
import 'package:e_learning/features/progress/presentation/providers/progress_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyAsync = ref.watch(learningHistoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Learning Activity History')),
      body: SafeArea(
        child: historyAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return const EmptyView(
                title: 'No learning activity yet',
                message: 'Your course progress, completed lessons, and quiz attempts will be logged here.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = activities[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getActivityColor(activity.type).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getActivityIcon(activity.type),
                          color: _getActivityColor(activity.type),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activity.courseTitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            if (activity.scoreOrDetail != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                activity.scoreOrDetail!,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        DateFormatter.timeAgo(activity.timestamp),
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading learning history...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(learningHistoryProvider)),
        ),
      ),
    );
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.quizAttempted:
        return AppColors.accent;
      case ActivityType.assignmentSubmitted:
        return AppColors.info;
      case ActivityType.courseEnrolled:
        return AppColors.warning;
      case ActivityType.lessonCompleted:
        return AppColors.success;
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.quizAttempted:
        return Icons.quiz_outlined;
      case ActivityType.assignmentSubmitted:
        return Icons.assignment_turned_in_outlined;
      case ActivityType.courseEnrolled:
        return Icons.school_outlined;
      case ActivityType.lessonCompleted:
        return Icons.check_circle_outline_rounded;
    }
  }
}
