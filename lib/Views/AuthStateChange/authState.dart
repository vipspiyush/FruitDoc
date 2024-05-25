import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_classification_mobilenet/Views/loginScreen.dart';
import '../../Controllers/userIdController.dart';
import '../bottomNavBar.dart';

class AuthChangeState extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthChangeState({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          String ? uid = Get.find<UserController>().getUid();
          if (uid!.isNotEmpty) {
            return const BottomNavigationBarExample();
          } else {
            return LogInScreen();
          }
        },
      ),
    );
  }
}
