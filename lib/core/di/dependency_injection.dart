import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/config/app_config.dart';

// Storage
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';

// Network
import '../network/api_client.dart';

// Data Sources Interfaces
import '../../data/datasources/remote/auth_datasource.dart';
import '../../data/datasources/remote/course_datasource.dart';
import '../../data/datasources/remote/lesson_datasource.dart';
import '../../data/datasources/remote/quiz_datasource.dart';
import '../../data/datasources/remote/assignment_datasource.dart';
import '../../data/datasources/remote/enrollment_datasource.dart';
import '../../data/datasources/remote/progress_datasource.dart';
import '../../data/datasources/remote/profile_datasource.dart';
import '../../data/datasources/remote/notification_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/local/settings_local_datasource.dart';

// Fake Data Sources
import '../../data/datasources/remote/fake_api/fake_auth_api.dart';
import '../../data/datasources/remote/fake_api/fake_course_api.dart';
import '../../data/datasources/remote/fake_api/fake_lesson_api.dart';
import '../../data/datasources/remote/fake_api/fake_quiz_api.dart';
import '../../data/datasources/remote/fake_api/fake_assignment_api.dart';
import '../../data/datasources/remote/fake_api/fake_enrollment_api.dart';
import '../../data/datasources/remote/fake_api/fake_progress_api.dart';
import '../../data/datasources/remote/fake_api/fake_profile_api.dart';
import '../../data/datasources/remote/fake_api/fake_notification_api.dart';

// Remote Data Sources (Spring Boot)
import '../../data/datasources/remote/api/auth_api.dart';
import '../../data/datasources/remote/api/course_api.dart';
import '../../data/datasources/remote/api/lesson_api.dart';
import '../../data/datasources/remote/api/quiz_api.dart';
import '../../data/datasources/remote/api/assignment_api.dart';
import '../../data/datasources/remote/api/enrollment_api.dart';
import '../../data/datasources/remote/api/progress_api.dart';
import '../../data/datasources/remote/api/profile_api.dart';
import '../../data/datasources/remote/api/notification_api.dart';

// Repositories Interfaces
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/repositories/notification_repository.dart';

// Repository Implementations
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../data/repositories/assignment_repository_impl.dart';
import '../../data/repositories/enrollment_repository_impl.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';

// Use Cases
import '../../domain/usecases/auth/auth_usecases.dart';
import '../../domain/usecases/course/course_usecases.dart';
import '../../domain/usecases/lesson/lesson_usecases.dart';
import '../../domain/usecases/quiz/quiz_usecases.dart';
import '../../domain/usecases/assignment/assignment_usecases.dart';
import '../../domain/usecases/enrollment/enrollment_usecases.dart';
import '../../domain/usecases/progress/progress_usecases.dart';
import '../../domain/usecases/profile/profile_usecases.dart';
import '../../domain/usecases/notification/notification_usecases.dart';

// -------------------------------------------------------------
// 1. Storage & Core Network Providers
// -------------------------------------------------------------
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in main.dart');
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageImpl(prefs);
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

// -------------------------------------------------------------
// 2. Data Sources Providers (Swappable between Fake and Remote)
// -------------------------------------------------------------
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeAuthDataSource();
  }
  return RemoteAuthDataSource(ref.watch(apiClientProvider));
});

final courseDataSourceProvider = Provider<CourseDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeCourseDataSource();
  }
  return RemoteCourseDataSource(ref.watch(apiClientProvider));
});

final lessonDataSourceProvider = Provider<LessonDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeLessonDataSource();
  }
  return RemoteLessonDataSource(ref.watch(apiClientProvider));
});

final quizDataSourceProvider = Provider<QuizDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeQuizDataSource();
  }
  return RemoteQuizDataSource(ref.watch(apiClientProvider));
});

final assignmentDataSourceProvider = Provider<AssignmentDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeAssignmentDataSource();
  }
  return RemoteAssignmentDataSource(ref.watch(apiClientProvider));
});

final enrollmentDataSourceProvider = Provider<EnrollmentDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeEnrollmentDataSource();
  }
  return RemoteEnrollmentDataSource(ref.watch(apiClientProvider));
});

final progressDataSourceProvider = Provider<ProgressDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeProgressDataSource();
  }
  return RemoteProgressDataSource(ref.watch(apiClientProvider));
});

final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeProfileDataSource();
  }
  return RemoteProfileDataSource(ref.watch(apiClientProvider));
});

final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
  if (AppConfig.useFakeApi) {
    return FakeNotificationDataSource();
  }
  return RemoteNotificationDataSource(ref.watch(apiClientProvider));
});

// Local Data Sources
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
    localStorage: ref.watch(localStorageProvider),
  );
});

final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl(ref.watch(localStorageProvider));
});

// -------------------------------------------------------------
// 3. Repository Providers (Clean Architecture Bridges)
// -------------------------------------------------------------
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(ref.watch(courseDataSourceProvider));
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepositoryImpl(ref.watch(lessonDataSourceProvider));
});

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepositoryImpl(ref.watch(quizDataSourceProvider));
});

