import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/di/dependency_injection.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Learn Anywhere, Anytime',
      'description': 'Access hundreds of high-quality courses taught by industry experts with offline progress and interactive video player.',
      'icon': Icons.devices_rounded,
      'gradient': AppColors.primaryGradient,
    },
    {
      'title': 'Hands-on Quizzes & Assignments',
      'description': 'Reinforce your knowledge with instant quiz feedback, structured coding assignments, and real-time grades.',
      'icon': Icons.assignment_turned_in_rounded,
      'gradient': AppColors.accentGradient,
    },
    {
      'title': 'Earn Recognized Certificates',
      'description': 'Complete courses, achieve passing scores, and claim verified certificates to boost your career portfolio.',
      'icon': Icons.workspace_premium_rounded,
      'gradient': AppColors.successGradient,
    },
  ];

  void _onFinish() {
    ref.read(settingsLocalDataSourceProvider).setOnboardingCompleted();
    context.go(RouteNames.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _onFinish,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textMutedLight),
                    ),
                  ),
                ],
              ),
            ),

            // PageView Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: slide['gradient'] as LinearGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (slide['gradient'] as LinearGradient).colors.first.withValues(alpha: 0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            slide['icon'] as IconData,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide['title'] as String,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displaySmall.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['description'] as String,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator and Action Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final bool isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isSelected ? 28 : 8,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.borderLight,
                          borderRadius: AppRadius.fullRadius,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: _currentPage == _slides.length - 1 ? 'Get Started' : 'Continue',
                    icon: _currentPage == _slides.length - 1 ? Icons.arrow_forward_rounded : null,
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _onFinish();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
