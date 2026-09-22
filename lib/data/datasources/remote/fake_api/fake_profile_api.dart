import '../profile_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/student/student_model.dart';

class FakeProfileDataSource implements ProfileDataSource {
  final FakeApiClient _client;

  FakeProfileDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<StudentModel> getStudentProfile(String studentId) async {
    final response = await _client.request<StudentModel>(
      dataFetcher: () {
        final match = FakeDatabase.students.cast<StudentModel?>().firstWhere(
              (s) => s?.id == studentId,
              orElse: () => FakeDatabase.students.first,
            );
        return match!;
      },
      successMessage: 'Student profile retrieved',
    );
    return response.data!;
  }

  @override
  Future<StudentModel> updateProfile({
    required String studentId,
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? profilePhoto,
  }) async {
    final response = await _client.request<StudentModel>(
      dataFetcher: () {
        final index = FakeDatabase.students.indexWhere((s) => s.id == studentId);
        final current = index != -1 ? FakeDatabase.students[index] : FakeDatabase.students.first;

        final updated = StudentModel(
          id: current.id,
          studentId: current.studentId,
          fullName: fullName,
          gender: current.gender,
          dateOfBirth: current.dateOfBirth,
          phoneNumber: phoneNumber,
          email: current.email,
          profilePhoto: profilePhoto ?? current.profilePhoto,
          educationLevel: educationLevel,
          accountStatus: current.accountStatus,
        );

        if (index != -1) {
          FakeDatabase.students[index] = updated;
        }

        // Also update corresponding user object if exists
        final userIndex = FakeDatabase.users.indexWhere((u) => u.id == studentId);
        if (userIndex != -1) {
          final u = FakeDatabase.users[userIndex];
          FakeDatabase.users[userIndex] = u.copyWith(fullName: fullName);
        }

        return updated;
      },
      successMessage: 'Profile updated successfully',
    );
    return response.data!;
  }
}
