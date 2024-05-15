import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question.dart';

abstract interface class QuestionRepository {
  Future<Question?> getQuestionById(String id);
}

class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore firestore;
  QuestionRepositoryImpl({required this.firestore});
  @override
  Future<Question?> getQuestionById(String id) async {
    final snapshot = await firestore.collection('questions').doc(id).get();
    return snapshot.exists ? Question.fromJson(snapshot.data()!) : null;
  }
}
