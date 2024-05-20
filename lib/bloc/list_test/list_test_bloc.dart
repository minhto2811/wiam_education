import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/models/test.dart';
import '../../usecase/test/get_list_test_use_case.dart';

part 'list_test_event.dart';
part 'list_test_state.dart';

class ListTestBloc extends Bloc<ListTestEvent, ListTestState> {
  final GetListTestUseCase _getListTestUseCase;

  ListTestBloc(this._getListTestUseCase) : super(ListTestInitialState()) {
    on<ListTestInitialEvent>(_getListTest);
  }

  Future<void> _getListTest(
      ListTestInitialEvent event, Emitter<ListTestState> emit) async {
    emit(ListTestLoadingState());
    final locale = LocalizedApp.of(event.context).delegate.currentLocale;
    try {
      final test = await _getListTestUseCase.call(localeToString(locale));
      emit(ListTestCompletedState(test, null));
    } catch (e) {
      emit(ListTestCompletedState(const [], e.toString()));
    }
  }
}
