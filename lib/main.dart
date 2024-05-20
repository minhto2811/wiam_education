import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:wiam/di/app_module.dart';
import 'package:wiam/ui/for_you/for_you.dart';
import 'package:wiam/ui/home/home.dart';
import 'package:wiam/ui/settings/settings.dart';
import 'package:wiam/ui/splash/splash.dart';
import 'package:wiam/ui/list_test/list_test_screen.dart';
import 'package:wiam/ui/test_detail/test_detail_screen.dart';
import 'package:wiam/ui/topic/topic_detail.dart';
import 'package:wiam/ui/video/play_video.dart';

import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US', 'vi_VN'],
      basePath: 'assets/i18n/');
  setup();
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'Wiam Application',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: SplashScreen.route,
        routes: {
          SplashScreen.route: (context) => const SplashScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          SettingsScreen.route: (context) => const SettingsScreen(),
          TopicDetailScreen.route: (context) => const TopicDetailScreen(),
          ListTestScreen.route: (context) => const ListTestScreen(),
          TestDetailScreen.route: (context) => const TestDetailScreen(),
          ForYouScreen.route: (context) => const ForYouScreen(),
          PlayVideoScreen.route: (context) => const PlayVideoScreen(),
        },
      ),
    );
  }
}
