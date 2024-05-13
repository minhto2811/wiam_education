import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiam/data/models/lesson_today.dart';

import '../../data/repositories/lesson_today.dart';
import '../../services/player_manager.dart';

part 'lesson_today_event.dart';
part 'lesson_today_state.dart';

class LessonTodayBloc extends Bloc<LessonTodayEvent, LessonTodayState> {
  LessonTodayBloc() : super(LessonTodayInitialState()) {
    on<LessonTodayInitialEvent>(_getListLessonToday);
    on<ReadDescriptionEvent>(_readDescription);
  }

  Future<void> _getListLessonToday(
      LessonTodayInitialEvent event, Emitter<LessonTodayState> emit) async {
    emit(LessonTodayLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    var lessonTodayRepo = LessonTodayRepo();
    try {
      final lessonToday = await lessonTodayRepo.getLessonToday();
      emit(LessonTodayCompletedState(lessonToday, null));
      PlayerManager().playFromUrl(lessonToday.audio);
    } catch (e) {
      debugPrint(e.toString());
      emit(LessonTodayCompletedState(null, e.toString()));
    }
  }

  Future<void> _readDescription(
      ReadDescriptionEvent event, Emitter<LessonTodayState> emit) async{
    PlayerManager().playWhenClick();
    await Future.delayed(const Duration(milliseconds: 300));
    PlayerManager().playFromUrl(event.audio);
  }

  void dispose() {
    PlayerManager().stop();
    PlayerManager().release();
  }
}
