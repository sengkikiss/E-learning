import '../../entities/lesson.dart';
import '../../repositories/lesson_repository.dart';

class GetLessonsUseCase {
  final LessonRepository repository;
  GetLessonsUseCase(this.repository);

  Future<List<Lesson>> execute(String courseId) => repository.getLessonsByCourse(courseId);
}

class GetLessonDetailUseCase {
  final LessonRepository repository;
  GetLessonDetailUseCase(this.repository);

  Future<Lesson> execute(String lessonId) => repository.getLessonById(lessonId);
}

class MarkLessonCompletedUseCase {
  final LessonRepository repository;
  MarkLessonCompletedUseCase(this.repository);

  Future<void> execute(String lessonId, String courseId) =>
      repository.markLessonCompleted(lessonId, courseId);
}
