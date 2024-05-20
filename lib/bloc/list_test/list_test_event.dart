part of 'list_test_bloc.dart';

@immutable
sealed class ListTestEvent {}


final class ListTestInitialEvent extends ListTestEvent {
  final BuildContext context;
  ListTestInitialEvent(this.context);
}
