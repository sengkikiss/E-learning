import '../lesson_datasource.dart';
import 'fake_api_client.dart';
import 'fake_database.dart';
import 'package:e_learning/data/models/lesson/lesson_model.dart';
import 'package:e_learning/core/error/app_exception.dart';

class FakeLessonDataSource implements LessonDataSource {
  final FakeApiClient _client;
  final Set<String> _completedLessonIds = {'les_01_01', 'les_01_02', 'les_02_01', 'les_04_01'};

  FakeLessonDataSource([FakeApiClient? client]) : _client = client ?? FakeApiClient();

  @override
  Future<List<LessonModel>> getLessonsByCourse(String courseId) async {
    final response = await _client.request<List<LessonModel>>(
      dataFetcher: () {
        return FakeDatabase.lessons.where((l) => l.courseId == courseId).map((l) {
          return LessonModel.fromJson({
            ...l.toJson(),
            'isCompleted': _completedLessonIds.contains(l.id),
          });
        }).toList();
      },
      successMessage: 'Lessons retrieved successfully',
    );
    return response.data ?? [];
  }

  @override
  Future<LessonModel> getLessonById(String lessonId) async {
    final response = await _client.request<LessonModel>(
      dataFetcher: () {
        final match = FakeDatabase.lessons.cast<LessonModel?>().firstWhere(
              (l) => l?.id == lessonId,
              orElse: () => null,
            );
        if (match == null) {
          throw NotFoundException('Lesson with id "$lessonId" not found');
        }
        return LessonModel.fromJson({
          ...match.toJson(),
          'isCompleted': _completedLessonIds.contains(match.id),
        });
      },
      successMessage: 'Lesson details retrieved successfully',
    );
    return response.data!;
  }

  @override
  Future<void> markLessonCompleted(String lessonId, String courseId) async {
    await _client.request<bool>(
      dataFetcher: () {
        _completedLessonIds.add(lessonId);
        return true;
      },
      successMessage: 'Lesson marked as completed',
    );
  }
}
