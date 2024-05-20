import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../bloc/settings/settings_bloc.dart';
import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';

class MusicSetting extends StatefulWidget {
  final SettingsBloc settingsBloc;

  const MusicSetting({super.key, required this.settingsBloc});

  @override
  State<MusicSetting> createState() => _MusicSettingState();
}

class _MusicSettingState extends State<MusicSetting> {
  double _volume = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: widget.settingsBloc,
      listenWhen: (previous, current) => current is SettingsChangeVolumeState,
      listener: (context, state) {
        if (state is SettingsChangeVolumeState) {
          setState(() {
            _volume = state.volume;
          });
        }
      },
      buildWhen: (previous, current) => current is SettingsChangeVolumeState,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(left: 20.0, right: 10.0),
          height: 52.0,
          child: Row(children: [
            Text(translate("settings.volume_level"),
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            const Expanded(flex: 1, child: SizedBox()),
            InkWell(
              onTap: _volume < 0.1
                  ? null
                  : () {
                getIt<PlayerManager>().playWhenClick();
                setState(() {
                  _volume -= 0.1;
                });
                widget.settingsBloc
                    .add(SettingsChangeVolumeLevelEvent(_volume));
              },
              child: const Icon(Icons.arrow_left_sharp,
                  color: Colors.deepOrangeAccent, size: 50.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text((_volume * 10).toStringAsFixed(0),
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold)),
            ),
            InkWell(
              onTap: _volume > 0.9
                  ? null
                  : () {
                getIt<PlayerManager>().playWhenClick();
                setState(() {
                  _volume += 0.1;
                });
                widget.settingsBloc
                    .add(SettingsChangeVolumeLevelEvent(_volume));
              },
              child: const Icon(Icons.arrow_right_sharp,
                  color: Colors.deepOrangeAccent, size: 50.0),
            )
          ]),
        );
      },
    );
  }
}
