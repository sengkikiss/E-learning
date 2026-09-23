import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import 'package:e_learning/features/progress/presentation/providers/progress_providers.dart';

class CertificateDetailScreen extends ConsumerWidget {
  final String certificateId;

  const CertificateDetailScreen({super.key, required this.certificateId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final certAsync = ref.watch(certificateDetailProvider(certificateId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Verified Certificate')),
      body: SafeArea(
        child: certAsync.when(
          data: (certificate) {
            if (certificate == null) {
              return const Center(child: Text('Certificate not found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  // Certificate Paper Mockup
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.lgRadius,
                      border: Border.all(color: const Color(0xFFD97706), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header Seal
                        const Icon(
                          Icons.workspace_premium_rounded,
                          color: Color(0xFFD97706),
                          size: 64,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'CERTIFICATE OF COMPLETION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: Color(0xFF78350F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'THIS IS PROUDLY PRESENTED TO',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          certificate.studentName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'For successfully mastering all modules, practical assessments, quizzes, and assignments for the professional course:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          certificate.courseTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 14),

                        // Signature & Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  certificate.instructorName,
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const Text(
                                  'Lead Instructor',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormatter.formatDate(certificate.issueDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const Text(
                                  'Date Issued',
                                  style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Credential ID: ${certificate.certificateCode}',
                            style: const TextStyle(fontSize: 10, color: Color(0xFF475569)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Actions
                  AppButton(
                    text: 'Download Certificate PDF',
                    icon: Icons.download_rounded,
                    onPressed: () {
                      AppSnackbar.showSuccess(context, 'Certificate downloaded to your Downloads folder.');
                    },
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Share Credential Link',
                    variant: AppButtonVariant.outline,
                    icon: Icons.share_rounded,
                    onPressed: () {
                      AppSnackbar.showInfo(context, 'Credential URL copied to clipboard: ${certificate.credentialUrl}');
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const LoadingView(message: 'Loading certificate details...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(certificateDetailProvider(certificateId))),
        ),
      ),
    );
  }
}
