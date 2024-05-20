import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiam/data/models/lesson.dart';

abstract interface class LessonRepository {
  Future<List<Lesson>> getListLesson(String topicId,
      DocumentSnapshot<Object?>? startAfterDoc, int limit, bool sortByTitle);
}

class LessonRepositoryImpl implements LessonRepository {
  final FirebaseFirestore _firestore;

  LessonRepositoryImpl(this._firestore);

  @override
  Future<List<Lesson>> getListLesson(
      String topicId,
      DocumentSnapshot<Object?>? startAfterDoc,
      int limit,
      bool sortByTitle) async {
    final snapshots = sortByTitle
        ? await _firestore
            .collection('lesson')
            .where('topicId', isEqualTo: topicId)
            .orderBy('title', descending: true)
            .limit(limit)
            .get()
        : await _firestore
            .collection('lesson')
            .where('topicId', isEqualTo: topicId)
            .limit(limit)
            .get();
    return snapshots.docs.map((doc) => Lesson.fromJson(doc.data())).toList();
  }
}
