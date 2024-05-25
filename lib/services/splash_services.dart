import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/routes/routes_name.dart';
import 'session_manager.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      SessionController().userId = user.uid;
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, RouteName.btmNavScreen);
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(
            context,
            RouteName
                .loginScreen); // Ensure you have this route defined in your route settings.
      });
    }
  }
}
