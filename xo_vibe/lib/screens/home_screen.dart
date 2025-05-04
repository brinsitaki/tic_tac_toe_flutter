import 'package:flutter/material.dart';
import 'package:xo_vibe/components/custom_button.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = "/home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff424242),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 3),
            customButton(
              context,
              imgUrl: "images/online.png",
              textButton: "Play online",
            ),
            Spacer(flex: 1),
            customButton(
              context,
              imgUrl: "images/computer.png",
              textButton: "Play with computer",
            ),
            Spacer(flex: 1),
            customButton(
              context,
              imgUrl: "images/friends.png",
              textButton: "Play with friends",
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
