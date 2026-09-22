import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/config/app_config.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../data/datasources/remote/fake_api/fake_database.dart';
import '../../../../data/models/auth/user_model.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Admin System Portal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3730A3), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppRadius.lgRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SYSTEM ADMINISTRATOR CONSOLE', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'EduLearn Platform Operations',
                      style: AppTextStyles.headlineSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text(
                          'Backend Status: ${AppConfig.useFakeApi ? 'Fake REST API Emulation Mode' : 'Spring Boot Live Mode'}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KPI Metrics
              Text('Platform Overview', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                children: [
                  _buildAdminCard('Total Students', '12,450', '+18% this month', Icons.people_alt_rounded, AppColors.info, isDark),
                  _buildAdminCard('Course Catalog', '${FakeDatabase.courses.length}', '20 published', Icons.school_rounded, AppColors.primary, isDark),
                  _buildAdminCard('Certificates Issued', '1,894', 'Verified credentials', Icons.workspace_premium_rounded, AppColors.warning, isDark),
                  _buildAdminCard('Gross Revenue', '\$48,920', 'Stripe / Bank transfers', Icons.attach_money_rounded, AppColors.success, isDark),
                ],
              ),
              const SizedBox(height: 28),

              // Backend Toggle
              Text('Backend Integration Controls', style: AppTextStyles.titleLarge),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Use Fake REST API', style: AppTextStyles.titleSmall),
                              const SizedBox(height: 4),
                              Text(
                                'Toggle to switch between FakeDatabase and Spring Boot endpoints',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: AppConfig.useFakeApi,
                          activeColor: AppColors.primary,
                          onChanged: (val) {
                            setState(() {
                              AppConfig.useFakeApi = val;
                            });
                            AppSnackbar.showSuccess(
                              context,
                              val ? 'Switched to Fake REST API' : 'Switched to Spring Boot API Mode',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Registered Users Table Preview
              Text('Registered Accounts (${FakeDatabase.users.length})', style: AppTextStyles.titleLarge),
              const SizedBox(height: 12),
              ...FakeDatabase.users.map((u) {
                final user = UserModel.fromJson(u as Map<String, dynamic>);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: user.profilePhoto != null ? NetworkImage(user.profilePhoto!) : null,
                        child: user.profilePhoto == null ? const Icon(Icons.person, size: 18) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullName, style: AppTextStyles.titleSmall),
                            Text(user.email, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
                          ],
                        ),
                      ),
                      StatusBadge(
                        text: user.role.toUpperCase(),
                        type: user.role == 'admin'
                            ? BadgeType.error
                            : (user.role == 'instructor' ? BadgeType.warning : BadgeType.info),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, String value, String subtitle, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w800)),
          Text(subtitle, style: AppTextStyles.labelSmall.copyWith(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
