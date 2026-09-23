import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/app_config.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Preferences', style: AppTextStyles.titleMedium),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    // Dark Mode Toggle
                    SwitchListTile(
                      secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                      title: const Text('Dark Mode'),
                      subtitle: Text(themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled'),
                      value: themeMode == ThemeMode.dark,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                    ),
                    Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),

                    // Language Selector
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                      title: const Text('Language'),
                      subtitle: Text(locale.languageCode == 'km' ? 'ភាសាខ្មែរ (Khmer)' : 'English'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChoiceChip(
                            label: const Text('EN'),
                            selected: locale.languageCode == 'en',
                            onSelected: (_) => ref.read(localeProvider.notifier).setLocale('en'),
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: const Text('ខ្មែរ'),
                            selected: locale.languageCode == 'km',
                            onSelected: (_) => ref.read(localeProvider.notifier).setLocale('km'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Account & Security', style: AppTextStyles.titleMedium),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: AppRadius.lgRadius,
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_reset_rounded, color: AppColors.primary),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(RouteNames.changePassword),
                    ),
                    Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ListTile(
                      leading: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                      title: const Text('Notification Center'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push(RouteNames.notifications),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Backend & Architecture Info Card
              const Text('API Configuration', style: AppTextStyles.titleMedium),
              const SizedBox(height: 10),
              Container(
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
                        const Icon(Icons.dns_rounded, color: AppColors.info, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Data Layer Source',
                          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConfig.useFakeApi
                          ? '• Active: Fake REST API (In-Memory Database + 800ms Latency)'
                          : '• Active: Spring Boot Remote API (http://localhost:8080)',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppConfig.useFakeApi ? AppColors.warning : AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ready for Spring Boot migration. Toggle AppConfig.useFakeApi = false in lib/app/config/app_config.dart to connect to your live Spring backend.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () => _handleLogout(context, ref),
                ),
              ),
              const SizedBox(height: 20),

              // App Version footer
              Center(
                child: Text(
                  '${AppConfig.appName} v${AppConfig.appVersion} • Clean Architecture',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
