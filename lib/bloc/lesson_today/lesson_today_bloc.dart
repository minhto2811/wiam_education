import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/data/models/lesson_today.dart';
import 'package:wiam/usecase/lesson_today/delete_list_id_lesson_today_recent_use_case.dart';
import 'package:wiam/usecase/lesson_today/get_lesson_today_use_case.dart';
import 'package:wiam/usecase/lesson_today/get_list_id_lesson_today_recent_use_case.dart';

import '../../services/player_manager.dart';

part 'lesson_today_event.dart';
part 'lesson_today_state.dart';

class LessonTodayBloc extends Bloc<LessonTodayEvent, LessonTodayState> {
  final GetLessonTodayUseCase _getLessonTodayUseCase;
  final GetListIdLessonTodayRecentUseCase _getListIdLessonTodayRecentUseCase;
  final DeleteListIdLessonTodayUseCase _deleteListIdLessonTodayUseCase;
  final PlayerManager _playerManager;

  LessonTodayBloc(
      this._getLessonTodayUseCase,
       this._getListIdLessonTodayRecentUseCase,
       this._deleteListIdLessonTodayUseCase,
       this._playerManager)
      : super(LessonTodayInitialState()) {
    on<LessonTodayInitialEvent>(_getLessonToday);
    on<ReadDescriptionEvent>(_readDescription);
  }

  Future<void> _getLessonToday(
      LessonTodayInitialEvent event, Emitter<LessonTodayState> emit) async {
    emit(LessonTodayLoadingState());
    final locale = LocalizedApp.of(event.context).delegate.currentLocale;
    try {
      final ids = await _getListIdLessonTodayRecentUseCase.call();
      if (ids.isEmpty) ids.add('');
      var lessonToday =
          await _getLessonTodayUseCase.call(ids, localeToString(locale));
      if (lessonToday == null) {
        lessonToday = await _getLessonTodayUseCase([''],localeToString(locale));
        await _deleteListIdLessonTodayUseCase.call();
      }
      emit(LessonTodayCompletedState(lessonToday, null));
      _playerManager.playFromUrl(lessonToday!.audio);
    } catch (e) {
      debugPrint(e.toString());
      emit(LessonTodayCompletedState(null, e.toString()));
    }
  }

  Future<void> _readDescription(
      ReadDescriptionEvent event, Emitter<LessonTodayState> emit) async {
    _playerManager.playWhenClick();
    await Future.delayed(const Duration(milliseconds: 300));
    _playerManager.playFromUrl(event.audio);
  }
}
