import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../enrollment/presentation/providers/enrollment_providers.dart';
import '../../../progress/presentation/providers/progress_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showRoleSwitcher(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: AppRadius.fullRadius),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Switch Demo Role', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 8),
              const Text('Switch user roles instantly to test role-guarded features:'),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.school_rounded, color: AppColors.primary),
                title: const Text('Student (Dara Somnang)'),
                subtitle: const Text('Access student courses, video player, quizzes, assignments'),
                onTap: () {
                  ref.read(authNotifierProvider.notifier).switchDemoRole(UserRole.student);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cast_for_education_rounded, color: AppColors.accentOrange),
                title: const Text('Instructor (Dr. Sarah Connor)'),
                subtitle: const Text('Access instructor dashboard, course metrics, grading'),
                onTap: () {
                  ref.read(authNotifierProvider.notifier).switchDemoRole(UserRole.instructor);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.error),
                title: const Text('Admin (Alex Vance)'),
                subtitle: const Text('Access admin dashboard, user metrics, platform controls'),
                onTap: () {
                  ref.read(authNotifierProvider.notifier).switchDemoRole(UserRole.admin);
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: 'Log Out',
      message: 'Are you sure you want to log out of EduLearn?',
      confirmText: 'Log Out',
      isDestructive: true,
    );

    if (confirmed == true) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (context.mounted) {
        context.go(RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUser = ref.watch(currentUserProvider);
    final enrolledCoursesAsync = ref.watch(enrolledCoursesProvider);
    final certificatesAsync = ref.watch(certificatesProvider);

    final enrolledCount = enrolledCoursesAsync.valueOrNull?.length ?? 0;
    final certCount = certificatesAsync.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RouteNames.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            children: [
              // User Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundImage: currentUser?.profilePhoto != null
                              ? NetworkImage(currentUser!.profilePhoto!)
                              : null,
                          child: currentUser?.profilePhoto == null
                              ? const Icon(Icons.person, size: 46)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () => context.push(RouteNames.editProfile),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      currentUser?.fullName ?? 'Dara Somnang',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser?.email ?? 'student@edulearn.com',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedLight),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatusBadge(
                          text: currentUser?.role.name.toUpperCase() ?? 'STUDENT',
                          type: currentUser?.isAdmin ?? false
                              ? BadgeType.error
                              : (currentUser?.isInstructor ?? false ? BadgeType.warning : BadgeType.info),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          avatar: const Icon(Icons.swap_horiz_rounded, size: 14),
                          label: const Text('Switch Role', style: TextStyle(fontSize: 11)),
                          onPressed: () => _showRoleSwitcher(context, ref),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  _buildStatItem(
                    label: 'Courses',
                    value: '$enrolledCount',
                    icon: Icons.menu_book_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildStatItem(
                    label: 'Certificates',
                    value: '$certCount',
                    icon: Icons.workspace_premium_rounded,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _buildStatItem(
                    label: 'Study Hours',
                    value: '48h',
                    icon: Icons.timer_outlined,
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Menu Sections
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile Information',
                      onTap: () => context.push(RouteNames.editProfile),
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      icon: Icons.history_rounded,
                      title: 'Learning Activity History',
                      onTap: () => context.push(RouteNames.history),
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      icon: Icons.workspace_premium_outlined,
                      title: 'My Earned Certificates',
                      onTap: () => context.push(RouteNames.certificates),
                    ),

                    // Role specific links
                    if (currentUser?.isInstructor ?? false) ...[
                      _buildDivider(isDark),
                      _buildMenuItem(
                        icon: Icons.dashboard_customize_outlined,
                        title: 'Instructor Dashboard',
                        iconColor: AppColors.accentOrange,
                        onTap: () => context.push(RouteNames.instructorDashboard),
                      ),
                    ],

                    if (currentUser?.isAdmin ?? false) ...[
                      _buildDivider(isDark),
                      _buildMenuItem(
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Admin Platform Dashboard',
                        iconColor: AppColors.error,
                        onTap: () => context.push(RouteNames.adminDashboard),
                      ),
                    ],

                    _buildDivider(isDark),
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings & Preferences',
                      onTap: () => context.push(RouteNames.settings),
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      iconColor: AppColors.error,
                      textColor: AppColors.error,
                      onTap: () => _handleLogout(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700)),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(title, style: AppTextStyles.labelLarge.copyWith(color: textColor)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}
