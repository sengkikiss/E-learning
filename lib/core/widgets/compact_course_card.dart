import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../../domain/entities/course.dart';
import 'rating_view.dart';

class CompactCourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkToggle;
  final Widget? trailing;

  const CompactCourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.onBookmarkToggle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdRadius,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: AppRadius.smRadius,
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.primaryLight.withValues(alpha: 0.2),
                      child: const Icon(Icons.school_outlined, color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${course.instructorName}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          RatingView(rating: course.rating, starSize: 14),
                          const SizedBox(width: 8),
                          Text(
                            '•  ${course.duration}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textMutedLight,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            course.isFree ? 'Free' : '\$${course.price.toStringAsFixed(2)}',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: course.isFree ? AppColors.success : AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
