import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/profile_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _educationController;
  late TextEditingController _dobController;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).valueOrNull;
    _nameController = TextEditingController(text: profile?.fullName ?? 'Dara Somnang');
    _phoneController = TextEditingController(text: profile?.phoneNumber ?? '+855 12 345 678');
    _educationController = TextEditingController(text: profile?.educationLevel ?? 'Bachelor of Computer Science');

    final initialDob = profile?.dateOfBirth ?? '';
    _dobController = TextEditingController(text: initialDob);
    if (initialDob.isNotEmpty) {
      _selectedDate = DateTime.tryParse(initialDob);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _educationController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? DateTime(2000, 1, 1);
    final firstDate = DateTime(1920);
    final lastDate = now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(lastDate) ? lastDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Date of Birth',
      confirmText: 'Select',
      cancelText: 'Cancel',
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: AppColors.cardDark,
                    onSurface: AppColors.textPrimaryDark,
                  )
                : const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: AppColors.textPrimaryLight,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await ref.read(profileNotifierProvider.notifier).update(
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          educationLevel: _educationController.text.trim(),
          dateOfBirth: _dobController.text.trim(),
        );
    setState(() => _isLoading = false);

    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Profile updated successfully!');
      context.pop();
    } else if (mounted) {
      AppSnackbar.showError(context, 'Failed to update profile.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'Your legal name',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => Validators.requiredField(v, 'Full Name'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hintText: '+855 12 345 678',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: Validators.phoneNumber,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icons.cake_outlined,
                  readOnly: true,
                  onTap: _selectDateOfBirth,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_dobController.text.isNotEmpty)
                        IconButton(
                          tooltip: 'Clear birth date',
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedDate = null;
                              _dobController.clear();
                            });
                          },
                        ),
                      IconButton(
                        tooltip: 'Select birth date',
                        icon: const Icon(Icons.calendar_month_rounded, size: 20),
                        onPressed: _selectDateOfBirth,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _educationController,
                  label: 'Education Level',
                  hintText: 'e.g. Undergraduate, High School',
                  prefixIcon: Icons.school_outlined,
                  validator: (v) => Validators.requiredField(v, 'Education Level'),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Save Changes',
                  isLoading: _isLoading,
                  icon: Icons.check_rounded,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
