import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/assignment_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../providers/assignment_providers.dart';

class AssignmentListScreen extends ConsumerWidget {
  final String courseId;

  const AssignmentListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final assignmentsAsync = ref.watch(assignmentsProvider(courseId));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Course Assignments')),
      body: SafeArea(
        child: assignmentsAsync.when(
          data: (assignments) {
            if (assignments.isEmpty) {
              return const EmptyView(
                title: 'No assignments yet',
                message: 'Assignments for this course will appear here.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: assignments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                return Consumer(
                  builder: (context, ref, _) {
                    final submissionAsync = ref.watch(submissionProvider(assignment.id));
                    final submission = submissionAsync.valueOrNull;

                    return AssignmentCard(
                      assignment: assignment,
                      submissionStatus: submission?.status.name,
                      score: submission?.score,
                      onTap: () => context.push('/assignments/${assignment.id}'),
                    );
                  },
                );
              },
            );
          },
          loading: () => const LoadingView(message: 'Loading assignments...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(assignmentsProvider(courseId))),
        ),
      ),
    );
  }
}
