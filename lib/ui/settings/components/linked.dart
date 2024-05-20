

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../bloc/settings/settings_bloc.dart';
import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';
import 'help.dart';

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
                Text(translate('settings.linked'),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold)),
                const Expanded(flex: 1, child: SizedBox()),
                ProviderItem(
                    user: state.userFb,
                    defaultImage: 'assets/images/fb.png',
                    onTap: () {
                      getIt<PlayerManager>().playWhenClick();
                      widget.settingsBloc.add(SettingsLinkAccountEvent(
                          type: 'facebook', context: context));
                    }),
                const SizedBox(width: 20.0),
                ProviderItem(
                    user: state.userGg,
                    defaultImage: 'assets/images/gg.png',
                    onTap: () {
                      getIt<PlayerManager>().playWhenClick();
                      widget.settingsBloc.add(SettingsLinkAccountEvent(
                          type: 'google', context: context));
                    }),
              ]),
            );
          }
          return const SizedBox();
        });
  }
}