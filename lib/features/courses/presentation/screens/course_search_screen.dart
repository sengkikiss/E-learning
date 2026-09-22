import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/compact_course_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../providers/course_providers.dart';

class CourseSearchScreen extends ConsumerStatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  ConsumerState<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends ConsumerState<CourseSearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final params = CourseSearchParams(query: _controller.text.trim());
    final searchAsync = ref.watch(searchCoursesProvider(params));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: AppSearchBar(
          controller: _controller,
          hintText: 'Type to search courses...',
          showFilterButton: false,
          onChanged: (_) => setState(() {}),
          onClear: () => setState(() => _controller.clear()),
        ),
      ),
      body: SafeArea(
        child: searchAsync.when(
          data: (courses) {
            if (courses.isEmpty) {
              return const EmptyView(
                title: 'No matching courses',
                message: 'Try checking your spelling or search for Flutter, Python, Web, etc.',
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
          loading: () => const LoadingView(message: 'Searching...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => setState(() {})),
        ),
      ),
    );
  }
}
