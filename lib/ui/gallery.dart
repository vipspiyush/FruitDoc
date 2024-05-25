import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_classification_mobilenet/Ui_Helper/colorHelper.dart';
import 'package:image_classification_mobilenet/Ui_Helper/styleHelper.dart';
import 'package:image_picker/image_picker.dart';
import '../helper/image_classification_helper.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  ImageClassificationHelper? imageClassificationHelper;
  final imagePicker = ImagePicker();
  String? imagePath;
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  bool showRemoveButton = false;

  @override
  void initState() {
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper!.initHelper();
    super.initState();
  }

  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {
      showRemoveButton = false; // Hide the remove button when cleaning results
    });
  }

  Future<void> processImage() async {
    if (imagePath != null) {
      final imageData = File(imagePath!).readAsBytesSync();
      image = img.decodeImage(imageData);
      setState(() {
        showRemoveButton =
            true; // Show the remove button when an image is selected
      });
      classification = await imageClassificationHelper?.inferenceImage(image!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (cameraIsAvailable)
                TextButton.icon(
                  onPressed: () async {
                    cleanResult();
                    final result = await imagePicker.pickImage(
                      source: ImageSource.camera,
                    );
                    imagePath = result?.path;
                    setState(() {});
                    processImage();
                  },
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blue,
                    size: 35,
                  ),
                  label: styleText(
                      text: "Take a photo", txtColor: Colors.blue, size: 15),
                ),
              TextButton.icon(
                onPressed: () async {
                  cleanResult();
                  final result = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  imagePath = result?.path;
                  setState(() {});
                  processImage();
                },
                icon: Icon(
                  Icons.photo,
                  color: lightGreen,
                  size: 35,
                ),
                label: styleText(
                    text: "Pick From Gallery", txtColor: lightGreen, size: 15),
              ),
            ],
          ),
          Divider(color: lightGreen),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (image == null)
                  styleText(
                      text: "Please select or capture an image",
                      txtColor: Colors.black),
                if (imagePath != null)
                  Container(
                    height: Height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(File(imagePath!)),
                    ),
                  ),
                if (classification != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...(classification!.entries.toList()
                                ..sort(
                                  (a, b) => a.value.compareTo(b.value),
                                ))
                              .reversed
                              .take(3)
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(e.key),
                                      const Spacer(),
                                      styleText(
                                          text: e.value.toStringAsFixed(2),
                                          txtColor: Colors.black)
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (showRemoveButton)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  cleanResult();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: lightGreen,
                      content: const Text('Image removed successfully'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('Remove Image',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Set the button color to red
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
