import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../data/models/question.dart';
import '../../data/repositories/question.dart';
import '../../services/player_manager.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(QuestionInitialState()) {
    on<GetQuestionByIdEvent>(_getQuestionById);
    on<ReadQuestionEvent>(_playQuestion);
    on<CheckAnswerEvent>(_checkAnswer);
  }

  Future<void> _getQuestionById(
      GetQuestionByIdEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoadingState());
    var questionRepo = QuestionRepo();
    try {
      final question = await questionRepo.getQuestionById(event.id);
      emit(QuestionCompletedState(question, null));
      if (question != null) PlayerManager().playFromUrl(question.audio);
    } catch (e) {
      debugPrint(e.toString());
      emit(QuestionCompletedState(null, e.toString()));
    }
  }

  void _playQuestion(ReadQuestionEvent event, Emitter<QuestionState> emit) {
    PlayerManager().playFromUrl(event.url);
    emit(QuestionInitialState());
  }

  void _checkAnswer(CheckAnswerEvent event, Emitter<QuestionState> emit) {
    var answer = event.answer;
    var correctAnswer = event.correctAnswer;
    var isCorrect = answer == correctAnswer;
    if (isCorrect) {
      PlayerManager().playCorrectAnswer();
    } else {
      PlayerManager().playWrongAnswer();
    }
    emit(QuestionCheckResultState(isCorrect, correctAnswer));

  }
}
