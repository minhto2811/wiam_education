import '../../data/repositories/lesson_today_repository.dart';

class InsertIdLessonTodayRecentUseCase {
  final LessonTodayRepository _lessonTodayRepository;

  InsertIdLessonTodayRecentUseCase(this._lessonTodayRepository);

  Future<void> call(String ids) async {
    return await _lessonTodayRepository.insertIdLessonTodayRecent(ids);
  }
}
