import 'package:flutter/material.dart';
import 'package:xo_vibe/components/custom_button.dart';
import 'package:xo_vibe/screens/play_screen.dart';

class ChooseDifficultyScreen extends StatelessWidget {
  static final String routeName = "/choose_difficulty_screen";
  const ChooseDifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff424242),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 6),
            customButton(
              context,
              textButton: "Easy",
              function: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayScreen(
                      isVsComputer: true,
                      difficulty: "Easy",
                    ),
                  ),
                );
              },
            ),
            Spacer(flex: 1),
            customButton(
              context,
              textButton: "Hard",
              function: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayScreen(
                      isVsComputer: true,
                      difficulty: "Hard",
                    ),
                  ),
                );
              },
            ),
            Spacer(flex: 6),
          ],
        ),
      ),
    );
  }
}
