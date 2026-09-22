import '../../domain/entities/enrollment.dart';
import '../../domain/entities/course.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/remote/enrollment_datasource.dart';

class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentDataSource _dataSource;

  EnrollmentRepositoryImpl(this._dataSource);

  @override
  Future<Enrollment> enrollInCourse(String courseId, String studentId) async {
    final model = await _dataSource.enrollInCourse(courseId, studentId);
    return model.toEntity();
  }

  @override
  Future<List<Course>> getEnrolledCourses(String studentId) async {
    final models = await _dataSource.getEnrolledCourses(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> isEnrolled(String courseId, String studentId) {
    return _dataSource.isEnrolled(courseId, studentId);
  }

  @override
  Future<Enrollment?> getEnrollment(String courseId, String studentId) async {
    final model = await _dataSource.getEnrollment(courseId, studentId);
    return model?.toEntity();
  }
}
