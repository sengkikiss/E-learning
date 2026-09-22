import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/quiz_option_card.dart';
import '../providers/quiz_providers.dart';

class QuizReviewScreen extends ConsumerWidget {
  final String quizId;

  const QuizReviewScreen({super.key, required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quizAsync = ref.watch(quizDetailProvider(quizId));
    final attemptsAsync = ref.watch(quizAttemptsProvider(quizId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Review Answers')),
      body: SafeArea(
        child: quizAsync.when(
          data: (quiz) {
            final attempts = attemptsAsync.valueOrNull ?? [];
            final latestAttempt = attempts.isNotEmpty ? attempts.last : null;
            final userAnswers = latestAttempt?.selectedAnswers ?? {};

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: quiz.questions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (context, qIndex) {
                final q = quiz.questions[qIndex];
                final selectedOption = userAnswers[qIndex];
                final isCorrect = selectedOption == q.correctAnswerIndex;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: AppRadius.lgRadius,
                    border: Border.all(
                      color: isCorrect ? AppColors.success.withOpacity(0.4) : AppColors.error.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${qIndex + 1}',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isCorrect ? AppColors.successLight.withOpacity(0.3) : AppColors.errorLight.withOpacity(0.3),
                              borderRadius: AppRadius.fullRadius,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                  size: 14,
                                  color: isCorrect ? AppColors.success : AppColors.error,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isCorrect ? 'Correct' : 'Incorrect',
                                  style: TextStyle(
                                    color: isCorrect ? AppColors.success : AppColors.error,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        q.questionText,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Options with highlight
                      ...q.options.asMap().entries.map((entry) {
                        final optIdx = entry.key;
                        final optText = entry.value;
                        final isUserChoice = selectedOption == optIdx;
                        final isOptionCorrect = q.correctAnswerIndex == optIdx;

                        return QuizOptionCard(
                          optionText: optText,
                          index: optIdx,
                          isSelected: isUserChoice,
                          isReviewMode: true,
                          isCorrect: isOptionCorrect,
                        );
                      }),

                      const SizedBox(height: 12),
                      // Explanation container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.infoLight.withOpacity(0.15),
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(color: AppColors.info.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline_rounded, size: 16, color: AppColors.info),
                                SizedBox(width: 6),
                                Text(
                                  'Explanation',
                                  style: TextStyle(
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              q.explanation,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading review...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(quizDetailProvider(quizId))),
        ),
      ),
    );
  }
}
