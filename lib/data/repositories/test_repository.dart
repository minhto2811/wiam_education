

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiam/data/models/test.dart';

abstract interface class TestRepository {
  Future<List<Test>> getListTest(String language);
}

class TestRepositoryImpl implements TestRepository {

  final FirebaseFirestore _firestore;

  TestRepositoryImpl(this._firestore);

  @override
  Future<List<Test>> getListTest(String language) async {
    final snapshots = await _firestore
        .collection('tests')
        .where('language', isEqualTo: language)
        .orderBy('title')
        .get();
    return snapshots.docs
        .map((doc) => Test.fromJson(doc.data()))
        .toList();
  }
}