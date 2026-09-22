import 'package:e_learning/domain/entities/enrollment.dart';

class EnrollmentModel {
  final String id;
  final String studentId;
  final String courseId;
  final String enrollmentDate;
  final String status;
  final double progress;

  const EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrollmentDate,
    required this.status,
    required this.progress,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      enrollmentDate: json['enrollmentDate'] as String? ?? DateTime.now().toIso8601String(),
      status: json['status'] as String? ?? 'active',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'enrollmentDate': enrollmentDate,
      'status': status,
      'progress': progress,
    };
  }

  Enrollment toEntity() {
    EnrollmentStatus enrollmentStatus;
    switch (status.toLowerCase()) {
      case 'completed':
        enrollmentStatus = EnrollmentStatus.completed;
        break;
      case 'cancelled':
        enrollmentStatus = EnrollmentStatus.cancelled;
        break;
      case 'active':
      default:
        enrollmentStatus = EnrollmentStatus.active;
        break;
    }

    return Enrollment(
      id: id,
      studentId: studentId,
      courseId: courseId,
      enrollmentDate: DateTime.tryParse(enrollmentDate) ?? DateTime.now(),
      status: enrollmentStatus,
      progress: progress,
    );
  }
}
