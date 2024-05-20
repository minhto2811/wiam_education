import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/res/color.dart';

import '../../../data/models/question.dart';
import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';

class QuestionItem extends StatefulWidget {
  final Question _question;
  final int _index;
  final bool _showAnswer;
  final void Function(bool bool) _onChooseAnswer;

  const QuestionItem(this._question, this._index,
      this._showAnswer, this._onChooseAnswer,
      {super.key});

  @override
  State<QuestionItem> createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
  String _myAnswer = '';

  void chooseAnswer(String answer) {
    getIt<PlayerManager>().playWhenClick();
    setState(() {
      _myAnswer = answer;
    });
    widget._onChooseAnswer(answer == widget._question.correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${translate('question')} ${widget._index + 1}: ${widget._question.question}',
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 6 / 2,
              ),
              itemCount: widget._question.answers.length,
              itemBuilder: (context, index) {
                final answer = widget._question.answers[index];
                return ElevatedButton(
                  onPressed: widget._showAnswer && _myAnswer != ''
                      ? null
                      : () => chooseAnswer(answer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _myAnswer == answer
                        ? color_main
                        : Colors.white,
                    foregroundColor:
                        _myAnswer == answer ? Colors.white : Colors.black,
                    disabledBackgroundColor: widget._showAnswer
                        ? _myAnswer == answer
                            ? widget._question.correctAnswer == _myAnswer
                                ? Colors.green
                                : Colors.red
                            : answer == widget._question.correctAnswer
                                ? Colors.green
                                : Colors.white
                        : _myAnswer == answer
                            ? color_main
                            : Colors.grey.shade300,
                    disabledForegroundColor:
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
        ],
      ),
    );
  }
}
