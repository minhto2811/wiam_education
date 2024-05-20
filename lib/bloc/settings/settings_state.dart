part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {
  const SettingsState();
}

final class SettingsInitialState extends SettingsState {}

final class SettingsLoadingState extends SettingsState {}

final class SettingsChangeVolumeState extends SettingsState {
  final double volume;

  const SettingsChangeVolumeState({required this.volume});
}

final class SettingsUserState extends SettingsState {
  final UserInfo? userFb;
  final UserInfo? userGg;

  const SettingsUserState({required this.userFb, required this.userGg});
}

final class SettingsErrorState extends SettingsState {
  final String message;

  const SettingsErrorState({required this.message});
}

final class SettingsChangeLanguageState extends SettingsState {
}
