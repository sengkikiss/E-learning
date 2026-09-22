import '../entities/course_progress.dart';
import '../entities/learning_activity.dart';
import '../entities/certificate.dart';

abstract class ProgressRepository {
  Future<CourseProgress> getCourseProgress(String courseId, String studentId);
  Future<List<LearningActivity>> getLearningHistory(String studentId);
  Future<List<Certificate>> getCertificates(String studentId);
  Future<Certificate?> getCertificateById(String certificateId);
}
