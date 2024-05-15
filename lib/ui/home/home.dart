import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/bloc/home/topic_bloc.dart';
import 'package:wiam/ui/settings/settings.dart';

import '../../data/models/topic.dart';
import '../../di/app_module.dart';
import '../../services/player_manager.dart';
import 'lesson_today.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg_2.jpg"),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              opacity: 0.4)),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelloApp(),
              BannerApp(onTap: _newLesson),
              const TitleApp(title: '🚩 Mở rộng'),
              CategoryMenu(onTap: _onTap),
              const TitleApp(title: '📌 Dành cho bé'),
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

  void _onTap(String routeName, BuildContext context) {
    getIt<PlayerManager>().playWhenClick();
    Navigator.pushNamed(context, routeName);
  }
}

class ListLesson extends StatefulWidget {
  final void Function(String route, BuildContext context) onTap;

  const ListLesson({super.key, required this.onTap});

  @override
  State<ListLesson> createState() => _ListLessonState();
}

class _ListLessonState extends State<ListLesson> {
  final TopicBloc _topicBloc = getIt<TopicBloc>();

  @override
  void initState() {
    _topicBloc.add(TopicLoadingEvent(null, 15));
    super.initState();
  }

  @override
  void dispose() {
    _topicBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopicBloc, TopicState>(
      bloc: _topicBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TopicLoadingSate) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TopicCompletedState) {
          return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final topic = state.topics[index];
                return LessonItem(onTap: widget.onTap, topic: topic);
              },
              separatorBuilder: (_, __) => const SizedBox(
                    height: 14.0,
                  ),
              itemCount: state.topics.length);
        }
        return const SizedBox();
      },
    );
  }
}

class LessonItem extends StatelessWidget {
  final Topic topic;
  final void Function(String route, BuildContext context) onTap;

  const LessonItem({super.key, required this.onTap, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      color: const Color(0xFF5AC2C1),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        onTap: () => onTap(topic.id,context),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(topic.title,
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          subtitle: Text('Số lượng bài tập ${topic.countLesson}',
              style: const TextStyle(color: Colors.black)),
          leading: Image.network(
            topic.image,
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
          ),
          trailing: Lottie.asset('assets/animations/cat_3_animation.json',
              frameRate: FrameRate.max, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class CategoryMenu extends StatelessWidget {
  final void Function(String route, BuildContext context) onTap;

  const CategoryMenu({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CategoryItem(
            image: 'assets/images/brain.png',
            title: 'Luyện tập',
            onTap: () => onTap(SettingsScreen.route, context)),
        CategoryItem(
            image: 'assets/images/creative-brain.png',
            title: 'Của tôi',
            onTap: () => onTap(SettingsScreen.route, context)),
        CategoryItem(
            image: 'assets/images/gear.png',
            title: 'Cài đặt',
            onTap: () => onTap(SettingsScreen.route, context)),
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

class HelloApp extends StatelessWidget {
  const HelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50.0,
        ),
        Text(
          'Xin chào!',
          style: TextStyle(
              fontSize: 24.0, fontFamily: 'Bungee', color: Colors.deepOrange),
        ),
        Text(
          'Luyện tập cho ngày hôm nay nào 👶',
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ],
    );
  }
}

class BannerApp extends StatelessWidget {
  final void Function(BuildContext context) onTap;

  const BannerApp({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(context),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
        height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: const DecorationImage(
            image: AssetImage("assets/images/bn_1.jpg"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(4, 10), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Lottie.asset('assets/animations/cat_2_animation.json',
                width: 180.0, height: 180.0, frameRate: FrameRate.max),
            const Positioned(
                top: 30.0,
                right: 100.0,
                child: Text(
                  'Hôm nay',
                  style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontFamily: 'Bungee'),
                )),
            const Positioned(
                top: 70.0,
                right: 90.0,
                child: Text(
                  'Học 📚',
                  style: TextStyle(
                      fontSize: 38.0,
                      color: Colors.deepOrangeAccent,
                      fontFamily: 'Bungee'),
                )),
            const Positioned(
                top: 130.0,
                right: 140.0,
                child: Text(
                  'gì?',
                  style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontFamily: 'Bungee'),
                )),
            AnimatedPositioned(
                duration: const Duration(seconds: 2),
                bottom: -10.0,
                right: 0.0,
                child: Lottie.asset('assets/animations/cat_1_animation.json',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.contain,
                    frameRate: FrameRate.max)),
          ],
        ),
      ),
    );
  }
}
