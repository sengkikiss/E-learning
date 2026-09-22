import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/compact_course_card.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../courses/presentation/providers/course_providers.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = '';
  String? _selectedLevel;
  String? _selectedSortBy;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) {
        String? tempLevel = _selectedLevel;
        String? tempSort = _selectedSortBy;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: AppRadius.fullRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Filter Courses', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 16),
                  Text('Experience Level', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Beginner', 'Intermediate', 'Advanced', 'All Levels'].map((level) {
                      final isSel = tempLevel == level;
                      return ChoiceChip(
                        label: Text(level),
                        selected: isSel,
                        onSelected: (selected) {
                          setModalState(() {
                            tempLevel = selected ? level : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('Sort By', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      {'label': 'Highest Rated', 'val': 'highestRated'},
                      {'label': 'Most Popular', 'val': 'mostPopular'},
                      {'label': 'Price: Low to High', 'val': 'priceLowToHigh'},
                    ].map((sort) {
                      final isSel = tempSort == sort['val'];
                      return ChoiceChip(
                        label: Text(sort['label']!),
                        selected: isSel,
                        onSelected: (selected) {
                          setModalState(() {
                            tempSort = selected ? sort['val'] : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempLevel = null;
                              tempSort = null;
                            });
                            setState(() {
                              _selectedLevel = null;
                              _selectedSortBy = null;
                            });
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: 'Apply Filters',
                          onPressed: () {
                            setState(() {
                              _selectedLevel = tempLevel;
                              _selectedSortBy = tempSort;
                            });
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(categoriesProvider);

    final searchParams = CourseSearchParams(
      query: _searchController.text.trim(),
      categoryId: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
      level: _selectedLevel,
      sortBy: _selectedSortBy,
    );

    final coursesAsync = ref.watch(searchCoursesProvider(searchParams));

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Explore Courses'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 8),
              child: AppSearchBar(
                controller: _searchController,
                hintText: 'Search 20+ expert tech courses...',
                onChanged: (_) => setState(() {}),
                onFilterPressed: _showFilterModal,
              ),
            ),

            // Horizontal Category Selector
            categoriesAsync.when(
              data: (cats) => SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _selectedCategoryId.isEmpty,
                        onSelected: (_) => setState(() => _selectedCategoryId = ''),
                      ),
                    ),
                    ...cats.map((cat) {
                      final isSelected = _selectedCategoryId == cat.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryId = selected ? cat.id : '';
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              loading: () => const SizedBox(height: 42),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            // Course Results
            Expanded(
              child: coursesAsync.when(
                data: (courses) {
                  if (courses.isEmpty) {
                    return EmptyView(
                      title: 'No courses found',
                      message: 'Try modifying your search keywords or clearing the active filters.',
                      action: AppButton(
                        text: 'Clear Filters',
                        width: 140,
                        height: 40,
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _selectedCategoryId = '';
                            _selectedLevel = null;
                            _selectedSortBy = null;
                          });
                        },
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => ref.invalidate(searchCoursesProvider(searchParams)),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 8),
                      itemCount: courses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return CompactCourseCard(
                          course: course,
                          onTap: () => context.push('/courses/${course.id}'),
                          onBookmarkToggle: () {
                            ref.read(favoriteCourseNotifierProvider.notifier).toggle(course.id, course.isSaved);
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const LoadingView(message: 'Searching courses...'),
                error: (e, _) => ErrorView(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(searchCoursesProvider(searchParams)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
