import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wiam/data/models/lesson_today.dart';

abstract interface class LessonTodayRepository {


  Future<LessonToday?> getLessonToday(List<String> ids);

  Future<List<String>> getListIdLessonTodayRecent();

  Future<void> insertIdLessonTodayRecent(String ids);

  Future<void> deleteListIdLessonTodayRecent();

  Future<void> createLessonTodayRecent();
}

class LessonTodayRepositoryImpl implements LessonTodayRepository {
  final FirebaseFirestore firestore;

  LessonTodayRepositoryImpl({required this.firestore});

  @override
  Future<LessonToday?> getLessonToday(List<String> ids) async {
    
    final snapshots = await firestore
        .collection('lesson_todays')
        .where('id', whereNotIn: ids)
        .limit(1)
        .get();
    if (snapshots.docs.isEmpty) return null;
    var doc = snapshots.docs.first;
    return LessonToday.fromJson(doc.data());
  }

  @override
  Future<List<String>> getListIdLessonTodayRecent() async {
    
    var userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshots =
        await firestore.collection('lesson_today_recent').doc(userId).get();
    return LessonToday.getList(snapshots.data());
  }

  @override
  Future<void> deleteListIdLessonTodayRecent() async {
    
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await firestore
        .collection('lesson_today_recent')
        .doc(userId)
        .set({'ids': []}, SetOptions(merge: true));
  }

  @override
  Future<void> insertIdLessonTodayRecent(String ids) async {
    
    var userId = FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection('lesson_today_recent').doc(userId).update({
      'ids': FieldValue.arrayUnion([ids])
    });
  }

  @override
  Future<void> createLessonTodayRecent() {
    
    var userId = FirebaseAuth.instance.currentUser!.uid;
    var data = {
      'userId': userId,
      'ids': [],
    };
    return firestore.collection('lesson_today_recent').doc(userId).set(data);
  }
}
