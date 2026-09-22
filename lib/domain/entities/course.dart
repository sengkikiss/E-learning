class Course {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final String imageUrl;
  final String instructorId;
  final String duration;
  final String level; // Beginner, Intermediate, Advanced
  final int lessonCount;
  final double rating;
  final int enrollmentCount;
  final String status; // active, draft, archived
  final double price;
  final bool isFree;
  final bool isSaved;
  final String categoryName;
  final String instructorName;
  final String? instructorAvatar;

  const Course({
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

  Course copyWith({
    String? id,
    String? title,
    String? categoryId,
    String? description,
    String? imageUrl,
    String? instructorId,
    String? duration,
    String? level,
    int? lessonCount,
    double? rating,
    int? enrollmentCount,
    String? status,
    double? price,
    bool? isFree,
    bool? isSaved,
    String? categoryName,
    String? instructorName,
    String? instructorAvatar,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      instructorId: instructorId ?? this.instructorId,
      duration: duration ?? this.duration,
      level: level ?? this.level,
      lessonCount: lessonCount ?? this.lessonCount,
      rating: rating ?? this.rating,
      enrollmentCount: enrollmentCount ?? this.enrollmentCount,
      status: status ?? this.status,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      isSaved: isSaved ?? this.isSaved,
      categoryName: categoryName ?? this.categoryName,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
    );
  }
}
