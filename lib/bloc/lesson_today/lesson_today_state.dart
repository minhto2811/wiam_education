part of 'lesson_today_bloc.dart';

@immutable
sealed class LessonTodayState {}

final class LessonTodayInitialState extends LessonTodayState {}

final class LessonTodayLoadingState extends LessonTodayState {}

final class LessonTodayCompletedState extends LessonTodayState {
  final LessonToday? lesson;
  final String? error;
  LessonTodayCompletedState(this.lesson, this.error);
}

