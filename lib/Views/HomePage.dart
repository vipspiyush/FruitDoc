import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Controllers/logInController.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Ui_Helper/styleHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String ? result="null";

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: lightGreen,
          title: Center(child: styleText(text: "Fruit Quality Detection")),
        ),
        body: GetBuilder<LogInController>(
          assignId: true,
          autoRemove: false,
          builder: (signCtrl) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: Height * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: signCtrl.image != null
                            ? signCtrl.buildImagePreview()
                            : Center(
                                child: Text("Nothing to preview!",
                                    style: GoogleFonts.poppins()),
                              )),
                  ),
                  height(context: context, value: 0.02),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: elevatedButtonStyle(bgColor: lightGreen),
                            onPressed: () async{
                              await signCtrl.pickImage();
                              print(Get.find<LogInController>().image);
                            },
                            child: const Icon(Icons.add_a_photo_rounded)),
                        ElevatedButton.icon(
                          style:
                              elevatedButtonStyle(bgColor: Colors.blueAccent),
                          onPressed: () async {
                            // Show the dialog immediately
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Row(
                                    children: [
                                      CircularProgressIndicator(
                                          color: lightGreen),
                                      const SizedBox(width: 20),
                                      const Text(
                                        "Submitting...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                            // Simulate a delay to mimic the asynchronous operation of processImage
                            await Future.delayed(const Duration(
                                seconds: 1)); // Adjust the duration as needed

                            // Call the processImage method from the MLController
                            //   await Get.find<MLController>()
                            //     .processImage(signCtrl.image!);

                            // Close the dialog
                            Navigator.of(context, rootNavigator: true).pop();

                            // Print the result in the bottom of the screen in black color
                          },
                          icon: const Icon(Icons.send),
                          label: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      result ?? "No result",
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                ]);
          },
        ));
  }
}
