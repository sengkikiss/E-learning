import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/instructor_card.dart';
import '../../../../core/widgets/lesson_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/rating_view.dart';
import '../../../../core/widgets/status_badge.dart';
import 'package:e_learning/features/enrollment/presentation/providers/enrollment_providers.dart';
import 'package:e_learning/features/lessons/presentation/providers/lesson_providers.dart';
import '../providers/course_providers.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleEnroll(BuildContext context) async {
    final success = await ref.read(enrollmentNotifierProvider.notifier).enroll(widget.courseId);
    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Enrolled successfully! Ready to start.');
      context.push('/learning/${widget.courseId}');
    } else if (mounted) {
      AppSnackbar.showError(context, 'Failed to enroll. Please retry.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final isEnrolledAsync = ref.watch(isCourseEnrolledProvider(widget.courseId));
    final lessonsAsync = ref.watch(lessonsProvider(widget.courseId));
    final enrollmentState = ref.watch(enrollmentNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: courseAsync.when(
        data: (course) {
          final bool isEnrolled = isEnrolledAsync.valueOrNull ?? false;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: course.imageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(color: AppColors.primaryDark),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Play Icon preview
                        Center(
                          child: InkWell(
                            onTap: () {
                              if (isEnrolled) {
                                context.push('/learning/${course.id}');
                              } else {
                                AppSnackbar.showInfo(context, 'Enroll to watch full lessons and video player.');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.85),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 36),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        course.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ref.read(favoriteCourseNotifierProvider.notifier).toggle(course.id, course.isSaved);
                      },
                    ),
                  ],
                ),
              ];
            },
            body: Column(
              children: [
                // Top Info Section
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(text: course.categoryName, type: BadgeType.info),
                          StatusBadge(text: course.level, type: BadgeType.neutral),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        course.title,
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          RatingView(rating: course.rating, reviewCount: course.enrollmentCount ~/ 3),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textMutedLight),
                          const SizedBox(width: 4),
                          Text(course.duration, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
                          const SizedBox(width: 12),
                          const Icon(Icons.menu_book_rounded, size: 16, color: AppColors.textMutedLight),
                          const SizedBox(width: 4),
                          Text('${course.lessonCount} lessons', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tabs: About, Curriculum, Instructor
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'About'),
                    Tab(text: 'Curriculum'),
                    Tab(text: 'Instructor'),
                  ],
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // 1. About Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Course Description', style: AppTextStyles.titleLarge),
                            const SizedBox(height: 8),
                            Text(
                              course.description,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('What You Will Learn', style: AppTextStyles.titleLarge),
                            const SizedBox(height: 10),
                            ...[
                              'Clean Architecture & SOLID design principles',
                              'Reactive state management & immutable data models',
                              'REST API integration with Dio & interceptors',
                              'Practical projects, quizzes, and graded assignments',
                            ].map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),

                      // 2. Curriculum Tab
                      lessonsAsync.when(
                        data: (lessons) => ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.screenPadding),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            return LessonCard(
                              lesson: lesson,
                              onTap: () {
                                if (isEnrolled) {
                                  context.push('/learning/${course.id}');
                                } else {
                                  AppSnackbar.showInfo(context, 'Please enroll in the course to access lessons.');
                                }
                              },
                            );
                          },
                        ),
                        loading: () => const LoadingView(),
                        error: (e, _) => ErrorView(message: e.toString()),
                      ),

                      // 3. Instructor Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.screenPadding),
                        child: InstructorCard(
                          name: course.instructorName,
                          title: 'Expert Instructor & Tech Lead',
                          bio: 'Dr. Sarah has over 10+ years of software engineering leadership, guiding thousands of developers worldwide.',
                          avatarUrl: course.instructorAvatar ?? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Action Bar: Price & Enroll Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Price', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
                          Text(
                            course.isFree ? 'Free' : '\$${course.price.toStringAsFixed(2)}',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: course.isFree ? AppColors.success : AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (!course.isFree)
                            Text(
                              '≈ ៛${(course.price * 4100).round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AppButton(
                          text: isEnrolled
                              ? 'Continue Learning'
                              : (course.isFree ? 'Enroll for Free' : 'Pay & Enroll Now'),
                          isLoading: enrollmentState.isLoading,
                          icon: isEnrolled
                              ? Icons.play_arrow_rounded
                              : (course.isFree ? Icons.school_rounded : Icons.payment_rounded),
                          onPressed: () {
                            if (isEnrolled) {
                              context.push('/learning/${course.id}');
                            } else if (course.isFree) {
                              _handleEnroll(context);
                            } else {
                              context.push('/payment/${course.id}');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Scaffold(body: LoadingView(message: 'Loading course...')),
        error: (e, _) => Scaffold(body: ErrorView(message: e.toString(), onRetry: () => ref.invalidate(courseDetailProvider(widget.courseId)))),
      ),
    );
  }
}
