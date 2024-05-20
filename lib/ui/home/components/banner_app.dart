
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lottie/lottie.dart';

class BannerApp extends StatelessWidget {
  final void Function(BuildContext context) onTap;

  const BannerApp({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => onTap(context),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8),
        height: 200.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: const DecorationImage(
            image: AssetImage("assets/images/bn_1.jpg"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(4, 10), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Lottie.asset('assets/animations/cat_2_animation.json',
                width: 180.0, height: 180.0, frameRate: FrameRate.max),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    translate('banner.one'),
                    style: const TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontFamily: 'Bungee'),
                  ),
                  Text(
                    translate('banner.two'),
                    style: const TextStyle(
                        fontSize: 38.0,
                        color: Colors.deepOrangeAccent,
                        fontFamily: 'Bungee'),
                  ),
                  Text(
                    translate('banner.three'),
                    style: const TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontFamily: 'Bungee'),
                  )
                ],
              ),
            ),
            AnimatedPositioned(
                duration: const Duration(seconds: 2),
                bottom: -10.0,
                right: 0.0,
                child: Lottie.asset('assets/animations/cat_1_animation.json',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.contain,
                    frameRate: FrameRate.max)),
          ],
        ),
      ),
    );
  }
}