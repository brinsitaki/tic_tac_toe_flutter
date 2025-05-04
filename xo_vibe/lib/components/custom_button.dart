import 'package:flutter/material.dart';
import 'package:xo_vibe/screens/choose_difficulty_screen.dart';
import 'package:xo_vibe/screens/play_online_screen.dart';
import 'package:xo_vibe/screens/play_screen.dart';

Center customButton(
  BuildContext context, {
  required String textButton,
  VoidCallback? function,
  String? imgUrl,
}) {
  return Center(
    child: Material(
      color: Colors.deepOrangeAccent,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () {
          if (textButton == "Reset game" ||
              textButton == "Easy" ||
              textButton == "Hard") {
            function!();
          } else if (textButton == "Play online") {
            Navigator.pushNamed(context, PlayOnlineScreen.routeName);
          } else if (textButton == "Play with computer") {
            Navigator.pushNamed(context, ChooseDifficultyScreen.routeName);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayScreen(
                  isVsComputer: false,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Colors.white.withValues(alpha: 0.3),
        hoverColor: Colors.white.withValues(alpha: 0.1),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20.0,
          height: MediaQuery.of(context).size.height / 11.5,
          child: textButton == "Reset game" ||
                  textButton == "Easy" ||
                  textButton == "Hard"
              ? Center(
                  child: Text(
                    textButton,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 15.0,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Image.asset(
                        imgUrl!,
                        height: MediaQuery.of(context).size.height / 15,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      textButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );
}
