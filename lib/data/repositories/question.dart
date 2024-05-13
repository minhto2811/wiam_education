import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question.dart';

abstract interface class QuestionRepoInterface {
  Future<Question?> getQuestionById(String id);
}

class QuestionRepo implements QuestionRepoInterface {
  @override
  Future<Question?> getQuestionById(String id) async {
    var firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('questions').doc(id).get();
    return snapshot.exists ? Question.fromJson(snapshot.data()!) : null;
  }
}
