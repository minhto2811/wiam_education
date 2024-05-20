
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/bloc/settings/settings_bloc.dart';
import 'package:wiam/di/app_module.dart';
import '../../services/player_manager.dart';
import 'components/help.dart';
import 'components/language.dart';
import 'components/linked.dart';
import 'components/login.dart';
import 'components/volume.dart';

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
    return BlocConsumer<SettingsBloc, SettingsState>(
      bloc: _settingsBloc,
      listenWhen: (previous, current) {
        return current is SettingsErrorState ||
            current is SettingsChangeLanguageState;
      },
      listener: (context, state) {
        if (state is SettingsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is SettingsChangeLanguageState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text(translate('dialog.title')),
                  content: Text(translate('dialog.message')),
                  actions: [
                    TextButton(
                        onPressed: () {
                          getIt<PlayerManager>().playWhenClick();
                          Navigator.pop(context);
                        },
                        child: Text(
                          translate('dialog.cancel'),
                          style: const TextStyle(color: Colors.black45),
                        )),
                    TextButton(
                        onPressed: () {
                          getIt<PlayerManager>().playWhenClick();
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        child: Text(
                          translate('dialog.ok'),
                          style: const TextStyle(color: Colors.black),
                        )),
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(translate('settings.title')),
              titleTextStyle:
                  const TextStyle(fontFamily: 'Bungee', fontSize: 20.0),
              backgroundColor: const Color(0xFF5AC2C1),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () {
                  getIt<PlayerManager>().playWhenClick();
                  Navigator.pop(context);
                },
              ),
            ),
            body: SettingsBody(settingsBloc: _settingsBloc));
      },
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
        Login(settingsBloc: settingsBloc),
        _divider,
        ChangeLanguage(
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

