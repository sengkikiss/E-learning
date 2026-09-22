enum EnrollmentStatus {
  active,
  completed,
  cancelled,
}

class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime enrollmentDate;
  final EnrollmentStatus status;
  final double progress;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.enrollmentDate,
    required this.status,
    required this.progress,
  });

  Enrollment copyWith({
    String? id,
    String? studentId,
    String? courseId,
    DateTime? enrollmentDate,
    EnrollmentStatus? status,
    double? progress,
  }) {
    return Enrollment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}
