
import 'package:face_net_authentication/pages/start/start.dart';
import 'package:face_net_authentication/pages/home.dart';
import 'package:face_net_authentication/pages/login/login.dart';
import 'package:flutter/material.dart';

import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return startScreen();
        } else {
          return MyHomePage();
        }
      },
    );
  }
}
