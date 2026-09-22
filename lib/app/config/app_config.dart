import 'environment.dart';

class AppConfig {
  static const String appName = 'EduLearn';
  static const String appVersion = '1.0.0';

  /// Toggle between Fake REST API and real Spring Boot REST backend.
  /// When true: uses the realistic in-memory Fake Database & simulated latency/responses.
  /// When false: connects to Spring Boot REST endpoints at ApiConfig.baseUrl.
  static bool useFakeApi = true;

  static Environment environment = Environment.development;
}
