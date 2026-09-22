class Category {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String status;
  final int courseCount;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.status,
    this.courseCount = 0,
  });
}
