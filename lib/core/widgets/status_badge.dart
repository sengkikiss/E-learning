import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

enum BadgeType {
  success,
  warning,
  error,
  info,
  neutral,
}

class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.info,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (type) {
      case BadgeType.success:
        bg = AppColors.successLight.withValues(alpha: 0.3);
        fg = AppColors.success;
        break;
      case BadgeType.warning:
        bg = AppColors.warningLight.withValues(alpha: 0.3);
        fg = AppColors.warning;
        break;
      case BadgeType.error:
        bg = AppColors.errorLight.withValues(alpha: 0.3);
        fg = AppColors.error;
        break;
      case BadgeType.neutral:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey[700]!;
        break;
      case BadgeType.info:
        bg = AppColors.primaryContainer;
        fg = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.fullRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
