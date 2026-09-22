import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../providers/assignment_providers.dart';

class AssignmentDetailScreen extends ConsumerWidget {
  final String assignmentId;

  const AssignmentDetailScreen({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assignmentAsync = ref.watch(assignmentDetailProvider(assignmentId));
    final submissionAsync = ref.watch(submissionProvider(assignmentId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Assignment Details')),
      body: SafeArea(
        child: assignmentAsync.when(
          data: (assignment) {
            final submission = submissionAsync.valueOrNull;
            final bool isSubmitted = submission != null;
            final bool isGraded = submission?.isGraded ?? false;

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge(
                                text: isGraded ? 'Graded' : (isSubmitted ? 'Submitted' : 'Pending Submission'),
                                type: isGraded ? BadgeType.success : (isSubmitted ? BadgeType.info : BadgeType.warning),
                              ),
                              Text(
                                'Due: ${DateFormatter.formatDate(assignment.dueDate)}',
                                style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            assignment.title,
                            style: AppTextStyles.headlineSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            assignment.description,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Instructions Box
                          Text('Instructions & Requirements', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: AppRadius.mdRadius,
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: Text(
                              assignment.instruction,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Feedback if graded
                          if (isGraded) ...[
                            Text('Instructor Review & Feedback', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.successLight.withOpacity(0.2),
                                borderRadius: AppRadius.mdRadius,
                                border: Border.all(color: AppColors.success.withOpacity(0.4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Grade: ${submission?.grade ?? 'A'} (${submission?.score ?? 0}/${assignment.maximumScore} pts)',
                                        style: AppTextStyles.titleMedium.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Icon(Icons.verified_rounded, color: AppColors.success, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    submission?.feedback ?? 'Great job on your submission!',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Submit Action Button
                  AppButton(
                    text: isSubmitted ? 'Update Submission' : 'Submit Assignment',
                    icon: Icons.upload_file_rounded,
                    onPressed: () => context.push('/assignments/${assignment.id}/submission'),
                  ),
                ],
              ),
            );
          },
          loading: () => const LoadingView(message: 'Loading assignment details...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(assignmentDetailProvider(assignmentId))),
        ),
      ),
    );
  }
}
