import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiam/data/repositories/lesson_repository.dart';

import '../../data/models/lesson.dart';

class GetListLessonUseCase {
  final LessonRepository _lessonRepository;

  GetListLessonUseCase(this._lessonRepository);

  Future<List<Lesson>> call(String topicId,
      DocumentSnapshot<Object?>? startAfterDoc, int limit, bool sortByTitle) async {
    return await _lessonRepository.getListLesson(
        topicId, startAfterDoc, limit, sortByTitle);
  }
}
