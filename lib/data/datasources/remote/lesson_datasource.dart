import '../../models/lesson/lesson_model.dart';

abstract class LessonDataSource {
  Future<List<LessonModel>> getLessonsByCourse(String courseId);
  Future<LessonModel> getLessonById(String lessonId);
  Future<void> markLessonCompleted(String lessonId, String courseId);
}
