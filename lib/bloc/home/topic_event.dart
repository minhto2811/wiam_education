part of 'topic_bloc.dart';

@immutable
sealed class TopicEvent {}

final class TopicLoadingEvent extends TopicEvent{
  final  DocumentSnapshot<Object?>? startAfterDoc;
  final int limit;
  TopicLoadingEvent(this.startAfterDoc, this.limit);
}


