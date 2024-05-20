import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../bloc/video/video_bloc.dart';
import '../../di/app_module.dart';
import '../../services/player_manager.dart';
import '../home/components/lesson_today.dart';
import 'components/video_item.dart';

class ForYouScreen extends StatelessWidget {
  static const route = '/for_you';

  const ForYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('extend.for_me')),
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
      body: const ForYouPage(),
    );
  }
}

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {
  final VideoBloc _videoBloc = getIt<VideoBloc>();

  @override
  void initState() {
    _videoBloc.add(GetListVideoEvent(context));
    super.initState();
  }

  @override
  void dispose() {
    _videoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoBloc, VideoState>(
        bloc: _videoBloc,
        listenWhen: (previous, current) => current is VideoCompletedState,
        listener: (context, state) {
          if (state is VideoCompletedState && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          if (state is VideoLoadingState) {
            return Center(
              child: MyPlaceHolder(
                  message: translate('lesson_today.loading'),
                  image: 'assets/animations/bird_animation.json'),
            );
          } else if (state is VideoCompletedState) {
            if (state.videos.isEmpty) {
              return Center(
                child: MyPlaceHolder(
                    message: translate('lesson_today.empty'),
                    image: 'assets/animations/bird_animation.json'),
              );
            }
            return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, index) => VideoItem(state.videos[index]),
                itemCount: state.videos.length);
          }
          return const SizedBox();
        });
  }
}
