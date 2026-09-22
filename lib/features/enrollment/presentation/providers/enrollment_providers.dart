import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/course.dart';
import '../../../../domain/entities/enrollment.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/auth/presentation/providers/auth_providers.dart';

final enrolledCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(getEnrolledCoursesUseCaseProvider).execute(studentId);
});

final isCourseEnrolledProvider = FutureProvider.family<bool, String>((ref, courseId) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(checkEnrollmentUseCaseProvider).execute(courseId, studentId);
});

class EnrollmentNotifier extends StateNotifier<AsyncValue<Enrollment?>> {
  final Ref _ref;

  EnrollmentNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> enroll(String courseId) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      final studentId = user?.id ?? 'usr_student_01';
      final enrollment = await _ref.read(enrollCourseUseCaseProvider).execute(courseId, studentId);

      _ref.invalidate(enrolledCoursesProvider);
      _ref.invalidate(isCourseEnrolledProvider(courseId));

      state = AsyncValue.data(enrollment);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final enrollmentNotifierProvider = StateNotifierProvider<EnrollmentNotifier, AsyncValue<Enrollment?>>((ref) {
  return EnrollmentNotifier(ref);
});
