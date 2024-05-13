import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/topic.dart';

abstract interface class TopicRepoInterface {
  Future<List<Topic>> getListTopic(
      DocumentSnapshot<Object?>? startAfterDoc, int limit);
}

class TopicRepo extends TopicRepoInterface {
  @override
  Future<List<Topic>> getListTopic(
      DocumentSnapshot<Object?>? startAfterDoc, int limit) async {
    var firestore = FirebaseFirestore.instance;
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
