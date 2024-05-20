part of 'lesson__bloc.dart';

@immutable
sealed class LessonEvent {}

final class GetListLessonEvent extends LessonEvent {
  final String topicId;
  final DocumentSnapshot<Object?>? lastDoc;
  final int limit;
  final bool sortByTitle;

  GetListLessonEvent(this.sortByTitle,
      {required this.lastDoc, required this.limit, required this.topicId});
}
