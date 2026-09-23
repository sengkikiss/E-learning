import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/assignment_providers.dart';

class AssignmentSubmissionScreen extends ConsumerStatefulWidget {
  final String assignmentId;

  const AssignmentSubmissionScreen({super.key, required this.assignmentId});

  @override
  ConsumerState<AssignmentSubmissionScreen> createState() => _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState extends ConsumerState<AssignmentSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textSubmissionController = TextEditingController();
  final _commentController = TextEditingController();
  String? _selectedFileName;
  int _selectedFileSize = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final submission = ref.read(submissionProvider(widget.assignmentId)).valueOrNull;
    if (submission != null) {
      _textSubmissionController.text = submission.textSubmission;
      _commentController.text = submission.comment ?? '';
      _selectedFileName = submission.submissionFile;
    }
  }

  @override
  void dispose() {
    _textSubmissionController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _simulatePickFile() {
    setState(() {
      _selectedFileName = 'assignment_solution_${DateTime.now().millisecondsSinceEpoch}.zip';
      _selectedFileSize = 2450000; // ~2.4 MB
    });
    AppSnackbar.showSuccess(context, 'File "$_selectedFileName" attached.');
  }

  Future<void> _handleSubmit() async {
    if (_textSubmissionController.text.trim().isEmpty && _selectedFileName == null) {
      AppSnackbar.showError(context, 'Please provide text submission or attach a file.');
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(assignmentSubmissionNotifierProvider.notifier).submit(
          assignmentId: widget.assignmentId,
          textSubmission: _textSubmissionController.text.trim(),
          submissionFile: _selectedFileName,
          comment: _commentController.text.trim(),
        );
    setState(() => _isLoading = false);

    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Assignment submitted successfully!');
      context.pop();
    } else if (mounted) {
      AppSnackbar.showError(context, 'Submission failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Submit Assignment')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Submission 📝',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Provide text responses, GitHub links, and attach supporting zip or PDF documents.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),

                // Text Input
                AppTextField(
                  controller: _textSubmissionController,
                  label: 'Text Submission & Repository URL',
                  hintText: 'Paste your solution summary, GitHub repo URL, or response here...',
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // File Upload Box
                const Text('Upload Solution Archive or Document', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _simulatePickFile,
                  borderRadius: AppRadius.mdRadius,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: AppRadius.mdRadius,
                      border: Border.all(
                        color: _selectedFileName != null ? AppColors.primary : AppColors.borderLight,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedFileName != null ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
                          size: 40,
                          color: _selectedFileName != null ? AppColors.success : AppColors.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedFileName ?? 'Tap to browse files (.zip, .pdf, .docx)',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _selectedFileName != null ? AppColors.primary : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (_selectedFileSize > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            FileUtils.formatBytes(_selectedFileSize),
                            style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text('Max file size: 10MB', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMutedLight)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Additional Comments
                AppTextField(
                  controller: _commentController,
                  label: 'Comments for Instructor (Optional)',
                  hintText: 'Any special notes for review...',
                  maxLines: 2,
                ),
                const SizedBox(height: 32),

                AppButton(
                  text: 'Submit Solution',
                  icon: Icons.send_rounded,
                  isLoading: _isLoading,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
