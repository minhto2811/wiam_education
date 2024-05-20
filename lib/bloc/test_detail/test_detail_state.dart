part of 'test_detail_bloc.dart';

@immutable
sealed class TestDetailState {}

final class TestDetailInitialState extends TestDetailState {}

final class TestDetailLoadingState extends TestDetailState {}

final class TestDetailCompletedState extends TestDetailState {
  final List<Question> questions;
  final String? error;

  TestDetailCompletedState(this.questions, this.error);
}

final class TestDetailResultState extends TestDetailState{
  final String title;
  TestDetailResultState(this.title);
}