import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/models/question.dart';
import '../../services/player_manager.dart';
import '../../usecase/lesson_today/insert_id_lesson_today_recent_use_case.dart';
import '../../usecase/question/get_question_by_id_use_case.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final PlayerManager _playerManager;
  final GetQuestionByIdUseCase _getQuestionByIdUseCase;
  final InsertIdLessonTodayRecentUseCase _insertIdLessonTodayUseCase;

  QuestionBloc(
    this._playerManager,
    this._getQuestionByIdUseCase,
    this._insertIdLessonTodayUseCase,
  ) : super(QuestionInitialState()) {
    on<GetQuestionByIdEvent>(_getQuestionById);
    on<ReadQuestionEvent>(_playQuestion);
    on<CheckAnswerEvent>(_checkAnswer);
  }

  Future<void> _getQuestionById(
      GetQuestionByIdEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoadingState());
    try {
      final question = await _getQuestionByIdUseCase.call(event.id);
      emit(QuestionCompletedState(question, null));
      if (question != null) _playerManager.playFromUrl(question.audio!);
    } catch (e) {
      debugPrint(e.toString());
      emit(QuestionCompletedState(null, e.toString()));
    }
  }

  void _playQuestion(ReadQuestionEvent event, Emitter<QuestionState> emit) {
    _playerManager.playFromUrl(event.url);
    emit(QuestionInitialState());
  }

  Future<void> _checkAnswer(
      CheckAnswerEvent event, Emitter<QuestionState> emit) async {
    var answer = event.answer;
    var correctAnswer = event.correctAnswer;
    var isCorrect = answer == correctAnswer;
    var message = "";
    var asset = "";
    var languageCode =
        LocalizedApp.of(event.context).delegate.currentLocale.languageCode;
    var isEnglish = languageCode == 'en';
    if (isCorrect) {
      _playerManager.playCorrectAnswer();
      message = isEnglish
          ? 'Great, your answer is absolutely correct!'
          : 'Tuyệt vời, câu trả lời của bạn hoàn toàn chính xác!';
      asset = 'assets/animations/firework_animation.json';
    } else {
      _playerManager.playWrongAnswer();
      message = isEnglish
          ? 'Your answer is wrong, the correct answer should be $correctAnswer.'
          : 'Câu trả lời của bạn sai rồi, đáp án đúng phải là $correctAnswer.';
      asset = 'assets/animations/sad_animation.json';
    }
    emit(QuestionCheckResultState(message: message, asset: asset));
    try {
      _insertIdLessonTodayUseCase.call(event.lessonId);
    } catch (e) {
        print(e);
    }
  }
}
