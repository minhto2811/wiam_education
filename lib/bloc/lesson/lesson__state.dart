part of 'lesson__bloc.dart';

@immutable
sealed class LessonState {}

final class LessonInitialState extends LessonState {}

final class LessonLoadingState extends LessonState {}

final class LessonCompletedState extends LessonState {
  final String? error;
  final List<Lesson> lessons;

  LessonCompletedState({required this.lessons, required this.error});
}
