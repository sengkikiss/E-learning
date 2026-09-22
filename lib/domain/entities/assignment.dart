class Assignment {
  final String id;
  final String courseId;
  final String lessonId;
  final String title;
  final String description;
  final String instruction;
  final DateTime dueDate;
  final String supportingFile;
  final int maximumScore;

  const Assignment({
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

  bool get isOverdue => DateTime.now().isAfter(dueDate);
}
