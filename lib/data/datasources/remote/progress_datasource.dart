import '../../models/progress/progress_model.dart';
import '../../models/activity/activity_model.dart';
import '../../models/certificate/certificate_model.dart';

abstract class ProgressDataSource {
  Future<CourseProgressModel> getCourseProgress(String courseId, String studentId);
  Future<List<LearningActivityModel>> getLearningHistory(String studentId);
  Future<List<CertificateModel>> getCertificates(String studentId);
  Future<CertificateModel?> getCertificateById(String certificateId);
}
