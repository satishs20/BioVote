import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:face_net_authentication/pages/login/login.dart';
import 'package:face_net_authentication/pages/home.dart';

import '../../widget_tree.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('assets/images/splash.json'),
        splashIconSize: 250,
        backgroundColor: Colors.white,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        nextScreen: const WidgetTree());
  }
}