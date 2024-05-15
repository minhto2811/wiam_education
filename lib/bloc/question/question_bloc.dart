import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/question.dart';
import '../../data/repositories/question.dart';
import '../../services/player_manager.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final QuestionRepository questionRepo;
  final PlayerManager playerManager;

  QuestionBloc({required this.questionRepo, required this.playerManager})
      : super(QuestionInitialState()) {
    on<GetQuestionByIdEvent>(_getQuestionById);
    on<ReadQuestionEvent>(_playQuestion);
    on<CheckAnswerEvent>(_checkAnswer);
  }

  Future<void> _getQuestionById(
      GetQuestionByIdEvent event, Emitter<QuestionState> emit) async {
    emit(QuestionLoadingState());
    try {
      final question = await questionRepo.getQuestionById(event.id);
      emit(QuestionCompletedState(question, null));
      if (question != null) playerManager.playFromUrl(question.audio);
    } catch (e) {
      debugPrint(e.toString());
      emit(QuestionCompletedState(null, e.toString()));
    }
  }

  void _playQuestion(ReadQuestionEvent event, Emitter<QuestionState> emit) {
    playerManager.playFromUrl(event.url);
    emit(QuestionInitialState());
  }

  void _checkAnswer(CheckAnswerEvent event, Emitter<QuestionState> emit) {
    var answer = event.answer;
    var correctAnswer = event.correctAnswer;
    var isCorrect = answer == correctAnswer;
    if (isCorrect) {
      playerManager.playCorrectAnswer();
    } else {
      playerManager.playWrongAnswer();
    }
    emit(QuestionCheckResultState(isCorrect, correctAnswer));
  }
}
