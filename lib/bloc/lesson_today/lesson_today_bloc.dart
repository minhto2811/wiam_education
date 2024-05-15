import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiam/data/models/lesson_today.dart';

import '../../data/repositories/lesson_today.dart';
import '../../services/player_manager.dart';

part 'lesson_today_event.dart';
part 'lesson_today_state.dart';

class LessonTodayBloc extends Bloc<LessonTodayEvent, LessonTodayState> {
  final LessonTodayRepository lessonTodayRepo;
  final PlayerManager playerManager;
  LessonTodayBloc({required this.lessonTodayRepo,required this.playerManager}) : super(LessonTodayInitialState()) {
    on<LessonTodayInitialEvent>(_getLessonToday);
    on<ReadDescriptionEvent>(_readDescription);
  }

  Future<void> _getLessonToday(
      LessonTodayInitialEvent event, Emitter<LessonTodayState> emit) async {
    emit(LessonTodayLoadingState());
    try {
      final ids = await lessonTodayRepo.getListIdLessonTodayRecent();
      if (ids.isEmpty) ids.add('');
      var lessonToday = await lessonTodayRepo.getLessonToday(ids);
      if (lessonToday == null) {
        lessonToday = await lessonTodayRepo.getLessonToday(['']);
       await lessonTodayRepo.deleteListIdLessonTodayRecent();
      }
      emit(LessonTodayCompletedState(lessonToday, null));
      lessonTodayRepo.insertIdLessonTodayRecent(lessonToday!.id);
    } catch (e) {
      debugPrint(e.runtimeType.toString());
      emit(LessonTodayCompletedState(null, e.toString()));
    }
  }

  Future<void> _readDescription(
      ReadDescriptionEvent event, Emitter<LessonTodayState> emit) async {
   playerManager.playWhenClick();
    await Future.delayed(const Duration(milliseconds: 300));
   playerManager.playFromUrl(event.audio);
  }
  
}
