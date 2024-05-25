import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../Controllers/signUpController.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Ui_Helper/styleHelper.dart';
import 'documentForm.dart';
import 'loginScreen.dart';

class AdminDocForm extends StatefulWidget {
  const AdminDocForm({
    super.key,
  });

  @override
  State<AdminDocForm> createState() => _AdminDocFormState();
}

class _AdminDocFormState extends State<AdminDocForm> {

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          body: GetBuilder<SignUpController>(
            autoRemove: false,
            assignId: true,
            builder: (signUpCtrl) {
              return SafeArea(
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
                                text: "Step 2/2",
                                size: 20,
                                txtColor: lightGreen,
                                weight: FontWeight.w500),
                            height(context: context, value: 0.02),
                            Row(
                              children: [
                                dot(context: context, dotColor: lightGreen),
                                SizedBox(
                                  width: Width * 0.01,
                                ),
                                styleText(
                                    text: "Enter Personal Details",
                                    size: 18,
                                    txtColor: Colors.grey.shade700),
                              ],
                            ),
                            height(context: context, value: 0.02),
                            styleText(
                                text: "Your Name",
                                size: 18,
                                txtColor: Colors.grey.shade700),
                            height(context: context, value: 0.01),
                            SizedBox(
                              height: Height * 0.06,
                              child: TextField(
                                  cursorColor: lightGreen,
                                  controller: signUpCtrl.name,
                                  decoration: fieldDecoration(
                                      hintText: "John Singh", radius: 6)
                                      .copyWith(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                  )),
                            ),
                            height(context: context, value: 0.02),
                            styleText(
                                text: "Phone Number",
                                size: 18,
                                txtColor: Colors.grey.shade700),
                            height(context: context, value: 0.01),
                            SizedBox(
                                height: Height * 0.06,
                                child: TextField(
                                    cursorColor: lightGreen,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(13)
                                    ],
                                    controller: signUpCtrl.phoneNumber,
                                    keyboardType: TextInputType.phone,
                                    decoration: fieldDecoration(
                                        hintText: "+91...", radius: 6)
                                        .copyWith(
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10.0),
                                    ))),
                          SizedBox(height: Height*0.3,),
                            const DocumentForm(),
                          ],
                        ),
                      ),
                      height(context: context, value: 0.03),
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
                                // check field's value first
                                bool isEmpty = signUpCtrl.checkFields();
                                if (!isEmpty) {
                                  bool isCreated = await signUpCtrl.createUser();
                                  if (isCreated) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LogInScreen()));
                                    // Clear fields once registered and files uploaded
                                    signUpCtrl.emailController.clear();
                                    signUpCtrl.passwordController.clear();
                                    signUpCtrl.confirmPasswordController.clear();
                                  }
                                }
                              },
                              child: styleText(text: "Register"),
                            ),
                          ),
                        ],
                      ),
                      height(value: 0.02, context: context),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
