import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideoScreen extends StatelessWidget {
  static const route = '/play-video';

  const PlayVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String videoUrl = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: PlayVideoBody(
        videoUrl: videoUrl,
      ),
    );
  }
}

class PlayVideoBody extends StatefulWidget {
  final String videoUrl;

  const PlayVideoBody({super.key, required this.videoUrl});

  @override
  State<PlayVideoBody> createState() => PlayVideoBodyState();
}

class PlayVideoBodyState extends State<PlayVideoBody> {
  late FlickManager _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlickManager(
        videoPlayerController:
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)));
    _controller.flickControlManager?.enterFullscreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FlickVideoPlayer(
        flickManager: _controller,
        wakelockEnabledFullscreen: true,
        wakelockEnabled: true,
        flickVideoWithControlsFullscreen: const FlickVideoWithControls(
          videoFit: BoxFit.fill,
          controls: SafeArea(
            child: FlickPortraitControls(),
          ),
        ),
        systemUIOverlayFullscreen: [],
      ),
    );
  }
}
