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
import '../../../../core/widgets/status_badge.dart';
import '../providers/quiz_providers.dart';

class QuizIntroScreen extends ConsumerWidget {
  final String quizId;

  const QuizIntroScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quizAsync = ref.watch(quizDetailProvider(quizId));
    final attemptsAsync = ref.watch(quizAttemptsProvider(quizId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Quiz Assessment')),
      body: SafeArea(
        child: quizAsync.when(
          data: (quiz) {
            final attempts = attemptsAsync.valueOrNull ?? [];
            final bool hasAttempted = attempts.isNotEmpty;
            final lastAttempt = hasAttempted ? attempts.last : null;

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
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.quiz_rounded,
                                size: 56,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              quiz.title,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.displaySmall.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              quiz.description,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Quiz Metrics Cards
                          Row(
                            children: [
                              _buildMetricCard(
                                icon: Icons.help_outline_rounded,
                                title: 'Questions',
                                value: '${quiz.totalQuestions}',
                                isDark: isDark,
                              ),
                              const SizedBox(width: 12),
                              _buildMetricCard(
                                icon: Icons.timer_outlined,
                                title: 'Duration',
                                value: '${quiz.timeLimitMinutes} min',
                                isDark: isDark,
                              ),
                              const SizedBox(width: 12),
                              _buildMetricCard(
                                icon: Icons.verified_outlined,
                                title: 'Passing',
                                value: '${quiz.passingScore.toInt()}%',
                                isDark: isDark,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Rules
                          Text('Important Rules', style: AppTextStyles.titleMedium),
                          const SizedBox(height: 10),
                          _buildRuleItem('You have ${quiz.timeLimitMinutes} minutes to complete all questions.'),
                          _buildRuleItem('Each question has only one correct answer.'),
                          _buildRuleItem('You need ${quiz.passingScore.toInt()}% or higher to pass this quiz.'),
                          _buildRuleItem('You can retake this quiz up to ${quiz.maximumAttempts} times.'),
                          const SizedBox(height: 20),

                          // Past Attempts
                          if (hasAttempted) ...[
                            Text('Previous Attempt', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardDark : Colors.white,
                                borderRadius: AppRadius.mdRadius,
                                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Score: ${lastAttempt?.score ?? 0} pts (${lastAttempt?.percentage.toStringAsFixed(0)}%)',
                                        style: AppTextStyles.titleSmall.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${lastAttempt?.correctAnswers ?? 0} correct out of ${quiz.totalQuestions}',
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedLight),
                                      ),
                                    ],
                                  ),
                                  StatusBadge(
                                    text: (lastAttempt?.passed ?? false) ? 'Passed' : 'Failed',
                                    type: (lastAttempt?.passed ?? false) ? BadgeType.success : BadgeType.error,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Start Button
                  AppButton(
                    text: hasAttempted ? 'Retake Quiz' : 'Start Quiz Now',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () {
                      context.push('/quiz/${quiz.id}/start');
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const LoadingView(message: 'Loading quiz...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(quizDetailProvider(quizId))),
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            Text(title, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 4),
          Expanded(child: Text(rule, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
