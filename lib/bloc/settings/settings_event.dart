part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

final class SettingsInitialVolumeEvent extends SettingsEvent {}

final class SettingsInitialUserEvent extends SettingsEvent {}

final class SettingsChangeVolumeLevelEvent extends SettingsEvent {
  final double volumeLevel;

  SettingsChangeVolumeLevelEvent(this.volumeLevel);
}

final class SettingsLinkAccountEvent extends SettingsEvent {
  final String type;
  SettingsLinkAccountEvent({required this.type});
}


final class SettingContactEvent extends SettingsEvent {
  final String type;

  SettingContactEvent({required this.type});
}


final class SettingsSignInEvent extends SettingsEvent {
  final String type;

  SettingsSignInEvent({required this.type});
}


