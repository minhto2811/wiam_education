import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wiam/services/file_manager.dart';
import 'package:wiam/services/player_manager.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitialState()) {
    on<SettingsInitialVolumeEvent>(_onSettingsInitialVolumeEvent);
    on<SettingsInitialUserEvent>(_onSettingsInitialUserEvent);
    on<SettingsChangeVolumeLevelEvent>(_onSettingsChangeVolumeLevelEvent);
  }

  Future<void> _onSettingsInitialVolumeEvent(
      SettingsInitialVolumeEvent event, Emitter<SettingsState> emit) async {
    final volume = await FileManager.readTextFile;
    emit(SettingsChangeVolumeState(volume: volume));
  }

  Future<void> _onSettingsInitialUserEvent(
      SettingsInitialUserEvent event, Emitter<SettingsState> emit) async {
    var user = FirebaseAuth.instance.currentUser;
    UserInfo? userFb;
    UserInfo? userGg;
    user?.providerData.forEach((element) {
      if (element.providerId == 'facebook.com') {
        userFb = element;
      } else if (element.providerId == 'google.com') {
        userGg = element;
      }
    });
    emit(SettingsUserState(userFb: userFb, userGg: userGg));
  }

  Future<void> _onSettingsChangeVolumeLevelEvent(
      SettingsChangeVolumeLevelEvent event, Emitter<SettingsState> emit) async {
    final volume = event.volumeLevel;
    PlayerManager().setVolume(volume);
    FileManager.writeTextFile(volume.toString());
  }
}
