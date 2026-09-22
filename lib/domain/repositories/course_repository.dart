import '../entities/course.dart';
import '../entities/category.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourseById(String courseId);
  Future<List<Course>> searchCourses(String query, {String? categoryId, String? level, String? sortBy});
  Future<List<Course>> getCoursesByCategory(String categoryId);
  Future<List<Course>> getRecommendedCourses();
  Future<List<Course>> getPopularCourses();
  Future<void> saveCourse(String courseId);
  Future<void> removeSavedCourse(String courseId);
  Future<List<Course>> getSavedCourses();
  Future<List<Category>> getCategories();
}
