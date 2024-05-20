
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/services/sharepreferences_manager.dart';
import 'package:wiam/usecase/lesson_today/create_lesson_today_recent_use_case.dart';

import '../../services/player_manager.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseAuth _auth;
  final PlayerManager _playerManager;
  final CreateLessonTodayRecentUseCase _createLessonTodayRecentUseCase;
  final SharePreferencesManager _sharePreferencesManager;

  SplashBloc(
       this._auth,
       this._playerManager,
       this._sharePreferencesManager,
       this._createLessonTodayRecentUseCase)
      : super(SplashInitialState()) {
    on<SplashInitialEvent>(_onRunningCheck);
  }

  Future<void> _onRunningCheck(
      SplashInitialEvent event, Emitter<SplashState> emit) async {
    changeLocale(event.context, await _sharePreferencesManager.getSettingLanguage());
    final double volume =
        await _sharePreferencesManager.getSettingVolume() ?? 1.0;
    _playerManager.setVolume(volume);
    _playerManager.playFromAssets('audios/splash.mp3');
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
        _createLessonTodayRecentUseCase.call();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashCheckCompletedState());
  }

}
