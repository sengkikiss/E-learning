import '../../entities/course.dart';
import '../../entities/category.dart';
import '../../repositories/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repository;
  GetCoursesUseCase(this.repository);

  Future<List<Course>> execute() => repository.getCourses();
}

class GetCourseDetailUseCase {
  final CourseRepository repository;
  GetCourseDetailUseCase(this.repository);

  Future<Course> execute(String id) => repository.getCourseById(id);
}

class SearchCoursesUseCase {
  final CourseRepository repository;
  SearchCoursesUseCase(this.repository);

  Future<List<Course>> execute(String query, {String? categoryId, String? level, String? sortBy}) {
    return repository.searchCourses(query, categoryId: categoryId, level: level, sortBy: sortBy);
  }
}

class GetCoursesByCategoryUseCase {
  final CourseRepository repository;
  GetCoursesByCategoryUseCase(this.repository);

  Future<List<Course>> execute(String categoryId) => repository.getCoursesByCategory(categoryId);
}

class GetRecommendedCoursesUseCase {
  final CourseRepository repository;
  GetRecommendedCoursesUseCase(this.repository);

  Future<List<Course>> execute() => repository.getRecommendedCourses();
}

class GetPopularCoursesUseCase {
  final CourseRepository repository;
  GetPopularCoursesUseCase(this.repository);

  Future<List<Course>> execute() => repository.getPopularCourses();
}

class ToggleFavoriteUseCase {
  final CourseRepository repository;
  ToggleFavoriteUseCase(this.repository);

  Future<void> execute(String courseId, bool isCurrentlySaved) async {
    if (isCurrentlySaved) {
      await repository.removeSavedCourse(courseId);
    } else {
      await repository.saveCourse(courseId);
    }
  }
}

class GetSavedCoursesUseCase {
  final CourseRepository repository;
  GetSavedCoursesUseCase(this.repository);

  Future<List<Course>> execute() => repository.getSavedCourses();
}

class GetCategoriesUseCase {
  final CourseRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<List<Category>> execute() => repository.getCategories();
}
