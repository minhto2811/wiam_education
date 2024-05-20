import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../bloc/settings/settings_bloc.dart';
import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';

class MyHelp extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const MyHelp({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 52.0,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(translate("settings.contact_us"),
              style:
              const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Expanded(flex: 1, child: SizedBox()),
          ProviderItem(
            onTap: () {
              getIt<PlayerManager>().playWhenClick();
              settingsBloc
                  .add(SettingContactEvent(type: 'tel', context: context));
            },
            user: null,
            defaultImage: 'assets/images/phone-call.png',
          ),
          const SizedBox(width: 12.0),
          ProviderItem(
            onTap: () {
              getIt<PlayerManager>().playWhenClick();
              settingsBloc
                  .add(SettingContactEvent(type: 'zalo', context: context));
            },
            user: null,
            defaultImage: 'assets/images/zalo.png',
          ),
          const SizedBox(width: 12.0),
          ProviderItem(
            onTap: () {
              getIt<PlayerManager>().playWhenClick();
              settingsBloc.add(
                  SettingContactEvent(type: 'messenger', context: context));
            },
            user: null,
            defaultImage: 'assets/images/messenger.png',
          ),
        ]));
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
