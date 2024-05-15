import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wiam/di/app_module.dart';
import 'package:wiam/ui/home/home.dart';
import 'package:wiam/ui/settings/settings.dart';
import 'package:wiam/ui/splash/splash.dart';

import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route: (context) => const SplashScreen(),
        HomeScreen.route: (context) => const HomeScreen(),
        SettingsScreen.route: (context) => const SettingsScreen(),
      },
    );
  }
}
