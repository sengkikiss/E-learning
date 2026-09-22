import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/lesson.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/progress/presentation/providers/progress_providers.dart';

final lessonsProvider = FutureProvider.family<List<Lesson>, String>((ref, courseId) async {
  return ref.watch(getLessonsUseCaseProvider).execute(courseId);
});

final lessonDetailProvider = FutureProvider.family<Lesson, String>((ref, lessonId) async {
  return ref.watch(getLessonDetailUseCaseProvider).execute(lessonId);
});

class LessonCompletionNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  LessonCompletionNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> markCompleted(String lessonId, String courseId) async {
    state = const AsyncValue.loading();
    try {
      await _ref.read(markLessonCompletedUseCaseProvider).execute(lessonId, courseId);
      _ref.invalidate(lessonsProvider(courseId));
      _ref.invalidate(lessonDetailProvider(lessonId));
      _ref.invalidate(courseProgressProvider(courseId));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final lessonCompletionNotifierProvider = StateNotifierProvider<LessonCompletionNotifier, AsyncValue<void>>((ref) {
  return LessonCompletionNotifier(ref);
});
