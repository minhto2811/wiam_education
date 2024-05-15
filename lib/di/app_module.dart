import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wiam/bloc/home/topic_bloc.dart';
import 'package:wiam/bloc/lesson_today/lesson_today_bloc.dart';
import 'package:wiam/bloc/question/question_bloc.dart';
import 'package:wiam/bloc/settings/settings_bloc.dart';
import 'package:wiam/bloc/splash/splash_bloc.dart';
import 'package:wiam/data/repositories/lesson_today.dart';
import 'package:wiam/data/repositories/question.dart';
import 'package:wiam/data/repositories/topic_repo.dart';
import 'package:wiam/services/player_manager.dart';

final getIt = GetIt.instance;

void setup() {
  //player

  getIt.registerSingleton<PlayerManager>(PlayerManager());

  //firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  //fb
  getIt.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);

  //gg
  getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
        serverClientId:
            '1046954227489-6jdbt223engm3v1504q21u8e1t99mgr6.apps.googleusercontent.com',
        scopes: ['email'],
      ));

  //repo
  getIt.registerLazySingleton<QuestionRepository>(
      () => QuestionRepositoryImpl(firestore: getIt()));
  getIt.registerLazySingleton<TopicRepository>(
      () => TopicRepositoryImpl(firestore: getIt()));
  getIt.registerLazySingleton<LessonTodayRepository>(
      () => LessonTodayRepositoryImpl(firestore: getIt()));

  //bloc
  getIt.registerFactory(() => SplashBloc(
      auth: getIt(), playerManager: getIt(), lessonTodayRepo: getIt()));

  getIt.registerFactory(() => SettingsBloc(
        auth: getIt(),
        facebookAuth: getIt(),
        googleSignIn: getIt(),
        playerManager: getIt(),
        lessonTodayRepo: getIt(),
      ));

  getIt.registerFactory(
      () => QuestionBloc(questionRepo: getIt(), playerManager: getIt()));
  getIt.registerFactory(
      () => LessonTodayBloc(lessonTodayRepo: getIt(), playerManager: getIt()));

  getIt.registerFactory(() => TopicBloc(topicRepo: getIt()));
}
