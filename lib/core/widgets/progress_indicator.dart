import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

class CourseLinearProgress extends StatelessWidget {
  final double percentage; // 0.0 to 100.0
  final double height;
  final bool showLabel;

  const CourseLinearProgress({
    super.key,
    required this.percentage,
    this.height = 8,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final clampedRatio = (percentage / 100.0).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: AppRadius.fullRadius,
          child: Container(
            height: height,
            width: double.infinity,
            color: AppColors.primaryContainer,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedRatio,
              child: Container(
                decoration: BoxDecoration(
                  gradient: percentage >= 100 ? AppColors.successGradient : AppColors.primaryGradient,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
