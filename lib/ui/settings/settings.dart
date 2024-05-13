import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiam/bloc/settings/settings_bloc.dart';
import 'package:wiam/services/player_manager.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/SettingsScreen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thiết lập'),
          titleTextStyle: const TextStyle(fontFamily: 'Bungee', fontSize: 20.0),
          backgroundColor: const Color(0xFF5AC2C1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              PlayerManager().playWhenClick();
              Navigator.pop(context);
            },
          ),
        ),
        body: const BodySettings());
  }
}

class BodySettings extends StatefulWidget {
  const BodySettings({super.key});

  @override
  State<BodySettings> createState() => _BodySettingsState();
}

class _BodySettingsState extends State<BodySettings> {
  final SettingsBloc _settingsBloc = SettingsBloc();

  @override
  void initState() {
    _settingsBloc.add(SettingsInitialUserEvent());
    _settingsBloc.add(SettingsInitialVolumeEvent());
    super.initState();
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyAccount(settingsBloc: _settingsBloc),
        MusicSetting(settingsBloc: _settingsBloc),
      ],
    );
  }
}

class MyAccount extends StatefulWidget {
  final SettingsBloc settingsBloc;

  const MyAccount({super.key, required this.settingsBloc});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
        bloc: widget.settingsBloc,
        listener: (context, state) {},
        buildWhen: (previous, current) => current is SettingsUserState,
        builder: (context, state) {
          if (state is SettingsUserState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child:
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text('Liên kết tài khoản:',
                    style:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const Expanded(flex: 1, child: SizedBox()),
                ProviderItem(
                    user: state.userFb, defaultImage: 'assets/images/fb.png'),
                const SizedBox(width: 20.0),
                ProviderItem(
                    user: state.userGg, defaultImage: 'assets/images/gg.png'),
                const SizedBox(width: 20.0),
              ]),
            );
          }
          return const SizedBox();
        });
  }
}

class ProviderItem extends StatelessWidget {
  final String defaultImage;
  final UserInfo? user;

  const ProviderItem(
      {super.key, required this.user, required this.defaultImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap:(){
          PlayerManager().playWhenClick();
        },
        child:
        CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : AssetImage(defaultImage) as ImageProvider,
          radius: 15.0,
        )

    );
  }
}

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
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(children: [
            const Text('Âm lượng:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            const Expanded(flex: 1, child: SizedBox()),
            InkWell(
              onTap: _volume < 0.1
                  ? null
                  : () {
                PlayerManager().playWhenClick();
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
                PlayerManager().playWhenClick();
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
