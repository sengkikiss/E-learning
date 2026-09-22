enum SubmissionStatus {
  submitted,
  graded,
  returned,
}

class Submission {
  final String id;
  final String assignmentId;
  final String studentId;
  final DateTime submissionDate;
  final String? submissionFile;
  final String textSubmission;
  final String? comment;
  final SubmissionStatus status;
  final int? score;
  final String? grade;
  final String? feedback;
  final DateTime? reviewedDate;

  const Submission({
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

  bool get isGraded => status == SubmissionStatus.graded;
}
