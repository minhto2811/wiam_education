import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/topic.dart';

abstract interface class TopicRepository {
  Future<List<Topic>> getListTopic(
      DocumentSnapshot<Object?>? startAfterDoc, int limit, String language);
}

class TopicRepositoryImpl implements TopicRepository {
  final FirebaseFirestore _firestore;

  TopicRepositoryImpl(this._firestore);

  @override
  Future<List<Topic>> getListTopic(DocumentSnapshot<Object?>? startAfterDoc,
      int limit, String language) async {
    final snapshots = startAfterDoc == null
        ? await _firestore
            .collection('topics')
            .where('language', isEqualTo: language)
            .limit(limit)
            .get()
        : await _firestore
            .collection('topics')
            .where('language', isEqualTo: language)
            .startAfterDocument(startAfterDoc)
            .limit(limit)
            .get();

    return snapshots.docs.map((doc) => Topic.fromJson(doc.data())).toList();
  }
}
