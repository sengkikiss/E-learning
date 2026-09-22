import 'package:e_learning/domain/entities/lesson.dart';
import '../material/material_model.dart';

class LessonModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final String videoUrl;
  final String duration;
  final List<MaterialModel> materials;
  final String status;
  final bool isCompleted;
  final bool isLocked;

  const LessonModel({
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

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      videoUrl: json['videoUrl'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      materials: (json['materials'] as List<dynamic>?)
              ?.map((e) => MaterialModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String? ?? 'published',
      isCompleted: json['isCompleted'] as bool? ?? false,
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'order': order,
      'videoUrl': videoUrl,
      'duration': duration,
      'materials': materials.map((e) => e.toJson()).toList(),
      'status': status,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
    };
  }

  Lesson toEntity() {
    return Lesson(
      id: id,
      courseId: courseId,
      title: title,
      description: description,
      order: order,
      videoUrl: videoUrl,
      duration: duration,
      materials: materials.map((m) => m.toEntity()).toList(),
      status: status,
      isCompleted: isCompleted,
      isLocked: isLocked,
    );
  }

  factory LessonModel.fromEntity(Lesson lesson) {
    return LessonModel(
      id: lesson.id,
      courseId: lesson.courseId,
      title: lesson.title,
      description: lesson.description,
      order: lesson.order,
      videoUrl: lesson.videoUrl,
      duration: lesson.duration,
      materials: lesson.materials.map((m) => MaterialModel.fromEntity(m)).toList(),
      status: lesson.status,
      isCompleted: lesson.isCompleted,
      isLocked: lesson.isLocked,
    );
  }
}
