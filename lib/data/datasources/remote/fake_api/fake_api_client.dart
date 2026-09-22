import 'dart:math';
import 'package:e_learning/core/network/api_response.dart';
import 'package:e_learning/core/error/app_exception.dart';

class FakeApiClient {
  final int simulatedDelayMs;
  final bool simulateRandomErrors;
  final Random _random = Random();

  FakeApiClient({
    this.simulatedDelayMs = 800,
    this.simulateRandomErrors = false,
  });

  Future<ApiResponse<T>> request<T>({
    required T Function() dataFetcher,
    String successMessage = 'Operation completed successfully',
  }) async {
    // 1. Simulate network latency
    if (simulatedDelayMs > 0) {
      await Future.delayed(Duration(milliseconds: simulatedDelayMs));
    }

    // 2. Simulate occasional error if flag is enabled (e.g., 2% chance in stress test)
    if (simulateRandomErrors && _random.nextDouble() < 0.02) {
      throw const NetworkException('Simulated network packet drop. Please retry.');
    }

    try {
      final data = dataFetcher();
      return ApiResponse<T>.success(
        data: data,
        message: successMessage,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Future<ApiResponse<T>> asyncRequest<T>({
    required Future<T> Function() dataFetcher,
    String successMessage = 'Operation completed successfully',
  }) async {
    if (simulatedDelayMs > 0) {
      await Future.delayed(Duration(milliseconds: simulatedDelayMs));
    }

    try {
      final data = await dataFetcher();
      return ApiResponse<T>.success(
        data: data,
        message: successMessage,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
