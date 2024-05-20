part of 'list_test_bloc.dart';

@immutable
sealed class ListTestState {}

final class ListTestInitialState extends ListTestState {}

final class ListTestLoadingState extends ListTestState {}

final class ListTestCompletedState extends ListTestState {
  final String? error;
  final List<Test> tests;

  ListTestCompletedState(this.tests, this.error);
}
