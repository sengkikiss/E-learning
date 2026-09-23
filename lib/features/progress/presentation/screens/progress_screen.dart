import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/progress_indicator.dart';
import 'package:e_learning/features/courses/presentation/providers/course_providers.dart';
import '../providers/progress_providers.dart';

class ProgressScreen extends ConsumerWidget {
  final String courseId;

  const ProgressScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressAsync = ref.watch(courseProgressProvider(courseId));
    final courseAsync = ref.watch(courseDetailProvider(courseId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Course Progress')),
      body: SafeArea(
        child: progressAsync.when(
          data: (progress) {
            final course = courseAsync.valueOrNull;
            final isComplete = progress.percentage >= 100.0;

            final double lessonPct = progress.totalLessons > 0
                ? (progress.completedLessons / progress.totalLessons) * 100
                : 0.0;
            final double quizPct = progress.totalQuizzes > 0
                ? (progress.completedQuizzes / progress.totalQuizzes) * 100
                : 100.0;
            final double asgPct = progress.totalAssignments > 0
                ? (progress.submittedAssignments / progress.totalAssignments) * 100
                : 100.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Overall Progress Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: isComplete ? AppColors.successGradient : AppColors.primaryGradient,
                      borderRadius: AppRadius.xlRadius,
                      boxShadow: [
                        BoxShadow(
                          color: (isComplete ? AppColors.success : AppColors.primary).withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Overall Completion',
                          style: AppTextStyles.titleMedium.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${progress.percentage.toStringAsFixed(0)}%',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          course?.title ?? 'Course Progress',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text('Breakdown by Milestones', style: AppTextStyles.titleLarge),
                  const SizedBox(height: 14),

                  // 1. Lessons Progress (60% weight)
                  _buildMilestoneCard(
                    icon: Icons.play_circle_outline_rounded,
                    title: 'Video Lessons',
                    weight: '60% Weight',
                    completed: progress.completedLessons,
                    total: progress.totalLessons,
                    percentage: lessonPct,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // 2. Quiz Progress (20% weight)
                  _buildMilestoneCard(
                    icon: Icons.quiz_outlined,
                    title: 'Quizzes & Assessments',
                    weight: '20% Weight',
                    completed: progress.completedQuizzes,
                    total: progress.totalQuizzes,
                    percentage: quizPct,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // 3. Assignment Progress (20% weight)
                  _buildMilestoneCard(
                    icon: Icons.assignment_outlined,
                    title: 'Hands-on Assignments',
                    weight: '20% Weight',
                    completed: progress.submittedAssignments,
                    total: progress.totalAssignments,
                    percentage: asgPct,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 28),

                  // Certificate Eligibility Banner
                  if (isComplete) ...[
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight.withValues(alpha: 0.2),
                        borderRadius: AppRadius.lgRadius,
                        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.workspace_premium_rounded, color: AppColors.warning, size: 26),
                              const SizedBox(width: 10),
                              Text(
                                'Certificate Unlocked!',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You have completed 100% of the course requirements. Your verified certificate has been issued.',
                          ),
                          const SizedBox(height: 14),
                          AppButton(
                            text: 'View Certificate',
                            variant: AppButtonVariant.primary,
                            icon: Icons.visibility_rounded,
                            height: 42,
                            onPressed: () => context.push('/certificates/cert_01'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: AppRadius.mdRadius,
                        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded, color: AppColors.textMutedLight, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Complete remaining lessons and tasks to unlock your certificate of completion.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => const LoadingView(message: 'Calculating progress...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(courseProgressProvider(courseId))),
        ),
      ),
    );
  }

  Widget _buildMilestoneCard({
    required IconData icon,
    required String title,
    required String weight,
    required int completed,
    required int total,
    required double percentage,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
              ),
              Text(weight, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
            ],
          ),
          const SizedBox(height: 12),
          CourseLinearProgress(percentage: percentage, showLabel: false, height: 6),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$completed of $total completed', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
              Text('${percentage.toStringAsFixed(0)}%', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}
