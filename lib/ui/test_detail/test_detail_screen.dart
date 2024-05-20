import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/bloc/test_detail/test_detail_bloc.dart';
import 'package:wiam/ui/home/components/lesson_today.dart';
import 'package:wiam/ui/test_detail/components/result_dialog.dart';

import '../../data/models/test.dart';
import '../../di/app_module.dart';
import '../../services/player_manager.dart';
import 'components/list_question.dart';

class TestDetailScreen extends StatelessWidget {
  static const route = '/test_detail';

  const TestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final test = ModalRoute.of(context)!.settings.arguments as Test;
    return Scaffold(
      appBar: AppBar(
        title: Text(test.title),
        titleTextStyle: const TextStyle(fontFamily: 'Bungee', fontSize: 20.0),
        backgroundColor: const Color(0xFF5AC2C1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            getIt<PlayerManager>().playWhenClick();
            Navigator.pop(context);
          },
        ),
      ),
      body: TestDetailBody(test.id),
    );
  }
}

class TestDetailBody extends StatefulWidget {
  final String _testId;

  const TestDetailBody(
    this._testId, {
    super.key,
  });

  @override
  State<TestDetailBody> createState() => _TestDetailBodyState();
}

class _TestDetailBodyState extends State<TestDetailBody> {
  final TestDetailBloc _testDetailBloc = getIt<TestDetailBloc>();

  @override
  void initState() {
    _testDetailBloc.add(GetListQuestionByTestIdEvent(widget._testId));
    super.initState();
  }

  @override
  void dispose() {
    _testDetailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TestDetailBloc, TestDetailState>(
      bloc: _testDetailBloc,
      listenWhen: (previous, current) =>
          current is TestDetailCompletedState ||
          current is TestDetailResultState,
      listener: (context, state) {
        if (state is TestDetailCompletedState && state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }else if(state is TestDetailResultState){
          showDialog(context: context, builder: (context) => ResultDialog(state.title));
        }
      },
      buildWhen: (previous, current) => current is! TestDetailResultState,
      builder: (context, state) {
        if (state is TestDetailLoadingState) {
          return Center(
            child: MyPlaceHolder(
                message: translate('lesson_today.loading'),
                image: 'assets/animations/bird_animation.json'),
          );
        } else if (state is TestDetailCompletedState) {
          if (state.questions.isEmpty) {
            return Center(
              child: MyPlaceHolder(
                  message: translate('lesson_today.empty'),
                  image: 'assets/animations/bird_animation.json'),
            );
          }
          return ListQuestion(state.questions,
              (map) => _testDetailBloc.add(CaculateScoreEvent(map,context)));
        }
        return const SizedBox();
      },
    );
  }
}
