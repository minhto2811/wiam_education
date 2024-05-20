import 'package:wiam/data/repositories/lesson_today_repository.dart';

class CreateLessonTodayRecentUseCase {
  final LessonTodayRepository _lessonTodayRepository;

  CreateLessonTodayRecentUseCase(this._lessonTodayRepository);

  Future<void> call() async {
    return await _lessonTodayRepository.createLessonTodayRecent();
  }
}
