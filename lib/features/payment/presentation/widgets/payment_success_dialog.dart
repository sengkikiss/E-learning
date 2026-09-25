import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/cambodia_payment_method.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final String studentName;
  final double amountUsd;
  final String currency;
  final CambodiaPaymentMethod paymentMethod;
  final String transactionId;

  const PaymentSuccessDialog({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.studentName,
    required this.amountUsd,
    required this.currency,
    required this.paymentMethod,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nowFormatted = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());
    final khrText = CambodiaPaymentRegistry.formatKhr(amountUsd);
    final usdText = '\$${amountUsd.toStringAsFixed(2)}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Animated Check Icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success.withValues(alpha: 0.4), width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 46,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Payment Successful!',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            const Text(
              'ការទូទាត់ជោគជ័យ!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have been enrolled and now have lifetime access to the course.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Receipt Breakdown Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                borderRadius: AppRadius.lgRadius,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Course', courseTitle, isDark, isBold: true),
                  const Divider(height: 16),
                  _buildReceiptRow('Student', studentName, isDark),
                  const Divider(height: 16),
                  _buildReceiptRow('Payment Method', paymentMethod.name, isDark),
                  const Divider(height: 16),
                  _buildReceiptRow('Transaction ID', transactionId, isDark, isMonospace: true),
                  const Divider(height: 16),
                  _buildReceiptRow('Date & Time', nowFormatted, isDark),
                  const Divider(height: 16),
                  _buildReceiptRow(
                    'Amount Paid',
                    currency == 'KHR' ? '$khrText ($usdText)' : '$usdText ($khrText)',
                    isDark,
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action: Start Learning Now
            AppButton(
              text: 'Start Learning Now',
              icon: Icons.play_arrow_rounded,
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                context.pushReplacement('/learning/$courseId');
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop(); // Go back to course detail
              },
              child: Text(
                'Back to Course Details',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
    bool isMonospace = false,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              fontFamily: isMonospace ? 'monospace' : null,
              color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ),
      ],
    );
  }
}
