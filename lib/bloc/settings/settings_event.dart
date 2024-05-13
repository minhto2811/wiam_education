part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}


final class SettingsInitialVolumeEvent extends SettingsEvent {}
final class SettingsInitialUserEvent extends SettingsEvent {}

final class SettingsChangeVolumeLevelEvent extends SettingsEvent {
  final double volumeLevel;
  SettingsChangeVolumeLevelEvent(this.volumeLevel);
}


