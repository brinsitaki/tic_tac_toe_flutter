import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xo_vibe/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static final String routeName = "/splash_screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff424242),
      body: SafeArea(
          child: Column(
        children: [
          Spacer(),
          Center(
            child: Image.asset(
              "images/logo.png",
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
          Text(
            "XoVibe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            "Created by",
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Brinsi Mohamed Taki Allah",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
