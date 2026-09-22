import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onClear;
  final bool showFilterButton;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search courses, skills, topics...',
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
    this.onClear,
    this.showFilterButton = true,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  size: 20,
                ),
                suffixIcon: controller != null && controller!.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: onClear ?? () => controller?.clear(),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        if (showFilterButton) ...[
          const SizedBox(width: 10),
          InkWell(
            onTap: onFilterPressed,
            borderRadius: AppRadius.mdRadius,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.mdRadius,
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
