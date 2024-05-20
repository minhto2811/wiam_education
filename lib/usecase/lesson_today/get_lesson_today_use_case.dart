import 'package:wiam/data/models/lesson_today.dart';
import 'package:wiam/data/repositories/lesson_today_repository.dart';

class GetLessonTodayUseCase {
  final LessonTodayRepository _lessonTodayRepository;

  GetLessonTodayUseCase(this._lessonTodayRepository);

  Future<LessonToday?> call(List<String> ids, String language) async {
    return await _lessonTodayRepository.getLessonToday(ids, language);
  }
}
