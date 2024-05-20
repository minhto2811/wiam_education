part of 'test_detail_bloc.dart';

@immutable
sealed class TestDetailEvent {}

final class GetListQuestionByTestIdEvent extends TestDetailEvent {
  final String testId;
  GetListQuestionByTestIdEvent(this.testId);
}

final class CaculateScoreEvent extends TestDetailEvent {
  final Map<int,bool> answers;
  final BuildContext context;
  CaculateScoreEvent(this.answers, this.context);
}

