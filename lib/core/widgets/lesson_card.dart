import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../../domain/entities/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;
  final bool isCurrent;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? (isDark ? AppColors.primaryDark.withOpacity(0.3) : AppColors.primaryContainer.withOpacity(0.5))
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: isCurrent
              ? AppColors.primary
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isCurrent ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: lesson.isLocked ? null : onTap,
          borderRadius: AppRadius.mdRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Order / Status Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: lesson.isCompleted
                        ? AppColors.successLight.withOpacity(0.4)
                        : (lesson.isLocked
                            ? Colors.grey.withOpacity(0.2)
                            : (isCurrent ? AppColors.primary : AppColors.primaryContainer)),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: lesson.isCompleted
                        ? const Icon(Icons.check_rounded, color: AppColors.success, size: 20)
                        : (lesson.isLocked
                            ? const Icon(Icons.lock_rounded, color: Colors.grey, size: 18)
                            : (isCurrent
                                ? const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22)
                                : Text(
                                    lesson.order.toString().padLeft(2, '0'),
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ))),
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Duration
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: lesson.isLocked
                              ? Colors.grey
                              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textMutedLight),
                          const SizedBox(width: 4),
                          Text(
                            lesson.duration,
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                          ),
                          if (lesson.materials.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: AppColors.textMutedLight)),
                            const SizedBox(width: 8),
                            const Icon(Icons.attach_file_rounded, size: 13, color: AppColors.primary),
                            const SizedBox(width: 2),
                            Text(
                              '${lesson.materials.length} resources',
                              style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                Icon(
                  lesson.isLocked ? Icons.lock_outline_rounded : Icons.play_circle_outline_rounded,
                  color: lesson.isLocked
                      ? Colors.grey
                      : (isCurrent ? AppColors.primary : AppColors.textSecondaryLight),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
