import '../../models/enrollment/enrollment_model.dart';
import '../../models/course/course_model.dart';

abstract class EnrollmentDataSource {
  Future<EnrollmentModel> enrollInCourse(String courseId, String studentId);
  Future<List<CourseModel>> getEnrolledCourses(String studentId);
  Future<bool> isEnrolled(String courseId, String studentId);
  Future<EnrollmentModel?> getEnrollment(String courseId, String studentId);
}
