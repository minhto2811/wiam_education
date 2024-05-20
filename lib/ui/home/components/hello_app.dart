import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class HelloApp extends StatelessWidget {
  const HelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50.0,
        ),
        Text(
          translate('hello'),
          style: const TextStyle(
              fontSize: 24.0, fontFamily: 'Bungee', color: Colors.deepOrange),
        ),
        Text(
          translate('practice_for_today'),
          style: const TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ],
    );
  }
}