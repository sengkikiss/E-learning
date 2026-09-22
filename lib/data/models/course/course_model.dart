import 'package:e_learning/domain/entities/course.dart';

class CourseModel {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final String imageUrl;
  final String instructorId;
  final String duration;
  final String level;
  final int lessonCount;
  final double rating;
  final int enrollmentCount;
  final String status;
  final double price;
  final bool isFree;
  final bool isSaved;
  final String categoryName;
  final String instructorName;
  final String? instructorAvatar;

  const CourseModel({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.imageUrl,
    required this.instructorId,
    required this.duration,
    required this.level,
    required this.lessonCount,
    required this.rating,
    required this.enrollmentCount,
    required this.status,
    required this.price,
    required this.isFree,
    this.isSaved = false,
    this.categoryName = '',
    this.instructorName = '',
    this.instructorAvatar,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      instructorId: json['instructorId'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      level: json['level'] as String? ?? 'All Levels',
      lessonCount: (json['lessonCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      enrollmentCount: (json['enrollmentCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'published',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isFree: json['isFree'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      categoryName: json['categoryName'] as String? ?? '',
      instructorName: json['instructorName'] as String? ?? '',
      instructorAvatar: json['instructorAvatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'description': description,
      'imageUrl': imageUrl,
      'instructorId': instructorId,
      'duration': duration,
      'level': level,
      'lessonCount': lessonCount,
      'rating': rating,
      'enrollmentCount': enrollmentCount,
      'status': status,
      'price': price,
      'isFree': isFree,
      'isSaved': isSaved,
      'categoryName': categoryName,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
    };
  }

  Course toEntity() {
    return Course(
      id: id,
      title: title,
      categoryId: categoryId,
      description: description,
      imageUrl: imageUrl,
      instructorId: instructorId,
      duration: duration,
      level: level,
      lessonCount: lessonCount,
      rating: rating,
      enrollmentCount: enrollmentCount,
      status: status,
      price: price,
      isFree: isFree,
      isSaved: isSaved,
      categoryName: categoryName,
      instructorName: instructorName,
      instructorAvatar: instructorAvatar,
    );
  }

  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      categoryId: course.categoryId,
      description: course.description,
      imageUrl: course.imageUrl,
      instructorId: course.instructorId,
      duration: course.duration,
      level: course.level,
      lessonCount: course.lessonCount,
      rating: course.rating,
      enrollmentCount: course.enrollmentCount,
      status: course.status,
      price: course.price,
      isFree: course.isFree,
      isSaved: course.isSaved,
      categoryName: course.categoryName,
      instructorName: course.instructorName,
      instructorAvatar: course.instructorAvatar,
    );
  }
}
