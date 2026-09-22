class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String timestamp;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      timestamp: json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  factory ApiResponse.error({
    required String message,
    T? data,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      data: data,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value)? toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'timestamp': timestamp,
    };
  }
}
