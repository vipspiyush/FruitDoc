import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_classification_mobilenet/Views/signupScreen.dart';
import '../../Controllers/logInController.dart';
import '../Controllers/userIdController.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Ui_Helper/styleHelper.dart';


class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  bool isObSecure = true;

  void obSecure() {
    isObSecure = !isObSecure;
  }
  final uid = userController.uid?.value;

  @override
  Widget build(BuildContext context) {

    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return GetBuilder<LogInController>(
      autoRemove: false,
      assignId: true,
      builder: (logInCtrl) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Height * 0.09),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleText(
                            text: "LogIn Here",
                            size: 30,
                            txtColor: lightGreen,
                            weight: FontWeight.w500),
                        height(context: context, value: 0.02),
                        styleText(
                            text: "Please enter your details",
                            size: 20,
                            txtColor: Colors.grey.shade700),
                        height(context: context, value: 0.04),
                        styleText(
                            text: "Your email",
                            size: 18,
                            txtColor: Colors.grey.shade700),
                        height(context: context, value: 0.01),
                        SizedBox(
                          height: Height * 0.07,
                          child: TextField(
                            cursorColor: lightGreen,
                            controller: logInCtrl.email,
                            decoration: fieldDecoration(
                                hintText: "john@gmail.com", radius: 6)
                                .copyWith(
                                suffixIcon:
                                const Icon(Icons.email_rounded)),
                          ),
                        ),
                        height(context: context, value: 0.02),
                        styleText(
                            text: "Password",
                            size: 18,
                            txtColor: Colors.grey.shade700),
                        height(context: context, value: 0.01),
                        SizedBox(
                          height: Height * 0.07,
                          child: TextField(
                            cursorColor: lightGreen,
                            controller: logInCtrl.password,
                            obscureText: isObSecure,
                            decoration: fieldDecoration(
                                hintText: "Password...", radius: 6)
                                .copyWith(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      obSecure();
                                      logInCtrl.update();
                                    },
                                    icon: isObSecure
                                        ? const Icon(
                                        Icons.visibility_off_rounded)
                                        : const Icon(Icons.visibility))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  logInCtrl.sendPasswordResetEmail(
                                      logInCtrl.email.text.trim());
                                },
                                child: styleText(
                                    text: "Forgot Password?",
                                    size: 18,
                                    txtColor: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Height * 0.06,
                              width: Width * 0.9,
                              child: ElevatedButton(
                                style: elevatedButtonStyle(
                                    radius: 6, bgColor: lightGreen),
                                onPressed: () async {
                                  bool check = logInCtrl.checkFields();
                                  if (check) {
                                    await logInCtrl.logIn(context);
                                  }
                                },
                                child: styleText(text: "LogIn"),
                              ),
                            ),
                          ],
                        ),
                        height(context: context, value: 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            styleText(
                                text: "Create an account?",
                                size: 18,
                                txtColor: Colors.grey.shade700),
                          ],
                        ),
                        height(context: context, value: 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Height * 0.06,
                              width: Width * 0.9,
                              child: ElevatedButton(
                                style: elevatedButtonStyle(
                                    radius: 6,
                                    bgColor: Colors.grey,
                                    fgColor: lightGreen),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const SignUpScreen()));
                                },
                                child: styleText(text: "Sign Up"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
