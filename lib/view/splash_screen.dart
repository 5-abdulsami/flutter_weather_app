import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/colors/colors.dart';
import 'package:weather_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: splashColor,
        body: Center(
          child: SvgPicture.asset(
            'assets/weather.svg',
            width: 300,
            height: 300,
            semanticsLabel: 'Weather Logo',
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ));
  }
}
