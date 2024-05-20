import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/data/models/question.dart';
import 'package:wiam/usecase/question/get_list_question_by_id_test_use_case.dart';

part 'test_detail_event.dart';
part 'test_detail_state.dart';

class TestDetailBloc extends Bloc<TestDetailEvent, TestDetailState> {
  final GetListQuestionByIdTestUseCase _getListQuestionByIdTestUseCase;

  TestDetailBloc(this._getListQuestionByIdTestUseCase)
      : super(TestDetailInitialState()) {
    on<GetListQuestionByTestIdEvent>(_getListQuestion);
    on<CaculateScoreEvent>(_onCaculateScoreEvent);
  }

  Future<void> _onCaculateScoreEvent(
      CaculateScoreEvent event, Emitter<TestDetailState> emit) async {
    int max = event.answers.length;
    event.answers.removeWhere((key, value) => value == false);
    int score = event.answers.length;
    final locale = LocalizedApp.of(event.context).delegate.currentLocale;
    String title = '';
    if (locale.languageCode == 'en') {
      title = "You got $score/$max questions correct.";
    } else if (locale.languageCode == 'vi') {
      title = "Bạn đã đúng $score/$max câu hỏi.";
    }
    emit(TestDetailResultState(title));
  }

  Future<void> _getListQuestion(
      GetListQuestionByTestIdEvent event, Emitter<TestDetailState> emit) async {
    emit(TestDetailLoadingState());
    try {
      final questions =
          await _getListQuestionByIdTestUseCase.call(event.testId);
      emit(TestDetailCompletedState(questions, null));
    } catch (e) {
      print(e);
      emit(TestDetailCompletedState(const [], e.toString()));
    }
  }
}
