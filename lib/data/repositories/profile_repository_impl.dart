import '../../domain/entities/student.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Student> getStudentProfile(String studentId) async {
    final model = await _dataSource.getStudentProfile(studentId);
    return model.toEntity();
  }

  @override
  Future<Student> updateProfile({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? dateOfBirth,
    String? profilePhoto,
  }) async {
    final model = await _dataSource.updateProfile(
      studentId: studentId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      educationLevel: educationLevel,
      dateOfBirth: dateOfBirth,
      profilePhoto: profilePhoto,
    );
    return model.toEntity();
  }
}
