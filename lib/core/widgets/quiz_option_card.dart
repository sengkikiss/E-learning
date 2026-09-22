import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

class QuizOptionCard extends StatelessWidget {
  final String optionText;
  final int index;
  final bool isSelected;
  final bool isReviewMode;
  final bool isCorrect;
  final VoidCallback? onTap;

  const QuizOptionCard({
    super.key,
    required this.optionText,
    required this.index,
    required this.isSelected,
    this.isReviewMode = false,
    this.isCorrect = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color borderColor;
    Color backgroundColor;
    Color textColor;
    Color badgeBg;
    Color badgeFg;

    if (isReviewMode) {
      if (isCorrect) {
        borderColor = AppColors.success;
        backgroundColor = AppColors.successLight.withOpacity(0.3);
        textColor = AppColors.success;
        badgeBg = AppColors.success;
        badgeFg = Colors.white;
      } else if (isSelected && !isCorrect) {
        borderColor = AppColors.error;
        backgroundColor = AppColors.errorLight.withOpacity(0.3);
        textColor = AppColors.error;
        badgeBg = AppColors.error;
        badgeFg = Colors.white;
      } else {
        borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
        backgroundColor = isDark ? AppColors.cardDark : Colors.white;
        textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        badgeBg = isDark ? AppColors.surfaceDark : AppColors.primaryContainer;
        badgeFg = AppColors.textSecondaryLight;
      }
    } else {
      if (isSelected) {
        borderColor = AppColors.primary;
        backgroundColor = isDark ? AppColors.primaryDark.withOpacity(0.3) : AppColors.primaryContainer.withOpacity(0.5);
        textColor = AppColors.primary;
        badgeBg = AppColors.primary;
        badgeFg = Colors.white;
      } else {
        borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
        backgroundColor = isDark ? AppColors.cardDark : Colors.white;
        textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        badgeBg = isDark ? AppColors.surfaceDark : AppColors.primaryContainer;
        badgeFg = isDark ? AppColors.textSecondaryDark : AppColors.primary;
      }
    }

    final optionLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
    final letter = index < optionLetters.length ? optionLetters[index] : '${index + 1}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: borderColor, width: isSelected || (isReviewMode && isCorrect) ? 1.8 : 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isReviewMode ? null : onTap,
          borderRadius: AppRadius.mdRadius,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: badgeFg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    optionText,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isReviewMode && isCorrect)
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22)
                else if (isReviewMode && isSelected && !isCorrect)
                  const Icon(Icons.cancel_rounded, color: AppColors.error, size: 22)
                else if (isSelected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
