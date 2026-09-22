import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';
import '../../domain/entities/material.dart';

class MaterialCard extends StatelessWidget {
  final CourseMaterial material;
  final VoidCallback onDownload;

  const MaterialCard({
    super.key,
    required this.material,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getFileTypeColor(material.type).withOpacity(0.15),
              borderRadius: AppRadius.smRadius,
            ),
            child: Icon(
              _getFileTypeIcon(material.type),
              color: _getFileTypeColor(material.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  material.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${material.type.toUpperCase()} • ${material.fileSize}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            onPressed: onDownload,
            tooltip: 'Download Material',
          ),
        ],
      ),
    );
  }

  Color _getFileTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return AppColors.error;
      case 'zip':
      case 'rar':
        return AppColors.warning;
      case 'code':
      case 'dart':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  IconData _getFileTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'zip':
      case 'rar':
        return Icons.folder_zip_rounded;
      case 'code':
      case 'dart':
        return Icons.code_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }
}
