part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitialState extends SplashState {}

final class SplashCheckCompletedState extends SplashState {
}
