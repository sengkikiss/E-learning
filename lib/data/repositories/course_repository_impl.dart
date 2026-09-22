import '../../domain/entities/course.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/remote/course_datasource.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseDataSource _dataSource;

  CourseRepositoryImpl(this._dataSource);

  @override
  Future<List<Course>> getCourses() async {
    final models = await _dataSource.getCourses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Course> getCourseById(String courseId) async {
    final model = await _dataSource.getCourseById(courseId);
    return model.toEntity();
  }

  @override
  Future<List<Course>> searchCourses(
    String query, {
    String? categoryId,
    String? level,
    String? sortBy,
  }) async {
    final models = await _dataSource.searchCourses(
      query,
      categoryId: categoryId,
      level: level,
      sortBy: sortBy,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Course>> getCoursesByCategory(String categoryId) async {
    final models = await _dataSource.getCoursesByCategory(categoryId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Course>> getRecommendedCourses() async {
    final models = await _dataSource.getRecommendedCourses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Course>> getPopularCourses() async {
    final models = await _dataSource.getPopularCourses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveCourse(String courseId) => _dataSource.saveCourse(courseId);

  @override
  Future<void> removeSavedCourse(String courseId) => _dataSource.removeSavedCourse(courseId);

  @override
  Future<List<Course>> getSavedCourses() async {
    final models = await _dataSource.getSavedCourses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Category>> getCategories() async {
    final models = await _dataSource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }
}
