import '../enrollment_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/enrollment/enrollment_model.dart';
import 'package:e_learning/data/models/course/course_model.dart';

class FakeEnrollmentDataSource implements EnrollmentDataSource {
  final FakeApiClient _client;

  FakeEnrollmentDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<EnrollmentModel> enrollInCourse(String courseId, String studentId) async {
    final response = await _client.request<EnrollmentModel>(
      dataFetcher: () {
        final existing = FakeDatabase.enrollments.cast<EnrollmentModel?>().firstWhere(
              (e) => e?.courseId == courseId && e?.studentId == studentId,
              orElse: () => null,
            );

        if (existing != null) {
          return existing;
        }

        final newEnrollment = EnrollmentModel(
          id: 'enr_${DateTime.now().millisecondsSinceEpoch}',
          studentId: studentId,
          courseId: courseId,
          enrollmentDate: DateTime.now().toIso8601String(),
          status: 'active',
          progress: 0.0,
        );

        FakeDatabase.enrollments.add(newEnrollment);
        return newEnrollment;
      },
      successMessage: 'Successfully enrolled in course!',
    );
    return response.data!;
  }

  @override
  Future<List<CourseModel>> getEnrolledCourses(String studentId) async {
    final response = await _client.request<List<CourseModel>>(
      dataFetcher: () {
        final enrolledIds = FakeDatabase.enrollments
            .where((e) => e.studentId == studentId)
            .map((e) => e.courseId)
            .toSet();

        return FakeDatabase.courses.where((c) => enrolledIds.contains(c.id)).toList();
      },
      successMessage: 'Enrolled courses retrieved',
    );
    return response.data ?? [];
  }

  @override
  Future<bool> isEnrolled(String courseId, String studentId) async {
    final response = await _client.request<bool>(
      dataFetcher: () {
        return FakeDatabase.enrollments.any(
          (e) => e.courseId == courseId && e.studentId == studentId,
        );
      },
    );
    return response.data ?? false;
  }

  @override
  Future<EnrollmentModel?> getEnrollment(String courseId, String studentId) async {
    final response = await _client.request<EnrollmentModel?>(
      dataFetcher: () {
        return FakeDatabase.enrollments.cast<EnrollmentModel?>().firstWhere(
              (e) => e?.courseId == courseId && e?.studentId == studentId,
              orElse: () => null,
            );
      },
    );
    return response.data;
  }
}
