import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wiam/data/repositories/topic_repo.dart';

import '../../data/models/topic.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicRepository topicRepo;
  TopicBloc({required this.topicRepo}) : super(TopicInitialState()) {
    on<TopicLoadingEvent>(_getData);
  }

  Future<void> _getData(
      TopicLoadingEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingSate());
    try {
      final topics =
          await topicRepo.getListTopic(event.startAfterDoc, event.limit);
      emit(TopicCompletedState(null, topics));
    } catch (e) {
      debugPrint(e.toString());
      emit(TopicCompletedState(e.toString(), const []));
    }
  }
}
