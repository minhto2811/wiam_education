part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {}

class GetQuestionByIdEvent extends QuestionEvent {
  GetQuestionByIdEvent(this.id);

  final String id;
}

final class ReadQuestionEvent extends QuestionEvent {
  final String url;

  ReadQuestionEvent({required this.url});
}

final class CheckAnswerEvent extends QuestionEvent {
  final String lessonId;
  final String answer;
  final String correctAnswer;
  final BuildContext context;
  CheckAnswerEvent({required this.correctAnswer,required this.answer,required this.lessonId, required this.context});
}