final assignmentRepositoryProvider = Provider<AssignmentRepository>((ref) {
  return AssignmentRepositoryImpl(ref.watch(assignmentDataSourceProvider));
});

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  return EnrollmentRepositoryImpl(ref.watch(enrollmentDataSourceProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(ref.watch(progressDataSourceProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileDataSourceProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationDataSourceProvider));
});

// -------------------------------------------------------------
// 4. Use Case Providers
// -------------------------------------------------------------
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.watch(authRepositoryProvider)));
final registerUseCaseProvider = Provider((ref) => RegisterUseCase(ref.watch(authRepositoryProvider)));
final getCurrentUserUseCaseProvider = Provider((ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));
final changePasswordUseCaseProvider = Provider((ref) => ChangePasswordUseCase(ref.watch(authRepositoryProvider)));

final getCoursesUseCaseProvider = Provider((ref) => GetCoursesUseCase(ref.watch(courseRepositoryProvider)));
final getCourseDetailUseCaseProvider = Provider((ref) => GetCourseDetailUseCase(ref.watch(courseRepositoryProvider)));
final searchCoursesUseCaseProvider = Provider((ref) => SearchCoursesUseCase(ref.watch(courseRepositoryProvider)));
final getCoursesByCategoryUseCaseProvider = Provider((ref) => GetCoursesByCategoryUseCase(ref.watch(courseRepositoryProvider)));
final getRecommendedCoursesUseCaseProvider = Provider((ref) => GetRecommendedCoursesUseCase(ref.watch(courseRepositoryProvider)));
final getPopularCoursesUseCaseProvider = Provider((ref) => GetPopularCoursesUseCase(ref.watch(courseRepositoryProvider)));
final toggleFavoriteUseCaseProvider = Provider((ref) => ToggleFavoriteUseCase(ref.watch(courseRepositoryProvider)));
final getSavedCoursesUseCaseProvider = Provider((ref) => GetSavedCoursesUseCase(ref.watch(courseRepositoryProvider)));
final getCategoriesUseCaseProvider = Provider((ref) => GetCategoriesUseCase(ref.watch(courseRepositoryProvider)));

final getLessonsUseCaseProvider = Provider((ref) => GetLessonsUseCase(ref.watch(lessonRepositoryProvider)));
final getLessonDetailUseCaseProvider = Provider((ref) => GetLessonDetailUseCase(ref.watch(lessonRepositoryProvider)));
final markLessonCompletedUseCaseProvider = Provider((ref) => MarkLessonCompletedUseCase(ref.watch(lessonRepositoryProvider)));

final getQuizUseCaseProvider = Provider((ref) => GetQuizUseCase(ref.watch(quizRepositoryProvider)));
final getQuizByIdUseCaseProvider = Provider((ref) => GetQuizByIdUseCase(ref.watch(quizRepositoryProvider)));
final submitQuizAttemptUseCaseProvider = Provider((ref) => SubmitQuizAttemptUseCase(ref.watch(quizRepositoryProvider)));
final getQuizAttemptsUseCaseProvider = Provider((ref) => GetQuizAttemptsUseCase(ref.watch(quizRepositoryProvider)));

final getAssignmentsUseCaseProvider = Provider((ref) => GetAssignmentsUseCase(ref.watch(assignmentRepositoryProvider)));
final getAssignmentDetailUseCaseProvider = Provider((ref) => GetAssignmentDetailUseCase(ref.watch(assignmentRepositoryProvider)));
final submitAssignmentUseCaseProvider = Provider((ref) => SubmitAssignmentUseCase(ref.watch(assignmentRepositoryProvider)));
final getSubmissionUseCaseProvider = Provider((ref) => GetSubmissionUseCase(ref.watch(assignmentRepositoryProvider)));

final enrollCourseUseCaseProvider = Provider((ref) => EnrollCourseUseCase(ref.watch(enrollmentRepositoryProvider)));
final getEnrolledCoursesUseCaseProvider = Provider((ref) => GetEnrolledCoursesUseCase(ref.watch(enrollmentRepositoryProvider)));
final checkEnrollmentUseCaseProvider = Provider((ref) => CheckEnrollmentUseCase(ref.watch(enrollmentRepositoryProvider)));

final getCourseProgressUseCaseProvider = Provider((ref) => GetCourseProgressUseCase(ref.watch(progressRepositoryProvider)));
final getLearningHistoryUseCaseProvider = Provider((ref) => GetLearningHistoryUseCase(ref.watch(progressRepositoryProvider)));
final getCertificatesUseCaseProvider = Provider((ref) => GetCertificatesUseCase(ref.watch(progressRepositoryProvider)));
final getCertificateDetailUseCaseProvider = Provider((ref) => GetCertificateDetailUseCase(ref.watch(progressRepositoryProvider)));

final getProfileUseCaseProvider = Provider((ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)));
final updateProfileUseCaseProvider = Provider((ref) => UpdateProfileUseCase(ref.watch(profileRepositoryProvider)));

final getNotificationsUseCaseProvider = Provider((ref) => GetNotificationsUseCase(ref.watch(notificationRepositoryProvider)));
final markNotificationReadUseCaseProvider = Provider((ref) => MarkNotificationReadUseCase(ref.watch(notificationRepositoryProvider)));
final markAllNotificationsReadUseCaseProvider = Provider((ref) => MarkAllNotificationsReadUseCase(ref.watch(notificationRepositoryProvider)));
