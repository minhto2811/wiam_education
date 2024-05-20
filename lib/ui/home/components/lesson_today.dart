import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/bloc/lesson_today/lesson_today_bloc.dart';
import 'package:wiam/data/models/lesson_today.dart';
import 'package:wiam/di/app_module.dart';
import 'package:wiam/ui/home/components/page_content.dart';
import 'package:wiam/ui/home/components/page_question.dart';

import '../../../services/player_manager.dart';

class LessonTodayPage extends StatefulWidget {
  const LessonTodayPage({super.key});

  @override
  State<LessonTodayPage> createState() => _LessonTodayPageState();
}

class _LessonTodayPageState extends State<LessonTodayPage> {
  final LessonTodayBloc _lessonTodayBloc = getIt<LessonTodayBloc>();

  @override
  void initState() {
    _lessonTodayBloc.add(LessonTodayInitialEvent(context));
    super.initState();
  }

  @override
  void dispose() {
    _lessonTodayBloc.close();
    getIt<PlayerManager>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: BlocConsumer<LessonTodayBloc, LessonTodayState>(
            bloc: _lessonTodayBloc,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LessonTodayLoadingState) {
                return MyPlaceHolder(
                    message: translate('lesson_today.loading'),
                    image: 'assets/animations/bird_animation.json');
              } else if (state is LessonTodayCompletedState) {
                if (state.lesson != null) {
                  return ShowLessonToday(
                    lessonTodayBloc: _lessonTodayBloc,
                    lessonToday: state.lesson!,
                  );
                }
                return MyPlaceHolder(
                    message: translate('lesson_today.error'),
                    image: 'assets/animations/cat_4_animation.json');
              }
              return const SizedBox();
            }));
  }
}

class ShowLessonToday extends StatefulWidget {
  final LessonToday lessonToday;
  final LessonTodayBloc lessonTodayBloc;

  const ShowLessonToday(
      {super.key, required this.lessonToday, required this.lessonTodayBloc});

  @override
  State<ShowLessonToday> createState() => _ShowLessonTodayState();
}

class _ShowLessonTodayState extends State<ShowLessonToday> {
  void onClick(int page) {
    getIt<PlayerManager>().playWhenClick();
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 400), curve: Curves.ease);
  }

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 28.0, bottom: 16.0),
      // EdgeInsets.all(32.0),
      child: Stack(children: [
        Column(
          children: [
            CircleAvatar(
              radius: 70.0,
              backgroundImage: NetworkImage(widget.lessonToday.image),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.lessonToday.title,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              flex: 1,
              child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PageContent(
                        description: widget.lessonToday.description,
                        onClick: onClick),
                    PageQuestion(
                        lessonId: widget.lessonToday.id,
                        onClick: onClick),
                  ]),
            ),
          ],
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: InkWell(
            onTap: () {
              widget.lessonTodayBloc
                  .add(ReadDescriptionEvent(widget.lessonToday.audio));
            },
            child: const Image(
              image: AssetImage('assets/images/3d-speaker.png'),
              width: 50.0,
              height: 50.0,
            ),
          ),
        )
      ]),
    );
  }
}

class MyPlaceHolder extends StatelessWidget {
  final String message;
  final String image;

  const MyPlaceHolder({super.key, required this.message, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(image,
            width: 180.0, height: 180.0, frameRate: FrameRate.max),
        Text(
          message,
          style: const TextStyle(fontSize: 16.0),
        )
      ],
    );
  }
}
