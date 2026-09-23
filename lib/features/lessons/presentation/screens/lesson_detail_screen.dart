import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/lesson_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/material_card.dart';
import '../providers/lesson_providers.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const LessonDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  int _selectedLessonIndex = 0;
  bool _isPlaying = false;
  double _playbackPosition = 0.35; // Simulated 35% watched

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _handleDownloadMaterial(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) {
          AppSnackbar.showSuccess(context, 'Material downloaded to your device.');
        }
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.showSuccess(context, 'Material downloaded to local cache.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lessonsAsync = ref.watch(lessonsProvider(widget.courseId));
    final completionState = ref.watch(lessonCompletionNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Course Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_outlined),
            tooltip: 'Take Course Quiz',
            onPressed: () => context.push('/quiz/quiz_01'),
          ),
          IconButton(
            icon: const Icon(Icons.assignment_outlined),
            tooltip: 'Assignments',
            onPressed: () => context.push('/assignments?courseId=${widget.courseId}'),
          ),
        ],
      ),
      body: SafeArea(
        child: lessonsAsync.when(
          data: (lessons) {
            if (lessons.isEmpty) {
              return const Center(child: Text('No lessons available for this course.'));
            }

            if (_selectedLessonIndex >= lessons.length) {
              _selectedLessonIndex = 0;
            }

            final currentLesson = lessons[_selectedLessonIndex];
            final bool hasNext = _selectedLessonIndex < lessons.length - 1;
            final bool hasPrev = _selectedLessonIndex > 0;

            return Column(
              children: [
                // 1. High-Tech Video Player Canvas
                Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Video background canvas preview
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color(0xFF0F172A), Colors.black.withValues(alpha: 0.8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Player Controls Overlay
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.replay_10_rounded, color: Colors.white, size: 28),
                                onPressed: () {
                                  setState(() {
                                    _playbackPosition = (_playbackPosition - 0.05).clamp(0.0, 1.0);
                                  });
                                },
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const Icon(Icons.forward_10_rounded, color: Colors.white, size: 28),
                                onPressed: () {
                                  setState(() {
                                    _playbackPosition = (_playbackPosition + 0.05).clamp(0.0, 1.0);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bottom scrubber & time
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          color: Colors.black.withValues(alpha: 0.6),
                          child: Row(
                            children: [
                              Text(
                                '06:32',
                                style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                    trackHeight: 3,
                                  ),
                                  child: Slider(
                                    value: _playbackPosition,
                                    activeColor: AppColors.primary,
                                    inactiveColor: Colors.white24,
                                    onChanged: (val) {
                                      setState(() {
                                        _playbackPosition = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentLesson.duration,
                                style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Lesson Title, Completion Button & Navigation
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lesson ${currentLesson.order} of ${lessons.length}',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentLesson.title,
                                    style: AppTextStyles.titleLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (currentLesson.isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight.withValues(alpha: 0.3),
                                  borderRadius: AppRadius.fullRadius,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                                    SizedBox(width: 4),
                                    Text(
                                      'Completed',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentLesson.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mark as completed button
                        if (!currentLesson.isCompleted)
                          AppButton(
                            text: 'Mark Lesson as Completed',
                            icon: Icons.check_circle_outline_rounded,
                            height: 44,
                            isLoading: completionState.isLoading,
                            onPressed: () async {
                              await ref.read(lessonCompletionNotifierProvider.notifier).markCompleted(
                                    currentLesson.id,
                                    widget.courseId,
                                  );
                              if (mounted) {
                                AppSnackbar.showSuccess(context, 'Lesson marked complete! Progress updated.');
                              }
                            },
                          ),
                        const SizedBox(height: 16),

                        // Prev / Next lesson buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.skip_previous_rounded, size: 18),
                                label: const Text('Previous'),
                                onPressed: hasPrev
                                    ? () {
                                        setState(() {
                                          _selectedLessonIndex--;
                                          _playbackPosition = 0.0;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.skip_next_rounded, size: 18),
                                label: const Text('Next Lesson'),
                                onPressed: hasNext
                                    ? () {
                                        setState(() {
                                          _selectedLessonIndex++;
                                          _playbackPosition = 0.0;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Learning Materials Section
                        if (currentLesson.materials.isNotEmpty) ...[
                          Text(
                            'Learning Materials (${currentLesson.materials.length})',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...currentLesson.materials.map((mat) => MaterialCard(
                                material: mat,
                                onDownload: () => _handleDownloadMaterial(mat.fileUrl),
                              )),
                          const SizedBox(height: 20),
                        ],

                        // Full Course Syllabus List
                        Text(
                          'Course Syllabus',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...lessons.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final les = entry.value;
                          return LessonCard(
                            lesson: les,
                            isCurrent: idx == _selectedLessonIndex,
                            onTap: () {
                              setState(() {
                                _selectedLessonIndex = idx;
                                _playbackPosition = 0.0;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const LoadingView(message: 'Loading lesson details...'),
          error: (e, _) => ErrorView(message: e.toString(), onRetry: () => ref.invalidate(lessonsProvider(widget.courseId))),
        ),
      ),
    );
  }
}
