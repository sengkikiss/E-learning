import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../../domain/entities/assignment.dart';
import '../utils/date_formatter.dart';
import 'status_badge.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final VoidCallback onTap;
  final String? submissionStatus;
  final int? score;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
    this.submissionStatus,
    this.score,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    BadgeType badgeType = BadgeType.warning;
    String badgeText = 'Pending';

    if (submissionStatus != null) {
      if (submissionStatus == 'graded') {
        badgeType = BadgeType.success;
        badgeText = 'Graded (${score ?? 0}/${assignment.maximumScore})';
      } else if (submissionStatus == 'submitted') {
        badgeType = BadgeType.info;
        badgeText = 'Submitted';
      }
    } else if (assignment.isOverdue) {
      badgeType = BadgeType.error;
      badgeText = 'Overdue';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdRadius,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBadge(text: badgeText, type: badgeType),
                    Row(
                      children: [
                        const Icon(Icons.event_outlined, size: 14, color: AppColors.textMutedLight),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${DateFormatter.formatDate(assignment.dueDate)}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: assignment.isOverdue ? AppColors.error : AppColors.textMutedLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  assignment.title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  assignment.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Max Score: ${assignment.maximumScore} pts',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMutedLight),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
