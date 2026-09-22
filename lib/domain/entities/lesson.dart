import 'material.dart';

class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final String videoUrl;
  final String duration;
  final List<CourseMaterial> materials;
  final String status;
  final bool isCompleted;
  final bool isLocked;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    required this.videoUrl,
    required this.duration,
    this.materials = const [],
    required this.status,
    this.isCompleted = false,
    this.isLocked = false,
  });

  Lesson copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    int? order,
    String? videoUrl,
    String? duration,
    List<CourseMaterial>? materials,
    String? status,
    bool? isCompleted,
    bool? isLocked,
  }) {
    return Lesson(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      materials: materials ?? this.materials,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
