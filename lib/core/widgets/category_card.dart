import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../../domain/entities/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(category.name),
                      size: 18,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category.name,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (category.courseCount > 0)
                      Text(
                        '${category.courseCount} courses',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? Colors.white70
                              : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('mobile')) return Icons.phone_android_rounded;
    if (lower.contains('web')) return Icons.language_rounded;
    if (lower.contains('data') || lower.contains('ai')) return Icons.psychology_rounded;
    if (lower.contains('backend') || lower.contains('cloud')) return Icons.cloud_outlined;
    if (lower.contains('design')) return Icons.palette_outlined;
    if (lower.contains('database')) return Icons.storage_rounded;
    if (lower.contains('security')) return Icons.shield_outlined;
    if (lower.contains('devops')) return Icons.all_inclusive_rounded;
    if (lower.contains('algorithm')) return Icons.code_rounded;
    return Icons.school_rounded;
  }
}
