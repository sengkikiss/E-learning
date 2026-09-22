class ApiConstants {
  ApiConstants._();

  // Auth endpoints
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String logout = '/api/v1/auth/logout';
  static const String refreshToken = '/api/v1/auth/refresh-token';
  static const String changePassword = '/api/v1/auth/change-password';
  static const String currentUser = '/api/v1/auth/me';

  // Course endpoints
  static const String courses = '/api/v1/courses';
  static const String courseDetail = '/api/v1/courses/{id}';
  static const String searchCourses = '/api/v1/courses/search';
  static const String popularCourses = '/api/v1/courses/popular';
  static const String recommendedCourses = '/api/v1/courses/recommended';
  static const String categories = '/api/v1/categories';
  static const String coursesByCategory = '/api/v1/categories/{id}/courses';

  // Enrollment endpoints
  static const String enrollments = '/api/v1/enrollments';
  static const String myEnrollments = '/api/v1/enrollments/my';
  static const String enrollCourse = '/api/v1/enrollments/enroll';

  // Lesson endpoints
  static const String lessons = '/api/v1/lessons';
  static const String lessonsByCourse = '/api/v1/courses/{courseId}/lessons';
  static const String lessonDetail = '/api/v1/lessons/{id}';
  static const String completeLesson = '/api/v1/lessons/{id}/complete';

  // Quiz endpoints
  static const String quizzes = '/api/v1/quizzes';
  static const String quizByLesson = '/api/v1/lessons/{lessonId}/quiz';
  static const String quizDetail = '/api/v1/quizzes/{id}';
  static const String submitQuiz = '/api/v1/quizzes/{id}/submit';
  static const String quizAttempts = '/api/v1/quizzes/{id}/attempts';

  // Assignment endpoints
  static const String assignments = '/api/v1/assignments';
  static const String assignmentsByCourse = '/api/v1/courses/{courseId}/assignments';
  static const String assignmentDetail = '/api/v1/assignments/{id}';
  static const String submitAssignment = '/api/v1/assignments/{id}/submit';
  static const String mySubmissions = '/api/v1/assignments/{id}/submissions/my';

  // Progress & Certificates
  static const String progress = '/api/v1/progress';
  static const String courseProgress = '/api/v1/progress/courses/{courseId}';
  static const String learningHistory = '/api/v1/progress/history';
  static const String certificates = '/api/v1/certificates';

  // User & Student Profile
  static const String profile = '/api/v1/profile';
  static const String updateProfile = '/api/v1/profile/update';
  static const String notifications = '/api/v1/notifications';
  static const String markNotificationRead = '/api/v1/notifications/{id}/read';
  static const String favorites = '/api/v1/favorites';
}
