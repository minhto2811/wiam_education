import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiam/usecase/facebook/facebook_sign_out_use_case.dart';
import 'package:wiam/usecase/facebook/get_credential_facebook_use_case.dart';
import 'package:wiam/usecase/google/get_credential_google_use_case.dart';
import 'package:wiam/usecase/google/google_sign_out_use_case.dart';
import 'package:wiam/usecase/lesson_today/create_lesson_today_recent_use_case.dart';

import '../../services/player_manager.dart';
import '../../services/sharepreferences_manager.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final FirebaseAuth _auth;
  final GetCredentialGoogleUseCase _getCredentialGoogleUseCase;
  final GetCredentialFacebookUseCase _getCredentialFacebookUseCase;
  final CreateLessonTodayRecentUseCase _createLessonTodayRecentUseCase;
  final FacebookSignOutUseCase _facebookSignOutUseCase;
  final GoogleSignOutUseCase _googleSignOutUseCase;

  final PlayerManager _playerManager;
  final SharePreferencesManager _sharePreferencesManager;

  SettingsBloc(
      this._auth,
      this._getCredentialGoogleUseCase,
      this._getCredentialFacebookUseCase,
      this._createLessonTodayRecentUseCase,
      this._facebookSignOutUseCase,
      this._googleSignOutUseCase,
      this._playerManager,
      this._sharePreferencesManager)
      : super(SettingsInitialState()) {
    on<SettingsInitialVolumeEvent>(_onSettingsInitialVolumeEvent);
    on<SettingsInitialUserEvent>(_onSettingsInitialUserEvent);
    on<SettingsChangeVolumeLevelEvent>(_onSettingsChangeVolumeLevelEvent);
    on<SettingsLinkAccountEvent>(_onSettingsLinkAccountEvent);
    on<SettingContactEvent>(_onSettingContactEvent);
    on<SettingsSignInEvent>(_onSettingsSignInEvent);
    on<SettingsChangeLanguageEvent>(_onSettingsChangeLanguageEvent);
  }

  Future<void> _onSettingsChangeLanguageEvent(
      SettingsChangeLanguageEvent event, Emitter<SettingsState> emit) async {
    _playerManager.playWhenClick();
    final languageCode =
        LocalizedApp.of(event.context).delegate.currentLocale.languageCode;
    var language = languageCode == 'en' ? 'vi_VN' : 'en_US';
    emit(SettingsChangeLanguageState());
    await _sharePreferencesManager.saveSettingLanguage(language);
  }

  Future<void> _onSettingsSignInEvent(
      SettingsSignInEvent event, Emitter<SettingsState> emit) async {
    final languageCode =
        LocalizedApp.of(event.context).delegate.currentLocale.languageCode;
    emit(SettingsLoadingState());
    try {
      final credential = event.type == 'facebook'
          ? await _getCredentialFacebookUseCase.call()
          : await _getCredentialGoogleUseCase.call();
      await _auth.signOut();
      final user = await _auth.signInWithCredential(credential!);
      _onSettingsInitialUserEvent(SettingsInitialUserEvent(), emit);
      if (user.additionalUserInfo?.isNewUser == true) {
        _createLessonTodayRecentUseCase.call();
      }
    } on IOException catch (e) {
      emit(SettingsErrorState(
          message: languageCode == 'en'
              ? "No internet connection."
              : "Không có kết nối mạng."));
      debugPrint(e.toString());
    } on FirebaseAuthException catch (e) {
      emit(SettingsErrorState(
          message: languageCode == 'en'
              ? "The account already exists for that email."
              : "Tài khoản đã được liên kết trước đó."));
      debugPrint(e.toString());
    } finally {
      if (event.type == 'facebook') {
        _facebookSignOutUseCase.signOut();
      } else {
        _googleSignOutUseCase.signOut();
      }
    }
  }

  Future<void> _onSettingContactEvent(
      SettingContactEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    final languageCode =
        LocalizedApp.of(event.context).delegate.currentLocale.languageCode;
    late Uri url;
    if (event.type == 'tel') {
      url = Uri.parse("tel:0355889107");
    } else if (event.type == 'messenger') {
      url = Uri.parse("https://www.facebook.com/messages/t/162601707585814");
    } else if (event.type == 'zalo') {
      url = Uri.parse("https://chat.zalo.me/0355998017");
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      emit(SettingsErrorState(
          message: languageCode == 'en'
              ? "Unable to open the link."
              : "Không thể mở định dạng liên hệ."));
    }
  }

  Future<void> _onSettingsLinkAccountEvent(
      SettingsLinkAccountEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    final languageCode =
        LocalizedApp.of(event.context).delegate.currentLocale.languageCode;
    try {
      final credential = event.type == 'facebook'
          ? await _getCredentialFacebookUseCase.call()
          : await _getCredentialGoogleUseCase.call();
      await _auth.currentUser?.linkWithCredential(credential!);
      _onSettingsInitialUserEvent(SettingsInitialUserEvent(), emit);
    } on IOException catch (e) {
      emit(SettingsErrorState(
          message: languageCode == 'en'
              ? "No internet connection."
              : "Không có kết nối mạng."));
      debugPrint(e.toString());
    } on FirebaseAuthException catch (e) {
      emit(SettingsErrorState(
          message: languageCode == 'en'
              ? "The account already exists for that email."
              : "Tài khoản đã được liên kết trước đó."));
      debugPrint(e.toString());
    } finally {
      if (event.type == 'facebook') {
        _facebookSignOutUseCase.signOut();
      } else {
        _googleSignOutUseCase.signOut();
      }
    }
  }

  Future<void> _onSettingsInitialVolumeEvent(
      SettingsInitialVolumeEvent event, Emitter<SettingsState> emit) async {
    final double volume =
        await _sharePreferencesManager.getSettingVolume() ?? 1.0;
    emit(SettingsChangeVolumeState(volume: volume));
  }

  void _onSettingsInitialUserEvent(
      SettingsInitialUserEvent event, Emitter<SettingsState> emit) {
    var user = _auth.currentUser;
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
    _playerManager.setVolume(volume);
    _sharePreferencesManager.saveSettingVolume(volume);
  }
}
