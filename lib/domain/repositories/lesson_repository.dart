import '../entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessonsByCourse(String courseId);
  Future<Lesson> getLessonById(String lessonId);
  Future<void> markLessonCompleted(String lessonId, String courseId);
}
