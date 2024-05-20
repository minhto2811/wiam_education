part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

final class SettingsInitialVolumeEvent extends SettingsEvent {}

final class SettingsInitialUserEvent extends SettingsEvent {}

final class SettingsChangeVolumeLevelEvent extends SettingsEvent {
  final double volumeLevel;

  SettingsChangeVolumeLevelEvent(this.volumeLevel);
}

final class SettingsChangeLanguageEvent extends SettingsEvent {
  final BuildContext context;

  SettingsChangeLanguageEvent(this.context);
}

final class SettingsLinkAccountEvent extends SettingsEvent {
  final String type;
  final BuildContext context;

  SettingsLinkAccountEvent({required this.context, required this.type});
}

final class SettingContactEvent extends SettingsEvent {
  final String type;

  final BuildContext context;

  SettingContactEvent({required this.context, required this.type});
}

final class SettingsSignInEvent extends SettingsEvent {
  final String type;
  final BuildContext context;

  SettingsSignInEvent({required this.context, required this.type});
}
