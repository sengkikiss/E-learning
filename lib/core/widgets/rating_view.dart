import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class RatingView extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;

  const RatingView({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.star,
          size: starSize,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: starSize * 0.85,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textMutedLight,
              fontSize: starSize * 0.75,
            ),
          ),
        ],
      ],
    );
  }
}
