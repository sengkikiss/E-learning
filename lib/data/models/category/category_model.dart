import 'package:e_learning/domain/entities/category.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String status;
  final int courseCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.status,
    this.courseCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      courseCount: (json['courseCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'status': status,
      'courseCount': courseCount,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      status: status,
      courseCount: courseCount,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      iconUrl: category.iconUrl,
      status: category.status,
      courseCount: category.courseCount,
    );
  }
}
