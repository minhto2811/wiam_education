

import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final String description;
  final void Function(int page) onClick;

  const PageContent(
      {super.key, required this.description, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          flex: 1,
          child: Text(
            description,
            style: const TextStyle(fontSize: 16.0),
            maxLines: 8,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          onPressed: () => onClick(1),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: const Text('Trả lời câu hỏi'),
        )
      ],
    );
  }
}