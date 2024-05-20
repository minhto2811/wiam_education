import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';

class ResultDialog extends StatelessWidget {
  final String _title;

  const ResultDialog(this._title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(_title),
      titleTextStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.black
      ),
      actions: [
        TextButton(
          onPressed: () {
            getIt<PlayerManager>().playWhenClick();
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: Text(translate('seen_answer')),
        )
      ],
    );
  }
}
