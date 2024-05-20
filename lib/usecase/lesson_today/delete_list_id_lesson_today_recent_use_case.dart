import '../../data/repositories/lesson_today_repository.dart';

class DeleteListIdLessonTodayUseCase {
  final LessonTodayRepository _lessonTodayRepository;

  DeleteListIdLessonTodayUseCase(this._lessonTodayRepository);

  Future<void> call() async {
    return await _lessonTodayRepository.deleteListIdLessonTodayRecent();
  }
}
