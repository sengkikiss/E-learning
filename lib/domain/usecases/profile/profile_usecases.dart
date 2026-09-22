import '../../entities/student.dart';
import '../../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<Student> execute(String studentId) {
    return repository.getStudentProfile(studentId);
  }
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<Student> execute({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? profilePhoto,
  }) {
    return repository.updateProfile(
      studentId: studentId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      educationLevel: educationLevel,
      profilePhoto: profilePhoto,
    );
  }
}
