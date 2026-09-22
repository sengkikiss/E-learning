import '../quiz_datasource.dart';
import 'package:e_learning/core/constants/api_constants.dart';
import 'package:e_learning/core/network/api_client.dart';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/data/models/quiz/quiz_model.dart';

class RemoteQuizDataSource implements QuizDataSource {
  final ApiClient _client;

  RemoteQuizDataSource(this._client);

  @override
  Future<QuizModel> getQuizByLesson(String lessonId) async {
    final path = ApiConstants.quizByLesson.replaceAll('{lessonId}', lessonId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return QuizModel.fromJson(apiResponse.data!);
  }

  @override
  Future<QuizModel> getQuizById(String quizId) async {
    final path = ApiConstants.quizDetail.replaceAll('{id}', quizId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return QuizModel.fromJson(apiResponse.data!);
  }

  @override
  Future<QuizAttemptModel> submitQuizAttempt({
    required String quizId,
    required String studentId,
    required Map<int, int> selectedAnswers,
  }) async {
    final path = ApiConstants.submitQuiz.replaceAll('{id}', quizId);
    final response = await _client.post(
      path,
      data: {
        'studentId': studentId,
        'selectedAnswers': selectedAnswers.map((k, v) => MapEntry(k.toString(), v)),
      },
    );
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as Map<String, dynamic>,
    );
    return QuizAttemptModel.fromJson(apiResponse.data!);
  }

  @override
  Future<List<QuizAttemptModel>> getQuizAttempts(String quizId) async {
    final path = ApiConstants.quizAttempts.replaceAll('{id}', quizId);
    final response = await _client.get(path);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json as List<dynamic>,
    );
    return (apiResponse.data ?? []).map((e) => QuizAttemptModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
