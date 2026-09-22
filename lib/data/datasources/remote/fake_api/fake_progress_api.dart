import '../progress_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/progress/progress_model.dart';
import 'package:e_learning/data/models/activity/activity_model.dart';
import 'package:e_learning/data/models/certificate/certificate_model.dart';
import 'package:e_learning/core/utils/progress_calculator.dart';

class FakeProgressDataSource implements ProgressDataSource {
  final FakeApiClient _client;

  FakeProgressDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<CourseProgressModel> getCourseProgress(String courseId, String studentId) async {
    final response = await _client.request<CourseProgressModel>(
      dataFetcher: () {
        final existing = FakeDatabase.progressList.cast<CourseProgressModel?>().firstWhere(
              (p) => p?.courseId == courseId,
              orElse: () => null,
            );

        if (existing != null) {
          return existing;
        }

        final courseLessons = FakeDatabase.lessons.where((l) => l.courseId == courseId).toList();
        final completedCount = courseLessons.where((l) => l.isCompleted).length;
        final totalCount = courseLessons.length;

        final percentage = ProgressCalculator.calculateCourseProgress(
          completedLessons: completedCount,
          totalLessons: totalCount,
        );

        return CourseProgressModel(
          courseId: courseId,
          completedLessons: completedCount,
          totalLessons: totalCount,
          completedQuizzes: 0,
          totalQuizzes: 0,
          submittedAssignments: 0,
          totalAssignments: 0,
          percentage: percentage,
          lastActivity: DateTime.now().toIso8601String(),
        );
      },
      successMessage: 'Course progress retrieved',
    );
    return response.data!;
  }

  @override
  Future<List<LearningActivityModel>> getLearningHistory(String studentId) async {
    final response = await _client.request<List<LearningActivityModel>>(
      dataFetcher: () {
        return FakeDatabase.learningActivities.where((a) => a.userId == studentId).toList();
      },
      successMessage: 'Learning history retrieved',
    );
    return response.data ?? [];
  }

  @override
  Future<List<CertificateModel>> getCertificates(String studentId) async {
    final response = await _client.request<List<CertificateModel>>(
      dataFetcher: () {
        return FakeDatabase.certificates.where((c) => c.studentId == studentId).toList();
      },
      successMessage: 'Certificates retrieved',
    );
    return response.data ?? [];
  }

  @override
  Future<CertificateModel?> getCertificateById(String certificateId) async {
    final response = await _client.request<CertificateModel?>(
      dataFetcher: () {
        return FakeDatabase.certificates.cast<CertificateModel?>().firstWhere(
              (c) => c?.id == certificateId,
              orElse: () => null,
            );
      },
      successMessage: 'Certificate details retrieved',
    );
    return response.data;
  }
}
