part of 'splash_bloc.dart';

@immutable
sealed class SplashEvent {}

final class SplashInitialEvent extends SplashEvent {
  final BuildContext context;

  SplashInitialEvent(this.context);
}
