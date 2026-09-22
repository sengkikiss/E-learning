import '../course_datasource.dart';
import '../fake_api/fake_api_client.dart';
import '../fake_api/fake_database.dart';
import 'package:e_learning/data/models/course/course_model.dart';
import 'package:e_learning/data/models/category/category_model.dart';
import 'package:e_learning/core/error/app_exception.dart';

class FakeCourseDataSource implements CourseDataSource {
  final FakeApiClient _client;
  final Set<String> _savedCourseIds = {'crs_01', 'crs_04', 'crs_10'};

  FakeCourseDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await _client.request<List<CourseModel>>(
      dataFetcher: () => FakeDatabase.courses.map((c) {
        return CourseModel.fromJson({
          ...c.toJson(),
          'isSaved': _savedCourseIds.contains(c.id),
        });
      }).toList(),
      successMessage: 'Courses retrieved successfully',
    );
    return response.data ?? [];
  }

  @override
  Future<CourseModel> getCourseById(String courseId) async {
    final response = await _client.request<CourseModel>(
      dataFetcher: () {
        final match = FakeDatabase.courses.cast<CourseModel?>().firstWhere(
              (c) => c?.id == courseId,
              orElse: () => null,
            );
        if (match == null) {
          throw NotFoundException('Course with id "$courseId" not found');
        }
        return CourseModel.fromJson({
          ...match.toJson(),
          'isSaved': _savedCourseIds.contains(match.id),
        });
      },
      successMessage: 'Course details retrieved successfully',
    );
    return response.data!;
  }

  @override
  Future<List<CourseModel>> searchCourses(
    String query, {
    String? categoryId,
    String? level,
    String? sortBy,
  }) async {
    final response = await _client.request<List<CourseModel>>(
      dataFetcher: () {
        var results = FakeDatabase.courses.where((c) {
          final matchesQuery = query.isEmpty ||
              c.title.toLowerCase().contains(query.toLowerCase()) ||
              c.description.toLowerCase().contains(query.toLowerCase()) ||
              c.categoryName.toLowerCase().contains(query.toLowerCase());

          final matchesCategory = categoryId == null || categoryId.isEmpty || c.categoryId == categoryId;
          final matchesLevel = level == null || level.isEmpty || c.level.toLowerCase() == level.toLowerCase();

          return matchesQuery && matchesCategory && matchesLevel;
        }).toList();

        if (sortBy != null) {
          if (sortBy == 'highestRated') {
            results.sort((a, b) => b.rating.compareTo(a.rating));
          } else if (sortBy == 'mostPopular') {
            results.sort((a, b) => b.enrollmentCount.compareTo(a.enrollmentCount));
          } else if (sortBy == 'priceLowToHigh') {
            results.sort((a, b) => a.price.compareTo(b.price));
          }
        }

        return results.map((c) {
          return CourseModel.fromJson({
            ...c.toJson(),
            'isSaved': _savedCourseIds.contains(c.id),
          });
        }).toList();
      },
    );
    return response.data ?? [];
  }

  @override
  Future<List<CourseModel>> getCoursesByCategory(String categoryId) async {
    return searchCourses('', categoryId: categoryId);
  }

  @override
  Future<List<CourseModel>> getRecommendedCourses() async {
    final response = await _client.request<List<CourseModel>>(
      dataFetcher: () {
        return FakeDatabase.courses
            .where((c) => c.rating >= 4.8)
            .take(6)
            .map((c) => CourseModel.fromJson({...c.toJson(), 'isSaved': _savedCourseIds.contains(c.id)}))
            .toList();
      },
    );
    return response.data ?? [];
  }

  @override
  Future<List<CourseModel>> getPopularCourses() async {
    final response = await _client.request<List<CourseModel>>(
      dataFetcher: () {
        final sorted = List<CourseModel>.from(FakeDatabase.courses)
          ..sort((a, b) => b.enrollmentCount.compareTo(a.enrollmentCount));
        return sorted
            .take(6)
            .map((c) => CourseModel.fromJson({...c.toJson(), 'isSaved': _savedCourseIds.contains(c.id)}))
            .toList();
      },
    );
    return response.data ?? [];
  }

  @override
  Future<void> saveCourse(String courseId) async {
    await _client.request<bool>(
      dataFetcher: () {
        _savedCourseIds.add(courseId);
        return true;
      },
      successMessage: 'Course bookmarked successfully',
    );
  }

  @override
  Future<void> removeSavedCourse(String courseId) async {
    await _client.request<bool>(
      dataFetcher: () {
        _savedCourseIds.remove(courseId);
        return true;
      },
      successMessage: 'Course removed from bookmarks',
    );
  }

  @override
  Future<List<CourseModel>> getSavedCourses() async {
    final response = await _client.request<List<CourseModel>>(
      dataFetcher: () {
        return FakeDatabase.courses
            .where((c) => _savedCourseIds.contains(c.id))
            .map((c) => CourseModel.fromJson({...c.toJson(), 'isSaved': true}))
            .toList();
      },
    );
    return response.data ?? [];
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.request<List<CategoryModel>>(
      dataFetcher: () => List<CategoryModel>.from(FakeDatabase.categories),
      successMessage: 'Categories retrieved successfully',
    );
    return response.data ?? [];
  }
}
