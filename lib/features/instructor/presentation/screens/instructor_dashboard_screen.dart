import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../courses/presentation/providers/course_providers.dart';

class InstructorDashboardScreen extends ConsumerWidget {
  const InstructorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Instructor Dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEA580C), Color(0xFFF97316)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.lgRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INSTRUCTOR PORTAL',
                      style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Welcome, Dr. Sarah Connor',
                      style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Manage your curriculum, review student submissions, and inspect quiz performance.',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KPI Stats
              Row(
                children: [
                  _buildKpiCard('Active Students', '4,892', Icons.people_outline_rounded, isDark),
                  const SizedBox(width: 12),
                  _buildKpiCard('Total Courses', '6', Icons.school_outlined, isDark),
                  const SizedBox(width: 12),
                  _buildKpiCard('Avg Rating', '4.9 ★', Icons.star_outline_rounded, isDark),
                ],
              ),
              const SizedBox(height: 28),

              // Quick Actions
              const Text('Instructor Quick Actions', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Create Course',
                      icon: Icons.add_circle_outline_rounded,
                      height: 44,
                      onPressed: () {
                        AppSnackbar.showInfo(context, 'Course builder prototype ready. Connect Spring Boot to persist.');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Grade Submissions',
                      variant: AppButtonVariant.outline,
                      icon: Icons.grading_rounded,
                      height: 44,
                      onPressed: () => context.push('/assignments/asg_01'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Authored Courses
              const Text('My Authored Courses', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              coursesAsync.when(
                data: (courses) {
                  final authored = courses.where((c) => c.instructorId == 'inst_01').toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: authored.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final c = authored[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: AppRadius.smRadius,
                              child: Image.network(c.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.titleSmall),
                                  const SizedBox(height: 4),
                                  Text('${c.enrollmentCount} students enrolled • ${c.lessonCount} lessons', style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            const StatusBadge(text: 'Published', type: BadgeType.success),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(e.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accentOrange, size: 22),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
            Text(label, textAlign: TextAlign.center, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
          ],
        ),
      ),
    );
  }
}
