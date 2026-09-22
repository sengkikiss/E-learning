import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/progress_indicator.dart';
import 'package:e_learning/features/enrollment/presentation/providers/enrollment_providers.dart';
import 'package:e_learning/features/progress/presentation/providers/progress_providers.dart';

class MyLearningScreen extends ConsumerStatefulWidget {
  const MyLearningScreen({super.key});

  @override
  ConsumerState<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends ConsumerState<MyLearningScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enrolledAsync = ref.watch(enrolledCoursesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('My Learning'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: SafeArea(
        child: enrolledAsync.when(
          data: (courses) {
            if (courses.isEmpty) {
              return EmptyView(
                title: 'No enrolled courses yet',
                message: 'Discover courses and start learning new skills today.',
                action: AppButton(
                  text: 'Browse Courses',
                  width: 160,
                  onPressed: () => context.go(RouteNames.explore),
                ),
              );
            }

            // Split into ongoing vs completed
            final ongoingCourses = courses.where((c) => c.id != 'crs_04').toList();
            final completedCourses = courses.where((c) => c.id == 'crs_04').toList();

            return TabBarView(
              controller: _tabController,
              children: [
                // 1. Ongoing tab
                _buildCourseList(ongoingCourses, isCompletedTab: false, isDark: isDark),

                // 2. Completed tab
                _buildCourseList(completedCourses, isCompletedTab: true, isDark: isDark),
              ],
            );
          },
          loading: () => const LoadingView(message: 'Loading your learning progress...'),
          error: (e, _) => ErrorView(
            message: e.toString(),
            onRetry: () => ref.invalidate(enrolledCoursesProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseList(List courses, {required bool isCompletedTab, required bool isDark}) {
    if (courses.isEmpty) {
      return EmptyView(
        title: isCompletedTab ? 'No completed courses yet' : 'No ongoing courses',
        message: isCompletedTab
            ? 'Complete all lessons, quizzes, and assignments to claim your certificate!'
            : 'Explore courses and begin your learning path.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final course = courses[index];
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: AppRadius.smRadius,
                      child: Image.network(
                        course.imageUrl,
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.categoryName.toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar
                Consumer(
                  builder: (context, ref, _) {
                    final progressAsync = ref.watch(courseProgressProvider(course.id));
                    final progress = progressAsync.valueOrNull;
                    final percentage = isCompletedTab ? 100.0 : (progress?.percentage ?? 45.0);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CourseLinearProgress(percentage: percentage),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${progress?.completedLessons ?? (isCompletedTab ? course.lessonCount : 2)} of ${course.lessonCount} lessons completed',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedLight),
                            ),
                            InkWell(
                              onTap: () => context.push('/progress/${course.id}'),
                              child: Text(
                                'View Stats',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: isCompletedTab ? 'Review Course' : 'Continue Learning',
                        height: 42,
                        icon: isCompletedTab ? Icons.replay_rounded : Icons.play_arrow_rounded,
                        onPressed: () => context.push('/learning/${course.id}'),
                      ),
                    ),
                    if (isCompletedTab) ...[
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.workspace_premium_rounded, color: AppColors.warning),
                        tooltip: 'View Certificate',
                        onPressed: () => context.push('/certificates/cert_01'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
