import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../../Controllers/signUpController.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Ui_Helper/styleHelper.dart';


class DocumentForm extends StatelessWidget {
  const DocumentForm({super.key});

  @override
  Widget build(BuildContext context) {

    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return GetBuilder<SignUpController>(
      assignId: true,
      autoRemove: false,
      builder: (signUpCtrl) {
        return Container(
          height: Height * 0.1,
          width: Width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    dot(context: context, dotColor: lightGreen),
                    SizedBox(
                      width: Width * 0.01,
                    ),
                    styleText(
                        text: "Profile Photo",
                        txtColor: Colors.black,
                        size: 17),
                    // Remove button
                    if (signUpCtrl.pickedFiles[DocumentType.ProfilePhoto] !=
                        null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          signUpCtrl
                              .removePickedFile(DocumentType.ProfilePhoto);
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: status(
                          context: context,
                          pickedColor: signUpCtrl
                              .pickedFiles[DocumentType.ProfilePhoto] !=
                              null
                              ? lightGreen
                              : Colors.red),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        style: elevatedButtonStyle(bgColor: lightGreen),
                        onPressed: () async {
                          await signUpCtrl.pickFile(DocumentType.ProfilePhoto);
                          signUpCtrl.update();
                        },
                        child: styleText(
                            text: "Upload", txtColor: Colors.white, size: 17))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
