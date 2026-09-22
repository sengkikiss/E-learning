import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';
import 'route_guards.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/main_navigation_shell.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/learning/presentation/screens/my_learning_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/courses/presentation/screens/course_detail_screen.dart';
import '../../features/courses/presentation/screens/course_search_screen.dart';
import '../../features/courses/presentation/screens/courses_by_category_screen.dart';
import '../../features/lessons/presentation/screens/lesson_detail_screen.dart';
import '../../features/quiz/presentation/screens/quiz_intro_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/quiz/presentation/screens/quiz_result_screen.dart';
import '../../features/quiz/presentation/screens/quiz_review_screen.dart';
import '../../features/assignments/presentation/screens/assignment_list_screen.dart';
import '../../features/assignments/presentation/screens/assignment_detail_screen.dart';
import '../../features/assignments/presentation/screens/assignment_submission_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/certificates/presentation/screens/certificates_screen.dart';
import '../../features/certificates/presentation/screens/certificate_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/instructor/presentation/screens/instructor_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      return RouteGuards.guard(
        context: context,
        state: state,
        currentUser: authState.valueOrNull,
        isLoading: authState.isLoading,
      );
    },
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Stateful Bottom Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.myCourses,
                builder: (context, state) => const MyLearningScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Course & Search Routes
      GoRoute(
        path: RouteNames.courseDetail,
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return CourseDetailScreen(courseId: courseId);
        },
      ),
      GoRoute(
        path: RouteNames.courseSearch,
        builder: (context, state) => const CourseSearchScreen(),
      ),
      GoRoute(
        path: RouteNames.categoryCourses,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId'] ?? '';
          return CoursesByCategoryScreen(categoryId: categoryId);
        },
      ),

      // Learning & Lesson Routes
      GoRoute(
        path: RouteNames.learning,
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return LessonDetailScreen(courseId: courseId);
        },
      ),

      // Quiz Routes
      GoRoute(
        path: RouteNames.quizIntro,
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return QuizIntroScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: '/quiz/:quizId/start',
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return QuizScreen(quizId: quizId);
        },
      ),
      GoRoute(
        path: RouteNames.quizResult,
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          final score = int.tryParse(state.uri.queryParameters['score'] ?? '0') ?? 0;
          final percentage = double.tryParse(state.uri.queryParameters['percentage'] ?? '0') ?? 0.0;
          final passed = state.uri.queryParameters['passed'] == 'true';
          final correct = int.tryParse(state.uri.queryParameters['correct'] ?? '0') ?? 0;
          final total = int.tryParse(state.uri.queryParameters['total'] ?? '5') ?? 5;

          return QuizResultScreen(
            quizId: quizId,
            score: score,
            percentage: percentage,
            passed: passed,
            correctAnswers: correct,
            totalQuestions: total,
          );
        },
      ),
      GoRoute(
        path: RouteNames.quizReview,
        builder: (context, state) {
          final quizId = state.pathParameters['quizId'] ?? '';
          return QuizReviewScreen(quizId: quizId);
        },
      ),

      // Assignment Routes
      GoRoute(
        path: RouteNames.assignments,
        builder: (context, state) {
          final courseId = state.uri.queryParameters['courseId'] ?? 'crs_01';
          return AssignmentListScreen(courseId: courseId);
        },
      ),
      GoRoute(
        path: RouteNames.assignmentDetail,
        builder: (context, state) {
          final assignmentId = state.pathParameters['assignmentId'] ?? '';
          return AssignmentDetailScreen(assignmentId: assignmentId);
        },
      ),
      GoRoute(
        path: RouteNames.assignmentSubmission,
        builder: (context, state) {
          final assignmentId = state.pathParameters['assignmentId'] ?? '';
          return AssignmentSubmissionScreen(assignmentId: assignmentId);
        },
      ),

      // Progress & History Routes
      GoRoute(
        path: RouteNames.progress,
        builder: (context, state) {
          final courseId = state.pathParameters['courseId'] ?? '';
          return ProgressScreen(courseId: courseId);
        },
      ),
      GoRoute(
        path: RouteNames.history,
        builder: (context, state) => const HistoryScreen(),
      ),

      // Certificates
      GoRoute(
        path: RouteNames.certificates,
        builder: (context, state) => const CertificatesScreen(),
      ),
      GoRoute(
        path: RouteNames.certificateDetail,
        builder: (context, state) {
          final certificateId = state.pathParameters['certificateId'] ?? '';
          return CertificateDetailScreen(certificateId: certificateId);
        },
      ),

      // Profile & Settings
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Role Protected Routes
      GoRoute(
        path: RouteNames.instructorDashboard,
        builder: (context, state) => const InstructorDashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
