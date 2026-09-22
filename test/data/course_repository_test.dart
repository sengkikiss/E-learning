import 'package:flutter_test/flutter_test.dart';
import 'package:e_learning/data/datasources/remote/fake_api/fake_course_api.dart';
import 'package:e_learning/data/datasources/remote/fake_api/fake_api_client.dart';
import 'package:e_learning/data/repositories/course_repository_impl.dart';

void main() {
  group('CourseRepository & FakeCourseDataSource Tests', () {
    late FakeCourseDataSource fakeDataSource;
    late CourseRepositoryImpl repository;

    setUp(() {
      // 0 delay for instant unit tests
      final client = FakeApiClient(simulatedDelayMs: 0);
      fakeDataSource = FakeCourseDataSource(client);
      repository = CourseRepositoryImpl(fakeDataSource);
    });

    test('getCourses returns seeded courses', () async {
      final courses = await repository.getCourses();
      expect(courses, isNotEmpty);
      expect(courses.length, greaterThanOrEqualTo(10));
      expect(courses.first.title, isNotEmpty);
      expect(courses.first.instructorName, isNotEmpty);
    });

    test('getCategories returns populated category list', () async {
      final categories = await repository.getCategories();
      expect(categories, isNotEmpty);
      expect(categories.any((c) => c.name.contains('Flutter') || c.name.contains('Development')), isTrue);
    });

    test('searchCourses finds matching courses by keyword', () async {
      final results = await repository.searchCourses('Flutter');
      expect(results, isNotEmpty);
      for (final course in results) {
        final matches = course.title.toLowerCase().contains('flutter') ||
            course.description.toLowerCase().contains('flutter') ||
            course.categoryName.toLowerCase().contains('flutter');
        expect(matches, isTrue);
      }
    });

    test('saveCourse and removeSavedCourse updates saved courses list', () async {
      final courseId = 'crs_02';
      await repository.saveCourse(courseId);
      var saved = await repository.getSavedCourses();
      expect(saved.any((c) => c.id == courseId), isTrue);

      await repository.removeSavedCourse(courseId);
      saved = await repository.getSavedCourses();
      expect(saved.any((c) => c.id == courseId), isFalse);
    });
  });
}
