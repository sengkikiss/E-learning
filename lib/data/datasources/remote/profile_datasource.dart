import '../../models/student/student_model.dart';

abstract class ProfileDataSource {
  Future<StudentModel> getStudentProfile(String studentId);
  Future<StudentModel> updateProfile({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? profilePhoto,
  });
}
