part of 'topic_bloc.dart';

@immutable
sealed class TopicState {}

final class TopicInitialState extends TopicState {}

final class TopicLoadingSate extends TopicState {}

final class TopicCompletedState extends TopicState {
  final String? error;
  final List<Topic> topics;

  TopicCompletedState(this.error, this.topics);
}
