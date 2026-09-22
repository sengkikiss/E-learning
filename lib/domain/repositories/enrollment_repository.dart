import '../entities/enrollment.dart';
import '../entities/course.dart';

abstract class EnrollmentRepository {
  Future<Enrollment> enrollInCourse(String courseId, String studentId);
  Future<List<Course>> getEnrolledCourses(String studentId);
  Future<bool> isEnrolled(String courseId, String studentId);
  Future<Enrollment?> getEnrollment(String courseId, String studentId);
}
