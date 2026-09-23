import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/category_card.dart';
import '../../../../core/widgets/course_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/progress_indicator.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../courses/presentation/providers/course_providers.dart';
import '../../../enrollment/presentation/providers/enrollment_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    final popularAsync = ref.watch(popularCoursesProvider);
    final recommendedAsync = ref.watch(recommendedCoursesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final enrolledAsync = ref.watch(enrolledCoursesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(popularCoursesProvider);
            ref.invalidate(recommendedCoursesProvider);
            ref.invalidate(categoriesProvider);
            ref.invalidate(enrolledCoursesProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header: User Greeting & Notifications
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: currentUser?.profilePhoto != null
                                ? NetworkImage(currentUser!.profilePhoto!)
                                : null,
                            child: currentUser?.profilePhoto == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, ${currentUser?.fullName.split(' ').first ?? 'Learner'} 👋',
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: AppRadius.fullRadius,
                                    ),
                                    child: Text(
                                      currentUser?.role.name.toUpperCase() ?? 'STUDENT',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'What will you learn today?',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Notification Bell with Badge
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none_rounded, size: 26),
                            onPressed: () => context.push(RouteNames.notifications),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                child: Text(
                                  '$unreadCount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Search Trigger
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: AppSearchBar(
                    readOnly: true,
                    onTap: () => context.push(RouteNames.courseSearch),
                    onFilterPressed: () => context.push(RouteNames.explore),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Hero Promo Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: AppRadius.lgRadius,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: AppRadius.smRadius,
                                ),
                                child: const Text(
                                  'LIMITED TIME OFFER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upgrade Your Career with Tech Skills',
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: () => context.push(RouteNames.explore),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryDark,
                                  minimumSize: const Size(120, 36),
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smRadius),
                                ),
                                child: const Text('Explore Courses'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.rocket_launch_rounded,
                          size: 72,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Continue Learning Section (if enrolled)
                enrolledAsync.when(
                  data: (enrolled) {
                    if (enrolled.isEmpty) return const SizedBox.shrink();
                    final activeCourse = enrolled.first;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Continue Learning',
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go(RouteNames.myCourses),
                                child: const Text('My Courses'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => context.push('/learning/${activeCourse.id}'),
                            borderRadius: AppRadius.lgRadius,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardDark : Colors.white,
                                borderRadius: AppRadius.lgRadius,
                                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: AppRadius.smRadius,
                                        child: Image.network(
                                          activeCourse.imageUrl,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              activeCourse.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.titleMedium.copyWith(
                                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Next: Lesson 2 • ${activeCourse.duration}',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 36),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Consumer(
                                    builder: (context, ref, _) {
                                      final progressAsync = ref.watch(courseProgressProvider(activeCourse.id));
                                      final percentage = progressAsync.valueOrNull?.percentage ?? 45.0;
                                      return CourseLinearProgress(percentage: percentage);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                // 5. Categories Strip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top Categories',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(RouteNames.explore),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                categoriesAsync.when(
                  data: (cats) => SizedBox(
                    height: 60,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: cats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = cats[index];
                        return CategoryCard(
                          category: cat,
                          onTap: () => context.push('/categories/${cat.id}'),
                        );
                      },
                    ),
                  ),
                  loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 28),

                // 6. Popular Courses Carousel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Courses',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(RouteNames.explore),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                popularAsync.when(
                  data: (courses) => SizedBox(
                    height: 335,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                      scrollDirection: Axis.horizontal,
                      itemCount: courses.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return CourseCard(
                          course: course,
                          onTap: () => context.push('/courses/${course.id}'),
                          onBookmarkToggle: () {
                            ref.read(favoriteCourseNotifierProvider.notifier).toggle(course.id, course.isSaved);
                          },
                        );
                      },
                    ),
                  ),
                  loading: () => const SizedBox(height: 335, child: LoadingView(message: 'Loading popular courses...')),
                  error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(popularCoursesProvider)),
                ),
                const SizedBox(height: 28),

                // 7. Recommended For You List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended For You',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push(RouteNames.explore),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                recommendedAsync.when(
                  data: (courses) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.take(4).length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return CourseCard(
                        course: course,
                        width: double.infinity,
                        onTap: () => context.push('/courses/${course.id}'),
                        onBookmarkToggle: () {
                          ref.read(favoriteCourseNotifierProvider.notifier).toggle(course.id, course.isSaved);
                        },
                      );
                    },
                  ),
                  loading: () => const LoadingView(message: 'Loading recommendations...'),
                  error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(recommendedCoursesProvider)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
