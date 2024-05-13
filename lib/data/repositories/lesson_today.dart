

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiam/data/models/lesson_today.dart';

abstract interface class LessonTodayRepoInterface {
  Future<LessonToday> getLessonToday();
}

class LessonTodayRepo extends LessonTodayRepoInterface {
  @override
  Future<LessonToday> getLessonToday() async {
    var firestore = FirebaseFirestore.instance;
    final snapshots = await firestore
        .collection('lesson_todays')
        .limit(1)
        .get();
    var doc = snapshots.docs.first;
    return LessonToday.fromJson(doc.data());
  }
}
