import '../../entities/course_progress.dart';
import '../../entities/learning_activity.dart';
import '../../entities/certificate.dart';
import '../../repositories/progress_repository.dart';

class GetCourseProgressUseCase {
  final ProgressRepository repository;
  GetCourseProgressUseCase(this.repository);

  Future<CourseProgress> execute(String courseId, String studentId) {
    return repository.getCourseProgress(courseId, studentId);
  }
}

class GetLearningHistoryUseCase {
  final ProgressRepository repository;
  GetLearningHistoryUseCase(this.repository);

  Future<List<LearningActivity>> execute(String studentId) {
    return repository.getLearningHistory(studentId);
  }
}

class GetCertificatesUseCase {
  final ProgressRepository repository;
  GetCertificatesUseCase(this.repository);

  Future<List<Certificate>> execute(String studentId) {
    return repository.getCertificates(studentId);
  }
}

class GetCertificateDetailUseCase {
  final ProgressRepository repository;
  GetCertificateDetailUseCase(this.repository);

  Future<Certificate?> execute(String certificateId) {
    return repository.getCertificateById(certificateId);
  }
}
