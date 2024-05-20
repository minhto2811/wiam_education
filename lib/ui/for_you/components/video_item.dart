import 'package:flutter/material.dart';
import 'package:wiam/data/models/video.dart';
import 'package:wiam/di/app_module.dart';
import 'package:wiam/services/player_manager.dart';
import 'package:wiam/ui/video/play_video.dart';

class VideoItem extends StatelessWidget {
  final Video _video;

  const VideoItem(this._video, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getIt<PlayerManager>().playWhenClick();
        Navigator.pushNamed(context, PlayVideoScreen.route,arguments: _video.video);
      },
      child: Row(
        children: [
          Image.network(
            _video.image,
            width: 100.0,
            height: 100.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _video.title,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _video.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
