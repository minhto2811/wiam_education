import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/di/app_module.dart';
import 'package:wiam/res/color.dart';

import '../../../bloc/home/topic_bloc.dart';
import '../../../data/models/topic.dart';
import '../../topic/topic_detail.dart';

class ListLesson extends StatefulWidget {
  final void Function(String route, BuildContext context, Topic? data) onTap;

  const ListLesson({super.key, required this.onTap});

  @override
  State<ListLesson> createState() => _ListLesson();
}

class _ListLesson extends State<ListLesson> {
  final TopicBloc _topicBloc = getIt<TopicBloc>();

  @override
  initState() {
    _topicBloc.add(
        TopicLoadingEvent(startAfterDoc: null, limit: 15, context: context));
    super.initState();
  }

  @override
  dispose() {
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
            child: CircularProgressIndicator(
              color: color_main,
            ),
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
  final void Function(String route, BuildContext context, Topic? data) onTap;

  const LessonItem({super.key, required this.onTap, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      color: const Color(0xFF5AC2C1),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        onTap: () => onTap(TopicDetailScreen.route, context, topic),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(topic.title,
              style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          subtitle: Text('${translate('num_lesson')} ${topic.countLesson}',
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
