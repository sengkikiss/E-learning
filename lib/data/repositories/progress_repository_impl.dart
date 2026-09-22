import '../../domain/entities/course_progress.dart';
import '../../domain/entities/learning_activity.dart';
import '../../domain/entities/certificate.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/remote/progress_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDataSource _dataSource;

  ProgressRepositoryImpl(this._dataSource);

  @override
  Future<CourseProgress> getCourseProgress(String courseId, String studentId) async {
    final model = await _dataSource.getCourseProgress(courseId, studentId);
    return model.toEntity();
  }

  @override
  Future<List<LearningActivity>> getLearningHistory(String studentId) async {
    final models = await _dataSource.getLearningHistory(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Certificate>> getCertificates(String studentId) async {
    final models = await _dataSource.getCertificates(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Certificate?> getCertificateById(String certificateId) async {
    final model = await _dataSource.getCertificateById(certificateId);
    return model?.toEntity();
  }
}
