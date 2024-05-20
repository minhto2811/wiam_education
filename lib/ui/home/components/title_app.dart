import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  final String title;

  const TitleApp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 24.0,
            fontFamily: 'Bungee',
            color: Colors.deepOrangeAccent),
      ),
    );
  }
}