import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/bloc/lesson/lesson__bloc.dart';
import 'package:wiam/data/models/topic.dart';

import '../../data/models/lesson.dart';
import '../../di/app_module.dart';
import '../../services/player_manager.dart';
import '../home/components/lesson_today.dart';

class TopicDetailScreen extends StatelessWidget {
  static const route = '/topic_detail';

  const TopicDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Topic topic = ModalRoute.of(context)!.settings.arguments as Topic;
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
        titleTextStyle: const TextStyle(fontFamily: 'Bungee', fontSize: 20.0),
        backgroundColor: const Color(0xFF5AC2C1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            getIt<PlayerManager>().playWhenClick();
            Navigator.pop(context);
          },
        ),
      ),
      body: TopicBody(topicId: topic.id),
    );
  }
}

class TopicBody extends StatefulWidget {
  final String topicId;

  const TopicBody({super.key, required this.topicId});

  @override
  State<TopicBody> createState() => _TopicBodyState();
}

class _TopicBodyState extends State<TopicBody> {
  final LessonBloc _lessonBloc = getIt<LessonBloc>();
  final List<Lesson> _list = [];

  @override
  void initState() {
    _lessonBloc.add(GetListLessonEvent(
        topicId: widget.topicId, lastDoc: null, limit: 5, false));
    super.initState();
  }

  @override
  void dispose() {
    _lessonBloc.close();
    getIt<PlayerManager>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonBloc, LessonState>(
      bloc: _lessonBloc,
      listenWhen: (previous, current) => current is LessonCompletedState,
      listener: (context, state) {
        if (state is LessonCompletedState) {
          if (state.error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (state.lessons.isNotEmpty) {
            _list.addAll(state.lessons);
            getIt<PlayerManager>().playFromUrl(_list[0].audio2);
          }
        }
      },
      buildWhen: (previous, current) =>
          current is LessonCompletedState || current is LessonLoadingState,
      builder: (context, state) {
        if (state is LessonLoadingState) {
          return Center(
            child: MyPlaceHolder(
                message: translate('lesson_today.loading'),
                image: 'assets/animations/bird_animation.json'),
          );
        } else if (state is LessonCompletedState) {
          if (state.lessons.isEmpty) {
            return Center(
              child: MyPlaceHolder(
                  message: translate('lesson_today.empty'),
                  image: 'assets/animations/bird_animation.json'),
            );
          }
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
                onPageChanged: (value) {
                  getIt<PlayerManager>()
                      .playFromUrl(state.lessons[value].audio2);
                },
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return PageItem(lesson: _list[index]);
                }),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class PageItem extends StatelessWidget {
  final Lesson lesson;

  const PageItem({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_3.jpg'),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Stack(children: [
              Positioned(
                top: 170.0,
                left: -35.0,
                child: Lottie.asset(
                  'assets/animations/bang_animation.json',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  frameRate: FrameRate.max,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3.5,
                left: MediaQuery.of(context).size.width * 0.19,
                child: Image.network(
                  lesson.image,
                  height: MediaQuery.of(context).size.width * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
            ]),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width * 0.22,
            child: Text(
              lesson.title,
              style: const TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'Bungee',
                  color: Colors.deepOrangeAccent),
            ),
          ),
          Positioned(
            top: 170.0,
            left: MediaQuery.of(context).size.width * 0.265,
            child: Lottie.asset(
              'assets/animations/teacher_animation.json',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              frameRate: FrameRate.max,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(translate('swipe'),style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30.0
                ),),
                Lottie.asset(
                  'assets/animations/swipe_animation.json',
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  frameRate: FrameRate.max,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
