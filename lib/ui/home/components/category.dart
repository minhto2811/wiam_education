



import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/ui/for_you/for_you.dart';

import '../../../data/models/topic.dart';
import '../../list_test/list_test_screen.dart';
import '../../settings/settings.dart';

class CategoryMenu extends StatelessWidget {
  final void Function(String route, BuildContext context, Topic? data) onTap;

  const CategoryMenu({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CategoryItem(
            image: 'assets/images/creative-brain.png',
            title: translate('extend.for_me'),
            onTap: () => onTap(ForYouScreen.route, context, null)),
        CategoryItem(
            image: 'assets/images/brain.png',
            title: translate('extend.try_hard'),
            onTap: () => onTap(ListTestScreen.route, context, null)),
        CategoryItem(
            image: 'assets/images/gear.png',
            title: translate('extend.settings'),
            onTap: () => onTap(SettingsScreen.route, context, null)),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String image;
  final String title;
  final void Function() onTap;

  const CategoryItem(
      {super.key,
        required this.image,
        required this.title,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFF5AC2C1),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            onTap: () => onTap(),
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title),
        )
      ],
    );
  }
}