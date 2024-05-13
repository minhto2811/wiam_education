part of 'lesson_today_bloc.dart';

@immutable
sealed class LessonTodayEvent {}

final class LessonTodayInitialEvent extends LessonTodayEvent {}


final class ReadDescriptionEvent extends LessonTodayEvent {
  final String audio;

  ReadDescriptionEvent(this.audio);
}