import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';

class CardPaymentForm extends StatelessWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;
  final TextEditingController nameController;

  const CardPaymentForm({
    super.key,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    required this.nameController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit / Debit Card Details',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              Row(
                children: [
                  _buildBrandBadge('VISA', const Color(0xFF1A1F71)),
                  const SizedBox(width: 4),
                  _buildBrandBadge('MC', const Color(0xFFEB001B)),
                  const SizedBox(width: 4),
                  _buildBrandBadge('UPI', const Color(0xFF0079C1)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Card Number
          AppTextField(
            controller: cardNumberController,
            label: 'Card Number',
            hintText: '4000 1234 5678 9010',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.credit_card_rounded,
          ),
          const SizedBox(height: 12),

          // Cardholder Name
          AppTextField(
            controller: nameController,
            label: 'Cardholder Name',
            hintText: 'Name as shown on card',
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),

          // Expiry & CVV
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: expiryController,
                  label: 'Expiry Date',
                  hintText: 'MM/YY',
                  keyboardType: TextInputType.datetime,
                  prefixIcon: Icons.calendar_today_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: cvvController,
                  label: 'CVV / CVC',
                  hintText: '123',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.security_rounded, size: 14, color: AppColors.success),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Secured by Cambodia Payment Gateway (256-bit SSL encrypted)',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.smRadius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
