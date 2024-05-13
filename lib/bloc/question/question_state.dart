part of 'question_bloc.dart';

@immutable
sealed class QuestionState {}

final class QuestionInitialState extends QuestionState {}

final class QuestionLoadingState extends QuestionState {}

final class QuestionCompletedState extends QuestionState {
  final Question? question;
  final String? error;

  QuestionCompletedState(this.question, this.error);
}


final class QuestionCheckResultState extends QuestionState{
  final bool isCorrect;
  final String correctAnswer;

  QuestionCheckResultState(this.isCorrect, this.correctAnswer);
}