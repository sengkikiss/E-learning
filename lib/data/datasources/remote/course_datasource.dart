import '../../models/course/course_model.dart';
import '../../models/category/category_model.dart';

abstract class CourseDataSource {
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseById(String courseId);
  Future<List<CourseModel>> searchCourses(String query, {String? categoryId, String? level, String? sortBy});
  Future<List<CourseModel>> getCoursesByCategory(String categoryId);
  Future<List<CourseModel>> getRecommendedCourses();
  Future<List<CourseModel>> getPopularCourses();
  Future<void> saveCourse(String courseId);
  Future<void> removeSavedCourse(String courseId);
  Future<List<CourseModel>> getSavedCourses();
  Future<List<CategoryModel>> getCategories();
}
