import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../data/models/topic.dart';
import '../../di/app_module.dart';
import '../../services/player_manager.dart';
import 'components/banner_app.dart';
import 'components/category.dart';
import 'components/hello_app.dart';
import 'components/lesson_today.dart';
import 'components/list_lesson.dart';
import 'components/title_app.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_2.jpg"),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                opacity: 0.4)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelloApp(),
              BannerApp(onTap: _newLesson),
              TitleApp(title: translate('title.extend')),
              CategoryMenu(onTap: _onTap),
              TitleApp(title: translate('title.for_kid')),
              ListLesson(onTap: _onTap)
            ],
          ),
        ),
      ),
    );
  }

  void _newLesson(BuildContext context) {
    getIt<PlayerManager>().playWhenClick();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const LessonTodayPage();
        });
  }

  void _onTap(String routeName, BuildContext context, Topic? data) {
    getIt<PlayerManager>().playWhenClick();
    Navigator.pushNamed(context, routeName, arguments: data);
  }
}





