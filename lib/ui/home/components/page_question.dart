import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/di/app_module.dart';

import '../../../bloc/question/question_bloc.dart';
import '../../../services/player_manager.dart';
import 'lesson_today.dart';

class PageQuestion extends StatefulWidget {
  final String lessonId;
  final void Function(int page) onClick;
  const PageQuestion(
      {super.key, required this.onClick, required this.lessonId});

  @override
  State<PageQuestion> createState() => _PageQuestionState();
}

class _PageQuestionState extends State<PageQuestion> {
  final QuestionBloc _questionBloc = getIt<QuestionBloc>();
  String _myAnswer = '';

  @override
  void initState() {
    _questionBloc.add(GetQuestionByIdEvent(widget.lessonId));

    super.initState();
  }

  @override
  void dispose() {
    _questionBloc.close();
    super.dispose();
  }

  void chooseAnswer(String answer) {
    getIt<PlayerManager>().playWhenClick();
    setState(() {
      _myAnswer = answer;
    });
  }

  void checkQuestion(String correctAnswer) {
    getIt<PlayerManager>().playWhenClick();
    _questionBloc.add(CheckAnswerEvent(correctAnswer: correctAnswer,answer:  _myAnswer,lessonId:widget.lessonId,context: context));
  }

  void closeBottomSheet() {
    getIt<PlayerManager>().playWhenClick();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionBloc, QuestionState>(
      bloc: _questionBloc,
      buildWhen: (previous, current) => current is! QuestionInitialState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is QuestionLoadingState) {
          return MyPlaceHolder(
              message: translate('lesson_today.loading'),
              image: 'assets/animations/bird_animation.json');
        } else if (state is QuestionCompletedState) {
          if (state.question != null) {
            return Column(
              children: [
                Text(
                  state.question!.question,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  flex: 1,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 6 / 2),
                    shrinkWrap: true,
                    itemCount: state.question!.answers.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final answer = state.question!.answers[index];
                      return ElevatedButton(
                        onPressed: () => chooseAnswer(answer),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _myAnswer == answer
                              ? Colors.green
                              : Colors.grey.shade300,
                          foregroundColor:
                              _myAnswer == answer ? Colors.white : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: Text(answer),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => widget.onClick(0),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label:  Text(translate('lesson_today.button.back')),
                    ),
                    ElevatedButton.icon(
                      onPressed: _myAnswer.isEmpty
                          ? null
                          : () => checkQuestion(state.question!.correctAnswer),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(translate('lesson_today.button.send')),
                    ),
                  ],
                )
              ],
            );
          }
          return MyPlaceHolder(
              message: translate('lesson_today.error'),
              image: 'assets/animations/cat_4_animation.json');
        } else if (state is QuestionCheckResultState) {
          return Stack(children: [
            Center(
              child: Lottie.asset(state.asset,
                  fit: BoxFit.cover, frameRate: FrameRate.max),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    state.message,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: closeBottomSheet,
                    child: Text(translate('lesson_today.button.finish')),
                  ),
                ],
              ),
            ),
          ]);
        }
        return const SizedBox();
      },
    );
  }
}
