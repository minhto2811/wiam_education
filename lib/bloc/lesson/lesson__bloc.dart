import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wiam/usecase/lesson/get_list_lesson_use_case.dart';

import '../../data/models/lesson.dart';

part 'lesson__event.dart';
part 'lesson__state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final GetListLessonUseCase _getListLessonUseCase;

  LessonBloc(this._getListLessonUseCase) : super(LessonInitialState()) {
    on<GetListLessonEvent>(_onGetListLessonEvent);
  }

  FutureOr<void> _onGetListLessonEvent(
      GetListLessonEvent event, Emitter<LessonState> emit) async {
    emit(LessonLoadingState());
    try {
      final lessons = await _getListLessonUseCase.call(
          event.topicId, event.lastDoc, event.limit, event.sortByTitle);
      emit(LessonCompletedState(lessons: lessons, error: null));
    } catch (e) {
      print(e.toString());
      emit(LessonCompletedState(lessons: const [], error: e.toString()));
    }
  }
}
