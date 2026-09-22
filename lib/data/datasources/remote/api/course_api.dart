import '../course_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/course/course_model.dart';
import 'package:e_learning/data/models/category/category_model.dart';

class RemoteCourseDataSource implements CourseDataSource {
  final ApiClient _client;

  RemoteCourseDataSource(this._client);

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await _client.get(ApiConstants.courses);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<CourseModel> getCourseById(String courseId) async {
    final path = ApiConstants.courseDetail.replaceAll('{id}', courseId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return CourseModel.fromJson(apiResponse.data!);
  }

  @override
  Future<List<CourseModel>> searchCourses(
    String query, {
    String? categoryId,
    String? level,
    String? sortBy,
  }) async {
    final response = await _client.get(
      ApiConstants.searchCourses,
      queryParameters: {
        'q': query,
        if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
        if (level != null && level.isNotEmpty) 'level': level,
        if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
      },
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CourseModel>> getCoursesByCategory(String categoryId) async {
    final path = ApiConstants.coursesByCategory.replaceAll('{id}', categoryId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CourseModel>> getRecommendedCourses() async {
    final response = await _client.get(ApiConstants.recommendedCourses);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CourseModel>> getPopularCourses() async {
    final response = await _client.get(ApiConstants.popularCourses);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveCourse(String courseId) async {
    await _client.post('${ApiConstants.favorites}/$courseId');
  }

  @override
  Future<void> removeSavedCourse(String courseId) async {
    await _client.delete('${ApiConstants.favorites}/$courseId');
  }

  @override
  Future<List<CourseModel>> getSavedCourses() async {
    final response = await _client.get(ApiConstants.favorites);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.get(ApiConstants.categories);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
