import '../../data/repositories/lesson_today_repository.dart';

class GetListIdLessonTodayRecentUseCase {
  final LessonTodayRepository _lessonTodayRepository;

  GetListIdLessonTodayRecentUseCase(this._lessonTodayRepository);

  Future<List<String>> call() async {
    return await _lessonTodayRepository.getListIdLessonTodayRecent();
  }
}
