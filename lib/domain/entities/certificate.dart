class Certificate {
  final String id;
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseTitle;
  final DateTime issueDate;
  final String certificateCode;
  final String credentialUrl;
  final String instructorName;

  const Certificate({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.courseTitle,
    required this.issueDate,
    required this.certificateCode,
    required this.credentialUrl,
    required this.instructorName,
  });
}
