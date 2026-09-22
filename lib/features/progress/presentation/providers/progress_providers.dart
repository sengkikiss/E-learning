import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/course_progress.dart';
import '../../../../domain/entities/learning_activity.dart';
import '../../../../domain/entities/certificate.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:e_learning/features/auth/presentation/providers/auth_providers.dart';

final courseProgressProvider = FutureProvider.family<CourseProgress, String>((ref, courseId) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(getCourseProgressUseCaseProvider).execute(courseId, studentId);
});

final learningHistoryProvider = FutureProvider<List<LearningActivity>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(getLearningHistoryUseCaseProvider).execute(studentId);
});

final certificatesProvider = FutureProvider<List<Certificate>>((ref) async {
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'usr_student_01';
  return ref.watch(getCertificatesUseCaseProvider).execute(studentId);
});

final certificateDetailProvider = FutureProvider.family<Certificate?, String>((ref, certificateId) async {
  return ref.watch(getCertificateDetailUseCaseProvider).execute(certificateId);
});
