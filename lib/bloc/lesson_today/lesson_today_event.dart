part of 'lesson_today_bloc.dart';

@immutable
sealed class LessonTodayEvent {}

final class LessonTodayInitialEvent extends LessonTodayEvent {
  final BuildContext context;

  LessonTodayInitialEvent(this.context);
}


final class ReadDescriptionEvent extends LessonTodayEvent {
  final String audio;


  ReadDescriptionEvent(this.audio);
}