import '../lesson_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/lesson/lesson_model.dart';

class RemoteLessonDataSource implements LessonDataSource {
  final ApiClient _client;

  RemoteLessonDataSource(this._client);

  @override
  Future<List<LessonModel>> getLessonsByCourse(String courseId) async {
    final path = ApiConstants.lessonsByCourse.replaceAll('{courseId}', courseId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<LessonModel> getLessonById(String lessonId) async {
    final path = ApiConstants.lessonDetail.replaceAll('{id}', lessonId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return LessonModel.fromJson(apiResponse.data!);
  }

  @override
  Future<void> markLessonCompleted(String lessonId, String courseId) async {
    final path = ApiConstants.completeLesson.replaceAll('{id}', lessonId);
    await _client.post(path);
  }
}
