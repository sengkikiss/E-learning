import 'package:e_learning/domain/entities/material.dart';

class MaterialModel {
  final String id;
  final String lessonId;
  final String title;
  final String type;
  final String fileUrl;
  final String uploadDate;
  final String description;
  final String fileSize;

  const MaterialModel({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.type,
    required this.fileUrl,
    required this.uploadDate,
    required this.description,
    this.fileSize = '2.4 MB',
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String? ?? '',
      lessonId: json['lessonId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'pdf',
      fileUrl: json['fileUrl'] as String? ?? '',
      uploadDate: json['uploadDate'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fileSize: json['fileSize'] as String? ?? '2.4 MB',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'type': type,
      'fileUrl': fileUrl,
      'uploadDate': uploadDate,
      'description': description,
      'fileSize': fileSize,
    };
  }

  CourseMaterial toEntity() {
    return CourseMaterial(
      id: id,
      lessonId: lessonId,
      title: title,
      type: type,
      fileUrl: fileUrl,
      uploadDate: uploadDate,
      description: description,
      fileSize: fileSize,
    );
  }

  factory MaterialModel.fromEntity(CourseMaterial entity) {
    return MaterialModel(
      id: entity.id,
      lessonId: entity.lessonId,
      title: entity.title,
      type: entity.type,
      fileUrl: entity.fileUrl,
      uploadDate: entity.uploadDate,
      description: entity.description,
      fileSize: entity.fileSize,
    );
  }
}
