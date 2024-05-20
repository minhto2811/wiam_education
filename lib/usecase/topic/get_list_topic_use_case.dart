import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wiam/data/models/topic.dart';

import '../../data/repositories/topic_repository.dart';

class GetListTopicUseCase {
  final TopicRepository _topicRepository;

  GetListTopicUseCase(this._topicRepository);

  Future<List<Topic>> call(DocumentSnapshot<Object?>? startAfterDoc, int limit,
      String language) async {
    return await _topicRepository.getListTopic(startAfterDoc, limit, language);
  }
}
