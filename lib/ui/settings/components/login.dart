import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../bloc/settings/settings_bloc.dart';
import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';
import 'bottom_sheet_login.dart';

class Login extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const Login({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 52.0,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(translate("settings.already_have_an_account"),
              style:
              const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
            child: Text(
                translate("settings.sign_in_with_another_account")
            ),
          )
        ]));
  }
}