import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_classification_mobilenet/Views/registrationScreen.dart';
import '../../Controllers/signUpController.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Ui_Helper/styleHelper.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObSecureOne = true;
  bool isObSecureTwo = true;

  //password visibility functions
  visibilityFunOne() {
    isObSecureOne = !isObSecureOne;
  }

  visibilityFunTwo() {
    isObSecureTwo = !isObSecureTwo;
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return GetBuilder<SignUpController>(
      autoRemove: false,
      assignId: true,
      builder: (signCtrl) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Height * 0.06),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleText(
                            text: "Step 1/2",
                            size: 20,
                            txtColor: lightGreen,
                            weight: FontWeight.w500),
                        height(context: context, value: 0.02),
                        styleText(
                            text: "Register Here",
                            size: 30,
                            txtColor: lightGreen,
                            weight: FontWeight.w500),
                        height(context: context, value: 0.02),
                        styleText(
                            text: "Please enter your details",
                            size: 20,
                            txtColor: Colors.grey.shade700),
                        height(context: context, value: 0.02),
                        styleText(
                            text: "Your Email",
                            size: 18,
                            txtColor: Colors.grey.shade700),
                        height(context: context, value: 0.01),
                        SizedBox(
                          height: Height * 0.07,
                          child: TextField(
                            cursorColor: lightGreen,
                            controller: signCtrl.emailController,
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
                            obscureText: isObSecureOne,
                            controller: signCtrl.passwordController,
                            decoration: fieldDecoration(
                                hintText: "Password", radius: 6)
                                .copyWith(
                                suffixIcon: IconButton(
                                    color: isObSecureOne
                                        ? Colors.grey.shade700
                                        : lightGreen,
                                    onPressed: () {
                                      visibilityFunOne();
                                      signCtrl.update();
                                    },
                                    icon: isObSecureOne
                                        ? const Icon(
                                        Icons.visibility_off_rounded)
                                        : const Icon(
                                        Icons.visibility_rounded))),
                          ),
                        ),
                        height(context: context, value: 0.02),
                        styleText(
                            text: "Confirm Password",
                            size: 18,
                            txtColor: Colors.grey.shade700),
                        height(context: context, value: 0.01),
                        SizedBox(
                          height: Height * 0.07,
                          child: TextField(
                            cursorColor: lightGreen,
                            controller: signCtrl.confirmPasswordController,
                            obscureText: isObSecureTwo,
                            decoration: fieldDecoration(
                                hintText: "Password", radius: 6)
                                .copyWith(
                                suffixIcon: IconButton(
                                    color: isObSecureTwo
                                        ? Colors.grey.shade700
                                        : lightGreen,
                                    onPressed: () {
                                      visibilityFunTwo();
                                      signCtrl.update();
                                    },
                                    icon: isObSecureTwo
                                        ? const Icon(
                                        Icons.visibility_off_rounded)
                                        : const Icon(
                                        Icons.visibility_rounded))),
                          ),
                        ),
                        height(context: context, value: 0.05),
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
                                  bool isPasswordCorrect =
                                  signCtrl.checkPasswords();
                                  if (isPasswordCorrect) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminDocForm()));
                                  }
                                },
                                child: styleText(text: "Next"),
                              ),
                            ),
                          ],
                        ),
                        height(context: context, value: 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            styleText(
                                text: "Already have an account?",
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
                                          builder: (context) => LogInScreen()));
                                },
                                child: styleText(text: "LogIn"),
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
