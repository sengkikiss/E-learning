import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/student.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/auth/presentation/providers/auth_providers.dart';

final profileProvider = FutureProvider<Student>((ref) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(getProfileUseCaseProvider).execute(studentId);
});

class ProfileNotifier extends StateNotifier<AsyncValue<Student?>> {
  final Ref _ref;

  ProfileNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> update({
    required String fullName,
    required String phoneNumber,
    required String educationLevel,
    String? dateOfBirth,
    String? profilePhoto,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      final studentId = user?.id ?? 'usr_student_01';

      final student = await _ref.read(updateProfileUseCaseProvider).execute(
            studentId: studentId,
            fullName: fullName,
            phoneNumber: phoneNumber,
            educationLevel: educationLevel,
            dateOfBirth: dateOfBirth,
            profilePhoto: profilePhoto,
          );

      _ref.invalidate(profileProvider);
      _ref.read(authNotifierProvider.notifier).checkCurrentUser();
      state = AsyncValue.data(student);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Student?>>((ref) {
  return ProfileNotifier(ref);
});
