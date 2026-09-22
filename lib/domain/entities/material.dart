class CourseMaterial {
  final String id;
  final String lessonId;
  final String title;
  final String type; // pdf, code, slides, zip
  final String fileUrl;
  final String uploadDate;
  final String description;
  final String fileSize;

  const CourseMaterial({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.type,
    required this.fileUrl,
    required this.uploadDate,
    required this.description,
    this.fileSize = '2.4 MB',
  });
}
