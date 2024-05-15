import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiam/services/sharepreferences_manager.dart';

import '../../data/repositories/lesson_today.dart';
import '../../services/player_manager.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseAuth auth;
  final PlayerManager playerManager;
  final LessonTodayRepository lessonTodayRepo;

  SplashBloc(
      {required this.auth,
      required this.playerManager,
      required this.lessonTodayRepo})
      : super(SplashInitialState()) {
    on<SplashInitialEvent>(_onRunningCheck);
  }

  Future<void> _onRunningCheck(
      SplashEvent event, Emitter<SplashState> emit) async {
    final double volume =
        await SharePreferencesManager.getSetting(SettingKey.volume);
    playerManager.setVolume(volume);
    playerManager.playFromAssets('audios/splash.mp3');
    if (auth.currentUser == null) {
      try {
        await auth.signInAnonymously();
        lessonTodayRepo.createLessonTodayRecent();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashCheckCompletedState());
  }
}
