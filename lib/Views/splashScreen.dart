import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_classification_mobilenet/Views/AuthStateChange/authState.dart';

import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    Timer(const Duration(seconds: 2), () async{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthChangeState()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: Center(
        child: Image.asset("assets/logos/logo.png"),
      ),
    );
  }
}
