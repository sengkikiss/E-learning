import 'environment.dart';

class ApiConfig {
  static Environment currentEnvironment = Environment.development;

  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return 'http://localhost:8080';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
