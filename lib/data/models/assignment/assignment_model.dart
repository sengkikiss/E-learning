import 'package:e_learning/domain/entities/assignment.dart';
import 'package:e_learning/domain/entities/submission.dart';

class AssignmentModel {
  final String id;
  final String courseId;
  final String lessonId;
  final String title;
  final String description;
  final String instruction;
  final String dueDate;
  final String supportingFile;
  final int maximumScore;

  const AssignmentModel({
    required this.id,
    required this.courseId,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.instruction,
    required this.dueDate,
    required this.supportingFile,
    required this.maximumScore,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
      dueDate: json['dueDate'] as String? ?? '',
      supportingFile: json['supportingFile'] as String? ?? '',
      maximumScore: (json['maximumScore'] as num?)?.toInt() ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'lessonId': lessonId,
      'title': title,
      'description': description,
      'instruction': instruction,
      'dueDate': dueDate,
      'supportingFile': supportingFile,
      'maximumScore': maximumScore,
    };
  }

  Assignment toEntity() {
    return Assignment(
      id: id,
      courseId: courseId,
      lessonId: lessonId,
      title: title,
      description: description,
      instruction: instruction,
      dueDate: DateTime.tryParse(dueDate) ?? DateTime.now().add(const Duration(days: 7)),
      supportingFile: supportingFile,
      maximumScore: maximumScore,
    );
  }
}

class SubmissionModel {
  final String id;
  final String assignmentId;
  final String studentId;
  final String submissionDate;
  final String? submissionFile;
  final String textSubmission;
  final String? comment;
  final String status;
  final int? score;
  final String? grade;
  final String? feedback;
  final String? reviewedDate;

  const SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.submissionDate,
    this.submissionFile,
    required this.textSubmission,
    this.comment,
    required this.status,
    this.score,
    this.grade,
    this.feedback,
    this.reviewedDate,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] as String? ?? '',
      assignmentId: json['assignmentId'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      submissionDate: json['submissionDate'] as String? ?? '',
      submissionFile: json['submissionFile'] as String?,
      textSubmission: json['textSubmission'] as String? ?? '',
      comment: json['comment'] as String?,
      status: json['status'] as String? ?? 'submitted',
      score: (json['score'] as num?)?.toInt(),
      grade: json['grade'] as String?,
      feedback: json['feedback'] as String?,
      reviewedDate: json['reviewedDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignmentId': assignmentId,
      'studentId': studentId,
      'submissionDate': submissionDate,
      'submissionFile': submissionFile,
      'textSubmission': textSubmission,
      'comment': comment,
      'status': status,
      'score': score,
      'grade': grade,
      'feedback': feedback,
      'reviewedDate': reviewedDate,
    };
  }

  Submission toEntity() {
    SubmissionStatus submissionStatus;
    switch (status.toLowerCase()) {
      case 'graded':
        submissionStatus = SubmissionStatus.graded;
        break;
      case 'returned':
        submissionStatus = SubmissionStatus.returned;
        break;
      case 'submitted':
      default:
        submissionStatus = SubmissionStatus.submitted;
        break;
    }

    return Submission(
      id: id,
      assignmentId: assignmentId,
      studentId: studentId,
      submissionDate: DateTime.tryParse(submissionDate) ?? DateTime.now(),
      submissionFile: submissionFile,
      textSubmission: textSubmission,
      comment: comment,
      status: submissionStatus,
      score: score,
      grade: grade,
      feedback: feedback,
      reviewedDate: reviewedDate != null ? DateTime.tryParse(reviewedDate!) : null,
    );
  }
}
