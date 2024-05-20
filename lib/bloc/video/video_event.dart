part of 'video_bloc.dart';

@immutable
sealed class VideoEvent {}


final class GetListVideoEvent extends VideoEvent{
  final BuildContext context;
  GetListVideoEvent(this.context);
}
