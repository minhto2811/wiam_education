import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/di/app_module.dart';

import '../../bloc/question/question_bloc.dart';
import '../../services/player_manager.dart';
import 'lesson_today.dart';

class PageQuestion extends StatefulWidget {
  final String questionId;
  final void Function(int page) onClick;

  const PageQuestion(
      {super.key, required this.questionId, required this.onClick});

  @override
  State<PageQuestion> createState() => _PageQuestionState();
}

class _PageQuestionState extends State<PageQuestion> {
  final QuestionBloc _questionBloc = getIt<QuestionBloc>();
  String _myAnswer = '';

  @override
  void initState() {
    _questionBloc.add(GetQuestionByIdEvent(widget.questionId));
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
    _questionBloc.add(CheckAnswerEvent(correctAnswer, _myAnswer));
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
          return const MyPlaceHolder(
              message: 'Hãy chờ chút nhé...',
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
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 4 / 1),
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
                      label: const Text('Quay lại'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _myAnswer.isEmpty
                          ? null
                          : () => checkQuestion(state.question!.correctAnswer),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Gửi câu trả lời'),
                    ),
                  ],
                )
              ],
            );
          }
          return const MyPlaceHolder(
              message: 'Đã xảy ra lỗi...',
              image: 'assets/animations/cat_4_animation.json');
        } else if (state is QuestionCheckResultState) {
          var message = state.isCorrect
              ? 'Tuyệt vời, câu trả lời của bạn hoàn toàn chính xác!'
              : 'Câu trả lời của bạn sai rồi, đáp án đúng phải là ${state.correctAnswer}.';
          var sourceAnim = state.isCorrect
              ? 'assets/animations/firework_animation.json'
              : 'assets/animations/sad_animation.json';
          return Stack(children: [
            Center(
              child: Lottie.asset(sourceAnim,
                  fit: BoxFit.cover, frameRate: FrameRate.max),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: closeBottomSheet,
                    child: const Text('Kết thúc'),
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
