import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wiam/bloc/splash/splash_bloc.dart';
import 'package:wiam/di/app_module.dart';
import 'package:wiam/ui/home/home.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashBloc _splashBloc = getIt<SplashBloc>();

  @override
  void initState() {
    _splashBloc.add(SplashInitialEvent(context));
    super.initState();
  }

  @override
  void dispose() {
    _splashBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      bloc: _splashBloc,
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is SplashCheckCompletedState) {
          Navigator.pushReplacementNamed(context, HomeScreen.route);
        }
      },
      child: _bodyApp(context),
    );
  }

  Widget _bodyApp(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg_1.jpg'),
                fit: BoxFit.cover)),
        child: Center(
            child: Lottie.asset(
          'assets/animations/panda_animation.json',
          fit: BoxFit.cover,
          frameRate: FrameRate.max,
        )));
  }
}
