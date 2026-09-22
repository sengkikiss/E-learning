import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(changePasswordUseCaseProvider).execute(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
      setState(() => _isLoading = false);

      if (mounted) {
        AppSnackbar.showSuccess(context, 'Password changed successfully!');
        context.pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to update password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Change Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hintText: 'Enter your existing password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) => Validators.password(v, 6),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hintText: 'At least 6 characters',
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_rounded,
                  validator: (v) => Validators.password(v, 6),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hintText: 'Repeat new password',
                  isPassword: true,
                  prefixIcon: Icons.lock_reset_rounded,
                  validator: (v) => Validators.confirmPassword(v, _newPasswordController.text),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Update Password',
                  isLoading: _isLoading,
                  icon: Icons.check_rounded,
                  onPressed: _handleChangePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
