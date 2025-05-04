import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xo_vibe/firebase_options.dart';
import 'package:xo_vibe/screens/choose_difficulty_screen.dart';
import 'package:xo_vibe/screens/home_screen.dart';
import 'package:xo_vibe/screens/play_online_screen.dart';
import 'package:xo_vibe/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XoVibe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        PlayOnlineScreen.routeName: (context) => PlayOnlineScreen(),
        ChooseDifficultyScreen.routeName: (context) => ChooseDifficultyScreen(),
      },
    );
  }
}
