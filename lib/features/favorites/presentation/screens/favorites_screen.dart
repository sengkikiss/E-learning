import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/compact_course_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../courses/presentation/providers/course_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final savedCoursesAsync = ref.watch(savedCoursesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Saved Courses')),
      body: SafeArea(
        child: savedCoursesAsync.when(
          data: (courses) {
            if (courses.isEmpty) {
              return EmptyView(
                title: 'No saved courses yet',
                message: 'Tap the bookmark icon on any course card to save it for later.',
                action: AppButton(
                  text: 'Explore Courses',
                  width: 160,
                  onPressed: () => context.go(RouteNames.explore),
                ),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark_rounded, color: AppColors.primary),
                    onPressed: () {
                      ref.read(favoriteCourseNotifierProvider.notifier).toggle(course.id, true);
                    },
                  ),
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading your saved courses...'),
          error: (e, _) => ErrorView(
            message: e.toString(),
            onRetry: () => ref.invalidate(savedCoursesProvider),
          ),
        ),
      ),
    );
  }
}
