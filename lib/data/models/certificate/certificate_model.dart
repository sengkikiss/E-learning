import 'package:e_learning/domain/entities/certificate.dart';

class CertificateModel {
  final String id;
  final String studentId;
  final String studentName;
  final String courseId;
  final String courseTitle;
  final String issueDate;
  final String certificateCode;
  final String credentialUrl;
  final String instructorName;

  const CertificateModel({
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

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      courseTitle: json['courseTitle'] as String? ?? '',
      issueDate: json['issueDate'] as String? ?? DateTime.now().toIso8601String(),
      certificateCode: json['certificateCode'] as String? ?? '',
      credentialUrl: json['credentialUrl'] as String? ?? '',
      instructorName: json['instructorName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'issueDate': issueDate,
      'certificateCode': certificateCode,
      'credentialUrl': credentialUrl,
      'instructorName': instructorName,
    };
  }

  Certificate toEntity() {
    return Certificate(
      id: id,
      studentId: studentId,
      studentName: studentName,
      courseId: courseId,
      courseTitle: courseTitle,
      issueDate: DateTime.tryParse(issueDate) ?? DateTime.now(),
      certificateCode: certificateCode,
      credentialUrl: credentialUrl,
      instructorName: instructorName,
    );
  }
}
