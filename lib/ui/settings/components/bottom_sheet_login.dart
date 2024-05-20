import 'package:flutter/material.dart';
import 'package:wiam/bloc/settings/settings_bloc.dart';

import '../../../di/app_module.dart';
import '../../../services/player_manager.dart';

class BottomSheetLogin extends StatelessWidget {
  final SettingsBloc settingsBloc;

  const BottomSheetLogin({super.key, required this.settingsBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonLogin(
                  image: 'assets/images/fb.png',
                  title: 'Đăng nhập bằng Facebook',
                  onTap: () {
                    getIt<PlayerManager>().playWhenClick();
                    settingsBloc.add(SettingsSignInEvent(type: 'facebook',context: context));
                    Navigator.pop(context);
                  }),
              const SizedBox(height: 16.0),
              ButtonLogin(
                  image: 'assets/images/gg.png',
                  title: 'Đăng nhập bằng Google',
                  onTap: () {
                    getIt<PlayerManager>().playWhenClick();
                    settingsBloc.add(SettingsSignInEvent(type: 'google',context: context));
                    Navigator.pop(context);
                  })
            ]));
  }
}

class ButtonLogin extends StatelessWidget {
  final String image;
  final String title;
  final void Function() onTap;

  const ButtonLogin(
      {super.key,
        required this.image,
        required this.title,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.8,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Image.asset(
          image,
          height: 36.0,
          width: 36.0,
        ),
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white),
          elevation: MaterialStatePropertyAll(10.0),
          iconSize: MaterialStatePropertyAll(14.0),
          foregroundColor: MaterialStatePropertyAll(Colors.black),
          padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 26.0)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        ),
        label: Text(
          title,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
