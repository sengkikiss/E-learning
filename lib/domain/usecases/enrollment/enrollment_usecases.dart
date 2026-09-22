import '../../entities/enrollment.dart';
import '../../entities/course.dart';
import '../../repositories/enrollment_repository.dart';

class EnrollCourseUseCase {
  final EnrollmentRepository repository;
  EnrollCourseUseCase(this.repository);

  Future<Enrollment> execute(String courseId, String studentId) {
    return repository.enrollInCourse(courseId, studentId);
  }
}

class GetEnrolledCoursesUseCase {
  final EnrollmentRepository repository;
  GetEnrolledCoursesUseCase(this.repository);

  Future<List<Course>> execute(String studentId) {
    return repository.getEnrolledCourses(studentId);
  }
}

class CheckEnrollmentUseCase {
  final EnrollmentRepository repository;
  CheckEnrollmentUseCase(this.repository);

  Future<bool> execute(String courseId, String studentId) {
    return repository.isEnrolled(courseId, studentId);
  }
}
