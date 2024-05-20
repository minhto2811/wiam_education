import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../bloc/settings/settings_bloc.dart';

class ChangeLanguage extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const ChangeLanguage({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 52.0,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(translate("settings.language"),
              style:
              const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Expanded(flex: 1, child: SizedBox()),
          InkWell(
            onTap: () {
              settingsBloc.add(SettingsChangeLanguageEvent(context));
            },
            child: Text(translate("settings.change_language")),
          )
        ]));
  }
}