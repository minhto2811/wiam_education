
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/file_manager.dart';
import '../../services/player_manager.dart';


part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitialState()) {
    on<SplashInitialEvent>(_onRunningCheck);
  }

  Future<void> _onRunningCheck(SplashEvent event,
      Emitter<SplashState> emit) async {
    final volume = await FileManager.readTextFile;
    PlayerManager().setVolume(volume);
    PlayerManager().playFromAssets('audios/splash.mp3');
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        await FirebaseAuth.instance.signInAnonymously();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashCheckCompletedState());
  }
}
