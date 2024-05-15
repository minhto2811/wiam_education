import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiam/bloc/settings/settings_bloc.dart';
import 'package:wiam/di/app_module.dart';

import '../../services/player_manager.dart';
import 'bottom_sheet_login.dart';

class SettingsScreen extends StatefulWidget {
  static const route = '/SettingsScreen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsBloc _settingsBloc = getIt<SettingsBloc>();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết lập'),
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
      body: BlocListener<SettingsBloc, SettingsState>(
          bloc: _settingsBloc,
          listenWhen: (previous, current) {
            return current is SettingsErrorState;
          },
          listener: (context, state) {
            if (state is SettingsErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: SettingsBody(settingsBloc: _settingsBloc)),
    );
  }
}

class SettingsBody extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const SettingsBody({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyAccount(settingsBloc: settingsBloc),
        _divider,
        MusicSetting(settingsBloc: settingsBloc),
        _divider,
        MyHelp(settingsBloc: settingsBloc),
        _divider,
        Login(
          settingsBloc: settingsBloc,
        ),
        _divider
      ],
    );
  }
}

Widget get _divider {
  return const Divider(
    thickness: 1.0,
    height: 1.0,
  );
}

class Login extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const Login({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 52.0,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text('Đã có tài khoản:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Expanded(flex: 1, child: SizedBox()),
          InkWell(
            onTap: () {
               getIt<PlayerManager>().playWhenClick();
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheetLogin(settingsBloc: settingsBloc);
                  });
            },
            child: const Text('Đăng nhập tài khoản khác'),
          )
        ]));
  }
}

class MyHelp extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const MyHelp({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 52.0,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text('Liên hệ:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Expanded(flex: 1, child: SizedBox()),
          ProviderItem(
            onTap: () {
               getIt<PlayerManager>().playWhenClick();
              settingsBloc.add(SettingContactEvent(type: 'tel'));
            },
            user: null,
            defaultImage: 'assets/images/phone-call.png',
          ),
          const SizedBox(width: 12.0),
          ProviderItem(
            onTap: () {
               getIt<PlayerManager>().playWhenClick();
              settingsBloc.add(SettingContactEvent(type: 'zalo'));
            },
            user: null,
            defaultImage: 'assets/images/zalo.png',
          ),
          const SizedBox(width: 12.0),
          ProviderItem(
            onTap: () {
               getIt<PlayerManager>().playWhenClick();
              settingsBloc.add(SettingContactEvent(type: 'messenger'));
            },
            user: null,
            defaultImage: 'assets/images/messenger.png',
          ),
        ]));
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
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 52.0,
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text('Liên kết tài khoản:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                const Expanded(flex: 1, child: SizedBox()),
                ProviderItem(
                    user: state.userFb,
                    defaultImage: 'assets/images/fb.png',
                    onTap: () {
                       getIt<PlayerManager>().playWhenClick();
                      widget.settingsBloc
                          .add(SettingsLinkAccountEvent(type: 'facebook'));
                    }),
                const SizedBox(width: 20.0),
                ProviderItem(
                    user: state.userGg,
                    defaultImage: 'assets/images/gg.png',
                    onTap: () {
                       getIt<PlayerManager>().playWhenClick();
                      widget.settingsBloc
                          .add(SettingsLinkAccountEvent(type: 'google'));
                    }),
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
  final void Function() onTap;

  const ProviderItem(
      {super.key,
      required this.user,
      required this.defaultImage,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: user == null ? onTap : null,
        child: CircleAvatar(
          backgroundColor: Colors.black12,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!) as ImageProvider
              : AssetImage(defaultImage),
          radius: 15.0,
        ));
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
        return Container(
          padding: const EdgeInsets.only(left: 20.0, right: 10.0),
          height: 52.0,
          child: Row(children: [
            const Text('Âm lượng:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
