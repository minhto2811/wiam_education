import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question.dart';

abstract interface class QuestionRepository {
  Future<Question?> getQuestionByTypeId(String id);

  Future<List<Question>> getListQuestionByTypeId(String testId);
}

class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore _firestore;

  QuestionRepositoryImpl(this._firestore);

  @override
  Future<Question?> getQuestionByTypeId(String id) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('lesson_today_id', isEqualTo: id)
        .limit(1)
        .get();
    return snapshot.size > 0
        ? Question.fromJson(snapshot.docs.first.data())
        : null;
  }

  @override
  Future<List<Question>> getListQuestionByTypeId(String testId) async {
    final snapshot = await _firestore
        .collection('questions')
        .where('test_id', isEqualTo: testId)
        .get();
    return  List.from(snapshot.docs.map((doc) => Question.fromJson(doc.data())));
  }
}
