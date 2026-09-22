import '../../domain/entities/lesson.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../datasources/remote/lesson_datasource.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonDataSource _dataSource;

  LessonRepositoryImpl(this._dataSource);

  @override
  Future<List<Lesson>> getLessonsByCourse(String courseId) async {
    final models = await _dataSource.getLessonsByCourse(courseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Lesson> getLessonById(String lessonId) async {
    final model = await _dataSource.getLessonById(lessonId);
    return model.toEntity();
  }

  @override
  Future<void> markLessonCompleted(String lessonId, String courseId) {
    return _dataSource.markLessonCompleted(lessonId, courseId);
  }
}
