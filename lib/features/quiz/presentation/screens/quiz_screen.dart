import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/progress_indicator.dart';
import '../../../../core/widgets/quiz_option_card.dart';
import '../providers/quiz_providers.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  Timer? _timer;
  int _remainingSeconds = 600; // 10 minutes default
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _autoSubmit();
      }
    });
  }

  void _autoSubmit() {
    _handleSubmitQuiz();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleSubmitQuiz() async {
    final quizAsync = ref.read(quizDetailProvider(widget.quizId));
    final totalQuestions = quizAsync.valueOrNull?.questions.length ?? 0;
    final answeredCount = _selectedAnswers.length;

    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Submit Quiz?',
      message: 'You have answered $answeredCount out of $totalQuestions questions. Would you like to finish and see your score?',
      confirmText: 'Submit Now',
    );

    if (confirmed != true) return;

    setState(() => _isSubmitting = true);
    _timer?.cancel();

    final attempt = await ref.read(quizSubmissionNotifierProvider.notifier).submitQuiz(
          quizId: widget.quizId,
          selectedAnswers: _selectedAnswers,
        );

    setState(() => _isSubmitting = false);

    if (attempt != null && mounted) {
      context.pushReplacement('/quiz/${widget.quizId}/result?score=${attempt.score}&percentage=${attempt.percentage}&passed=${attempt.passed}&correct=${attempt.correctAnswers}&total=$totalQuestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quizAsync = ref.watch(quizDetailProvider(widget.quizId));

    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return WillPopScope(
      onWillPop: () async {
        final leave = await AppDialog.showConfirmation(
          context: context,
          title: 'Exit Quiz?',
          message: 'Are you sure you want to leave? Your answers will not be saved.',
          confirmText: 'Leave',
          isDestructive: true,
        );
        return leave ?? false;
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Quiz Assessment'),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _remainingSeconds < 120 ? AppColors.errorLight.withOpacity(0.3) : AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: _remainingSeconds < 120 ? AppColors.error : AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeStr,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: _remainingSeconds < 120 ? AppColors.error : AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: quizAsync.when(
            data: (quiz) {
              final questions = quiz.questions;
              if (questions.isEmpty) {
                return const Center(child: Text('No questions found in this quiz.'));
              }

              final currentQ = questions[_currentQuestionIndex];
              final progressPct = ((_currentQuestionIndex + 1) / questions.length) * 100.0;
              final bool isLast = _currentQuestionIndex == questions.length - 1;

              return Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${_selectedAnswers.length}/${questions.length} answered',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CourseLinearProgress(percentage: progressPct, showLabel: false, height: 6),
                    const SizedBox(height: 24),

                    // Question Text Card
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentQ.questionText,
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Options List
                            ...currentQ.options.asMap().entries.map((entry) {
                              final optIndex = entry.key;
                              final optText = entry.value;
                              final isSelected = _selectedAnswers[_currentQuestionIndex] == optIndex;

                              return QuizOptionCard(
                                optionText: optText,
                                index: optIndex,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedAnswers[_currentQuestionIndex] = optIndex;
                                  });
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),

                    // Navigation Footer: Previous & Next / Submit
                    Row(
                      children: [
                        if (_currentQuestionIndex > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _currentQuestionIndex--;
                                });
                              },
                              child: const Text('Previous'),
                            ),
                          ),
                        if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: isLast ? 'Submit Quiz' : 'Next Question',
                            icon: isLast ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                            isLoading: _isSubmitting,
                            onPressed: () {
                              if (isLast) {
                                _handleSubmitQuiz();
                              } else {
                                setState(() {
                                  _currentQuestionIndex++;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            loading: () => const LoadingView(message: 'Loading quiz questions...'),
            error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(quizDetailProvider(widget.quizId))),
          ),
        ),
      ),
    );
  }
}
