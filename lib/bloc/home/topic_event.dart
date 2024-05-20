part of 'topic_bloc.dart';

@immutable
sealed class TopicEvent {}

final class TopicLoadingEvent extends TopicEvent {
  final DocumentSnapshot<Object?>? startAfterDoc;
  final int limit;
  final BuildContext context;

  TopicLoadingEvent(
      {required this.startAfterDoc,
      required this.limit,
      required this.context});
}
