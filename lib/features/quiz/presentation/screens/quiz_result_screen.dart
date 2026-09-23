import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class QuizResultScreen extends StatelessWidget {
  final String quizId;
  final int score;
  final double percentage;
  final bool passed;
  final int correctAnswers;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.quizId,
    required this.score,
    required this.percentage,
    required this.passed,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final incorrect = totalQuestions - correctAnswers;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Trophy / Status Badge
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: passed ? AppColors.successLight.withValues(alpha: 0.3) : AppColors.errorLight.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed ? Icons.emoji_events_rounded : Icons.sentiment_dissatisfied_rounded,
                  size: 72,
                  color: passed ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                passed ? 'Congratulations! 🎉' : 'Keep Practicing!',
                style: AppTextStyles.displaySmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                passed
                    ? 'You passed the assessment with flying colors!'
                    : 'You did not achieve the 70% passing threshold this time.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 32),

              // Score Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: passed ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('Total Score: $score pts', style: AppTextStyles.labelLarge),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Correct', '$correctAnswers', AppColors.success),
                        _buildStat('Incorrect', '$incorrect', AppColors.error),
                        _buildStat('Total', '$totalQuestions', AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              AppButton(
                text: 'Review Answers',
                variant: AppButtonVariant.outline,
                icon: Icons.checklist_rounded,
                onPressed: () => context.push('/quiz/$quizId/review'),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: passed ? 'Back to Courses' : 'Retake Quiz',
                icon: passed ? Icons.home_rounded : Icons.replay_rounded,
                onPressed: () {
                  if (passed) {
                    context.go(RouteNames.home);
                  } else {
                    context.pushReplacement('/quiz/$quizId/start');
                  }
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineSmall.copyWith(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
      ],
    );
  }
}
