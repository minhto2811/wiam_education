import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/topic.dart';

abstract interface class TopicRepository {
  Future<List<Topic>> getListTopic(
      DocumentSnapshot<Object?>? startAfterDoc, int limit);
}

class TopicRepositoryImpl implements TopicRepository {

  final FirebaseFirestore firestore;

  TopicRepositoryImpl({required this.firestore});
  @override
  Future<List<Topic>> getListTopic(
      DocumentSnapshot<Object?>? startAfterDoc, int limit) async {
    final snapshots = startAfterDoc == null
        ? await firestore.collection('topics').limit(limit).get()
        : await firestore
            .collection('topics')
            .startAfterDocument(startAfterDoc)
            .limit(limit)
            .get();

    return snapshots.docs.map((doc) => Topic.fromJson(doc.data())).toList();
  }
}
