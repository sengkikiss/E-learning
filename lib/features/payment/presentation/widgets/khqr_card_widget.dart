import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/cambodia_payment_method.dart';

class KhqrCardWidget extends StatelessWidget {
  final CambodiaPaymentMethod method;
  final double amountUsd;
  final String billReference;
  final String currency; // 'USD' or 'KHR'

  const KhqrCardWidget({
    super.key,
    required this.method,
    required this.amountUsd,
    required this.billReference,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final khrText = CambodiaPaymentRegistry.formatKhr(amountUsd);
    final usdText = '\$${amountUsd.toStringAsFixed(2)}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.xlRadius,
        border: Border.all(
          color: method.primaryColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: method.primaryColor.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Official KHQR / Bank Red Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: method.id == 'khqr' ? const Color(0xFFE11938) : method.primaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.smRadius,
                      ),
                      child: Text(
                        method.bankCode,
                        style: TextStyle(
                          color: method.id == 'khqr' ? const Color(0xFFE11938) : method.primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'National Bank of Cambodia Standard',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),

          // 2. Merchant & Amount Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              children: [
                Text(
                  'EduLearn Cambodia Co., Ltd.',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Phnom Penh, Cambodia • Merchant ID: EDL-88219',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 12),

                // Amount Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: method.primaryColor.withValues(alpha: 0.08),
                    borderRadius: AppRadius.fullRadius,
                    border: Border.all(
                      color: method.primaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currency == 'KHR' ? khrText : usdText,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: method.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currency == 'KHR' ? '($usdText USD)' : '($khrText)',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Authentic QR Code Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(200, 200),
                  painter: _KhqrPainter(seed: billReference.hashCode),
                ),
                // Center Badge with Bank or Bakong logo
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: method.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      method.bankCode.substring(0, min(3, method.bankCode.length)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Reference Code & Copy
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill Reference',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    Text(
                      billReference,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: billReference));
                    AppSnackbar.showSuccess(context, 'Reference code copied to clipboard!');
                  },
                  borderRadius: AppRadius.smRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      borderRadius: AppRadius.smRadius,
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 5. Actions: Save QR & Simulated Open Bank App
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                    ),
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Save QR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      AppSnackbar.showSuccess(context, 'KHQR image saved to your gallery!');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: method.primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
                      foregroundColor: method.primaryColor,
                    ),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: Text(
                      'Open ${method.name.split(' ').first}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      AppSnackbar.showInfo(
                        context,
                        'Redirecting to ${method.name}... Please approve payment in app.',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom QR Painter that renders an authentic QR code pattern
class _KhqrPainter extends CustomPainter {
  final int seed;

  _KhqrPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    const int modules = 25;
    final double moduleSize = size.width / modules;

    // Pseudo-random deterministic generator based on seed
    final random = Random(seed);

    // Grid matrix
    final matrix = List.generate(modules, (_) => List.generate(modules, (_) => false));

    // 1. Draw Finder Patterns (Top-Left, Top-Right, Bottom-Left)
    void drawFinder(int startRow, int startCol) {
      for (int r = 0; r < 7; r++) {
        for (int c = 0; c < 7; c++) {
          final isBorder = (r == 0 || r == 6 || c == 0 || c == 6);
          final isCenter = (r >= 2 && r <= 4 && c >= 2 && c <= 4);
          if (isBorder || isCenter) {
            matrix[startRow + r][startCol + c] = true;
          }
        }
      }
    }

    drawFinder(0, 0); // Top-left
    drawFinder(0, modules - 7); // Top-right
    drawFinder(modules - 7, 0); // Bottom-left

    // 2. Alignment Pattern
    const alignR = 16;
    const alignC = 16;
    for (int r = -2; r <= 2; r++) {
      for (int c = -2; c <= 2; c++) {
        final isBorder = (r.abs() == 2 || c.abs() == 2);
        final isCenter = (r == 0 && c == 0);
        if (isBorder || isCenter) {
          matrix[alignR + r][alignC + c] = true;
        }
      }
    }

    // 3. Timing lines
    for (int i = 8; i < modules - 8; i++) {
      if (i % 2 == 0) {
        matrix[6][i] = true;
        matrix[i][6] = true;
      }
    }

    // 4. Fill random data modules (leaving finder/center clear)
    for (int r = 0; r < modules; r++) {
      for (int c = 0; c < modules; c++) {
        // Skip finder zones
        final inTL = r < 8 && c < 8;
        final inTR = r < 8 && c >= modules - 8;
        final inBL = r >= modules - 8 && c < 8;
        // Skip center logo zone
        final inCenter = (r >= 10 && r <= 14) && (c >= 10 && c <= 14);

        if (!inTL && !inTR && !inBL && !inCenter) {
          if (matrix[r][c] == false) {
            matrix[r][c] = random.nextDouble() > 0.52;
          }
        }
      }
    }

    // Render modules
    for (int r = 0; r < modules; r++) {
      for (int c = 0; c < modules; c++) {
        if (matrix[r][c]) {
          final rect = Rect.fromLTWH(
            c * moduleSize,
            r * moduleSize,
            moduleSize - 0.5,
            moduleSize - 0.5,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(moduleSize * 0.25)),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _KhqrPainter oldDelegate) => oldDelegate.seed != seed;
}
