import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/compact_course_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../providers/course_providers.dart';

class CoursesByCategoryScreen extends ConsumerWidget {
  final String categoryId;

  const CoursesByCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coursesAsync = ref.watch(coursesByCategoryProvider(categoryId));
    final categoriesAsync = ref.watch(categoriesProvider);

    String categoryTitle = 'Category';
    final cats = categoriesAsync.valueOrNull;
    if (cats != null) {
      final match = cats.firstWhere((c) => c.id == categoryId, orElse: () => cats.first);
      categoryTitle = match.name;
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: SafeArea(
        child: coursesAsync.when(
          data: (courses) {
            if (courses.isEmpty) {
              return const EmptyView(
                title: 'No courses in this category',
                message: 'New courses will be added soon!',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = courses[index];
                return CompactCourseCard(
                  course: course,
                  onTap: () => context.push('/courses/${course.id}'),
                  onBookmarkToggle: () {
                    ref.read(favoriteCourseNotifierProvider.notifier).toggle(course.id, course.isSaved);
                  },
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading courses...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(coursesByCategoryProvider(categoryId))),
        ),
      ),
    );
  }
}
