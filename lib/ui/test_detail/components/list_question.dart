import 'package:flutter/material.dart';
import 'package:wiam/ui/test_detail/components/question_item.dart';

import '../../../data/models/question.dart';
import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';

class ListQuestion extends StatefulWidget {
  final List<Question> _questions;
  final void Function(Map<int, bool>) _onTap;

  const ListQuestion(this._questions, this._onTap, {super.key});

  @override
  State<ListQuestion> createState() => _ListQuestionState();
}

class _ListQuestionState extends State<ListQuestion> {
  bool _showAnswer = false;
  final Map<int, bool> _answers = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_3.jpg"),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            opacity: 0.4
          )
        ),
        child: Column(
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(20.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget._questions.length,
              itemBuilder: (context, index) => QuestionItem(
                  widget._questions[index], index, _showAnswer, (choose) {
                setState(() {
                  _answers[index] = choose;
                });
              }),
              separatorBuilder: (BuildContext context, int index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    thickness: 1.0,
                  ),
                );
              },
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 10.0,
                disabledBackgroundColor: Colors.grey.shade300,
                textStyle: const TextStyle(
                  fontSize: 20.0
                ),
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
              ),
              onPressed: _answers.length < widget._questions.length
                  ? null
                  : () {
                      getIt<PlayerManager>().playWhenClick();
                      setState(() {
                        _showAnswer = true;
                      });
                      widget._onTap(_answers);
                    },
              child: const Text('Hiển thị đáp án'),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
