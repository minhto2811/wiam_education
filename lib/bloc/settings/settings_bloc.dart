import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/repositories/lesson_today.dart';
import '../../services/player_manager.dart';
import '../../services/sharepreferences_manager.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final FirebaseAuth auth;
  final FacebookAuth facebookAuth;
  final GoogleSignIn googleSignIn;
  final PlayerManager playerManager;
  final LessonTodayRepository lessonTodayRepo;

  SettingsBloc(
      {required this.auth,
      required this.facebookAuth,
      required this.googleSignIn,
      required this.playerManager,
      required this.lessonTodayRepo})
      : super(SettingsInitialState()) {
    on<SettingsInitialVolumeEvent>(_onSettingsInitialVolumeEvent);
    on<SettingsInitialUserEvent>(_onSettingsInitialUserEvent);
    on<SettingsChangeVolumeLevelEvent>(_onSettingsChangeVolumeLevelEvent);
    on<SettingsLinkAccountEvent>(_onSettingsLinkAccountEvent);
    on<SettingContactEvent>(_onSettingContactEvent);
    on<SettingsSignInEvent>(_onSettingsSignInEvent);
  }

  Future<void> _onSettingsSignInEvent(
      SettingsSignInEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final credential = event.type == 'facebook'
          ? await _getCredentialFacebook()
          : await _getCredentialGoogle();
      await auth.signOut();
      final user = await auth.signInWithCredential(credential!);
      _onSettingsInitialUserEvent(SettingsInitialUserEvent(), emit);
      if (user.additionalUserInfo?.isNewUser == true) {
        lessonTodayRepo.createLessonTodayRecent();
      }
    } on IOException catch (e) {
      emit(const SettingsErrorState(message: "Không có kết nối mạng."));
      debugPrint(e.toString());
    } on FirebaseAuthException catch (e) {
      emit(const SettingsErrorState(
          message: "Tài khoản đã được liên kết trước đó."));
      debugPrint(e.toString());
    } finally {
      if (event.type == 'facebook') {
        facebookAuth.logOut();
      } else {
        googleSignIn.signOut();
      }
    }
  }

  Future<void> _onSettingContactEvent(
      SettingContactEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
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
      emit(const SettingsErrorState(
          message: "Không thể mở định dạng liên hệ."));
    }
  }

  Future<void> _onSettingsLinkAccountEvent(
      SettingsLinkAccountEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadingState());
    try {
      final credential = event.type == 'facebook'
          ? await _getCredentialFacebook()
          : await _getCredentialGoogle();
      await auth.currentUser?.linkWithCredential(credential!);
      _onSettingsInitialUserEvent(SettingsInitialUserEvent(), emit);
    } on IOException catch (e) {
      emit(const SettingsErrorState(message: "Không có kết nối mạng."));
      debugPrint(e.toString());
    } on FirebaseAuthException catch (e) {
      emit(const SettingsErrorState(
          message: "Tài khoản đã được liên kết trước đó."));
      debugPrint(e.toString());
    } finally {
      if (event.type == 'facebook') {
        facebookAuth.logOut();
      } else {
        googleSignIn.signOut();
      }
    }
  }

  Future<OAuthCredential> _getCredentialFacebook() async {
    final LoginResult loginResult = await facebookAuth.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return facebookAuthCredential;
  }

  Future<OAuthCredential?> _getCredentialGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return credential;
  }

  Future<void> _onSettingsInitialVolumeEvent(
      SettingsInitialVolumeEvent event, Emitter<SettingsState> emit) async {
    final double volume =
        await SharePreferencesManager.getSetting(SettingKey.volume);
    emit(SettingsChangeVolumeState(volume: volume));
  }

  void _onSettingsInitialUserEvent(
      SettingsInitialUserEvent event, Emitter<SettingsState> emit) {
    var user = auth.currentUser;
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
    playerManager.setVolume(volume);
    SharePreferencesManager.saveSetting(SettingKey.volume, volume);
  }
}
