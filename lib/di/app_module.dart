import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wiam/bloc/home/topic_bloc.dart';
import 'package:wiam/bloc/lesson/lesson__bloc.dart';
import 'package:wiam/bloc/lesson_today/lesson_today_bloc.dart';
import 'package:wiam/bloc/question/question_bloc.dart';
import 'package:wiam/bloc/settings/settings_bloc.dart';
import 'package:wiam/bloc/splash/splash_bloc.dart';
import 'package:wiam/bloc/video/video_bloc.dart';
import 'package:wiam/data/repositories/lesson_today_repository.dart';
import 'package:wiam/data/repositories/question_repository.dart';
import 'package:wiam/data/repositories/topic_repository.dart';
import 'package:wiam/data/repositories/video_repository.dart';
import 'package:wiam/services/player_manager.dart';
import 'package:wiam/services/sharepreferences_manager.dart';
import 'package:wiam/usecase/facebook/facebook_sign_out_use_case.dart';
import 'package:wiam/usecase/facebook/get_credential_facebook_use_case.dart';
import 'package:wiam/usecase/google/get_credential_google_use_case.dart';
import 'package:wiam/usecase/google/google_sign_out_use_case.dart';
import 'package:wiam/usecase/lesson_today/create_lesson_today_recent_use_case.dart';
import 'package:wiam/usecase/lesson_today/delete_list_id_lesson_today_recent_use_case.dart';
import 'package:wiam/usecase/lesson_today/get_lesson_today_use_case.dart';
import 'package:wiam/usecase/lesson_today/get_list_id_lesson_today_recent_use_case.dart';
import 'package:wiam/usecase/lesson_today/insert_id_lesson_today_recent_use_case.dart';
import 'package:wiam/usecase/question/get_question_by_id_use_case.dart';
import 'package:wiam/usecase/video/get_list_video_use_case.dart';

import '../bloc/list_test/list_test_bloc.dart';
import '../bloc/test_detail/test_detail_bloc.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/repositories/test_repository.dart';
import '../usecase/lesson/get_list_lesson_use_case.dart';
import '../usecase/question/get_list_question_by_id_test_use_case.dart';
import '../usecase/test/get_list_test_use_case.dart';
import '../usecase/topic/get_list_topic_use_case.dart';

final getIt = GetIt.instance;

void setup() {
  //spref
  getIt.registerLazySingleton<SharePreferencesManager>(
      () => SharePreferencesManager());

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
      () => QuestionRepositoryImpl(getIt()));
  getIt.registerLazySingleton<TopicRepository>(
      () => TopicRepositoryImpl(getIt()));
  getIt.registerLazySingleton<LessonTodayRepository>(
      () => LessonTodayRepositoryImpl(getIt()));
  getIt.registerLazySingleton<LessonRepository>(
      () => LessonRepositoryImpl(getIt()));
  getIt
      .registerLazySingleton<TestRepository>(() => TestRepositoryImpl(getIt()));

  getIt.registerLazySingleton<VideoRepository>(
      () => VideoRepositoryImpl(getIt()));

  //usecase

  getIt.registerLazySingleton<GetListTopicUseCase>(
      () => GetListTopicUseCase(getIt()));

  getIt.registerLazySingleton<CreateLessonTodayRecentUseCase>(
      () => CreateLessonTodayRecentUseCase(getIt()));

  getIt.registerLazySingleton<DeleteListIdLessonTodayUseCase>(
      () => DeleteListIdLessonTodayUseCase(getIt()));

  getIt.registerLazySingleton<GetLessonTodayUseCase>(
      () => GetLessonTodayUseCase(getIt()));

  getIt.registerLazySingleton<GetListIdLessonTodayRecentUseCase>(
      () => GetListIdLessonTodayRecentUseCase(getIt()));

  getIt.registerLazySingleton<InsertIdLessonTodayRecentUseCase>(
      () => InsertIdLessonTodayRecentUseCase(getIt()));

  getIt.registerLazySingleton<GetQuestionByIdUseCase>(
      () => GetQuestionByIdUseCase(getIt()));

  getIt.registerLazySingleton<GetListLessonUseCase>(
      () => GetListLessonUseCase(getIt()));

  getIt.registerLazySingleton<GetCredentialFacebookUseCase>(
      () => GetCredentialFacebookUseCase(getIt()));

  getIt.registerLazySingleton<FacebookSignOutUseCase>(
      () => FacebookSignOutUseCase(getIt()));

  getIt.registerLazySingleton<GetCredentialGoogleUseCase>(
      () => GetCredentialGoogleUseCase(getIt()));

  getIt.registerLazySingleton<GoogleSignOutUseCase>(
      () => GoogleSignOutUseCase(getIt()));

  getIt.registerLazySingleton<GetListTestUseCase>(
      () => GetListTestUseCase(getIt()));

  getIt.registerLazySingleton<GetListQuestionByIdTestUseCase>(
      () => GetListQuestionByIdTestUseCase(getIt()));

  getIt.registerLazySingleton<GetListVideoUseCase>(
      () => GetListVideoUseCase(getIt()));


  //bloc
  getIt.registerFactory(() => SplashBloc(getIt(), getIt(), getIt(), getIt()));

  getIt.registerFactory(() => SettingsBloc(
      getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt(), getIt()));

  getIt.registerFactory(() => QuestionBloc(getIt(), getIt(), getIt()));
  getIt.registerFactory(
      () => LessonTodayBloc(getIt(), getIt(), getIt(), getIt()));

  getIt.registerFactory(() => TopicBloc(getIt()));
  getIt.registerFactory(() => LessonBloc(getIt()));
  getIt.registerFactory(() => ListTestBloc(getIt()));
  getIt.registerFactory(() => TestDetailBloc(getIt()));
  getIt.registerFactory(() => VideoBloc(getIt()));
}
