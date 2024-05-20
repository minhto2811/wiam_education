import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/usecase/topic/get_list_topic_use_case.dart';

import '../../data/models/topic.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final GetListTopicUseCase _getListTopicUseCase;

  TopicBloc( this._getListTopicUseCase) : super(TopicInitialState()) {
    on<TopicLoadingEvent>(_getData);
  }

  Future<void> _getData(
      TopicLoadingEvent event, Emitter<TopicState> emit) async {
    emit(TopicLoadingSate());
    final locale = LocalizedApp.of(event.context).delegate.currentLocale;
    try {
      final topics = await _getListTopicUseCase.call(
          event.startAfterDoc, event.limit, localeToString(locale));
      emit(TopicCompletedState(null, topics));
    } catch (e) {
      debugPrint(e.toString());
      emit(TopicCompletedState(e.toString(), const []));
    }
  }
}
