import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/course.dart';
import '../../../../domain/entities/category.dart';
import '../../../../core/di/dependency_injection.dart';

final coursesProvider = FutureProvider<List<Course>>((ref) async {
  return ref.watch(getCoursesUseCaseProvider).execute();
});

final popularCoursesProvider = FutureProvider<List<Course>>((ref) async {
  return ref.watch(getPopularCoursesUseCaseProvider).execute();
});

final recommendedCoursesProvider = FutureProvider<List<Course>>((ref) async {
  return ref.watch(getRecommendedCoursesUseCaseProvider).execute();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.watch(getCategoriesUseCaseProvider).execute();
});

final courseDetailProvider = FutureProvider.family<Course, String>((ref, courseId) async {
  return ref.watch(getCourseDetailUseCaseProvider).execute(courseId);
});

final coursesByCategoryProvider = FutureProvider.family<List<Course>, String>((ref, categoryId) async {
  return ref.watch(getCoursesByCategoryUseCaseProvider).execute(categoryId);
});

final savedCoursesProvider = FutureProvider<List<Course>>((ref) async {
  return ref.watch(getSavedCoursesUseCaseProvider).execute();
});

class CourseSearchParams {
  final String query;
  final String? categoryId;
  final String? level;
  final String? sortBy;

  const CourseSearchParams({
    this.query = '',
    this.categoryId,
    this.level,
    this.sortBy,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseSearchParams &&
          query == other.query &&
          categoryId == other.categoryId &&
          level == other.level &&
          sortBy == other.sortBy;

  @override
  int get hashCode => Object.hash(query, categoryId, level, sortBy);
}

final searchCoursesProvider = FutureProvider.family<List<Course>, CourseSearchParams>((ref, params) async {
  return ref.watch(searchCoursesUseCaseProvider).execute(
        params.query,
        categoryId: params.categoryId,
        level: params.level,
        sortBy: params.sortBy,
      );
});

class FavoriteCourseNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  FavoriteCourseNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> toggle(String courseId, bool currentSavedState) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(toggleFavoriteUseCaseProvider).execute(courseId, currentSavedState);
      _ref.invalidate(savedCoursesProvider);
      _ref.invalidate(coursesProvider);
      _ref.invalidate(popularCoursesProvider);
      _ref.invalidate(recommendedCoursesProvider);
      _ref.invalidate(courseDetailProvider(courseId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final favoriteCourseNotifierProvider = StateNotifierProvider<FavoriteCourseNotifier, AsyncValue<void>>((ref) {
  return FavoriteCourseNotifier(ref);
});
