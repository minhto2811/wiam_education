part of 'video_bloc.dart';

@immutable
sealed class VideoState {}

final class VideoInitialState extends VideoState {}

final class VideoLoadingState extends VideoState {}

final class VideoCompletedState extends VideoState {
  final List<Video> videos;
  final String? error;

  VideoCompletedState(this.videos, this.error);
}
