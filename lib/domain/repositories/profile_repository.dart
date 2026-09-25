import '../entities/student.dart';

abstract class ProfileRepository {
  Future<Student> getStudentProfile(String studentId);
  Future<Student> updateProfile({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? dateOfBirth,
    String? profilePhoto,
  });
}
