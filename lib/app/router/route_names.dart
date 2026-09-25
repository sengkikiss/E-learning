class RouteNames {
  RouteNames._();

  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Shell Tabs
  static const String home = '/home';
  static const String explore = '/explore';
  static const String myCourses = '/my-courses';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Courses & Categories
  static const String courseDetail = '/courses/:courseId';
  static const String coursePayment = '/payment/:courseId';
  static const String courseSearch = '/search';
  static const String categoryCourses = '/categories/:categoryId';

  // Learning & Lessons
  static const String learning = '/learning/:courseId';
  static const String lessonDetail = '/lessons/:lessonId';

  // Quiz
  static const String quizIntro = '/quiz/:quizId';
  static const String quizResult = '/quiz/:quizId/result';
  static const String quizReview = '/quiz/:quizId/review';

  // Assignments
  static const String assignments = '/assignments';
  static const String assignmentDetail = '/assignments/:assignmentId';
  static const String assignmentSubmission = '/assignments/:assignmentId/submission';

  // Progress, History & Certificates
  static const String progress = '/progress/:courseId';
  static const String history = '/history';
  static const String certificates = '/certificates';
  static const String certificateDetail = '/certificates/:certificateId';

  // Profile & Settings
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String changePassword = '/settings/change-password';
  static const String notifications = '/notifications';

  // Role Specific Dashboards
  static const String instructorDashboard = '/instructor';
  static const String adminDashboard = '/admin';
}
