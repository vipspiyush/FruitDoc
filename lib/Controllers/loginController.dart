import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_classification_mobilenet/Controllers/userIdController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Views/bottomNavBar.dart';

class LogInController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseFirestore firebase = FirebaseFirestore.instance;

  //login logic here
  Future<bool> logIn(context) async {
    bool isLoggedIn = false;
    // Use Get.dialog() to show the circular indicator
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: lightGreen,
        ),
      ),
      barrierDismissible: false, // Prevents the dialog from being dismissed by tapping outside
    );

    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      // Dismiss the dialog after successful login
      Get.back();
      String? currentUser = credential.user?.email;
      userController.setEmail(currentUser);
      print(credential);
      // Get the user's uid
      String? uid = credential.user?.uid;
      userController.setUid(uid);
      isLoggedIn = true;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomNavigationBarExample()));
      email.clear();
      password.clear();
      Get.snackbar("Success", "Logged In Successfully", colorText: Colors.white);
    } catch (e) {
      // Dismiss the dialog after an error
      Get.back(); // This will dismiss the dialog
      print(e);
      String errorMessage = "An unknown error occurred";

      if (e.runtimeType == FirebaseAuthException) {
        FirebaseAuthException authException = e as FirebaseAuthException;

        switch (authException.code) {
          case 'invalid-email':
            errorMessage = 'The email address is not valid';
            break;
          case 'user-disabled':
            errorMessage = 'The user account has been disabled';
            break;
          case 'user-not-found':
            errorMessage = 'There is no user record corresponding to the provided email';
            break;
          case 'invalid-credential':
            errorMessage = 'Either password is incorrect or invalid email entered';
            break;
          case 'user-mismatch':
            errorMessage = 'The supplied credentials do not correspond to the previously signed-in user';
            break;
          case 'operation-not-allowed':
            errorMessage = 'The email/password sign-in method is not enabled';
            break;
          case 'network-request-failed':
            errorMessage = 'A network error occurred during the sign-in process';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many unsuccessful login attempts. Try again later';
            break;
        }
      }
      Get.snackbar("Login Error", errorMessage, colorText: Colors.red);
    }
    return isLoggedIn;
  }

  //Function to check both fields are filled
  bool checkFields() {
    if (email.text.trim().isEmpty && password.text.trim().isEmpty) {
      Get.snackbar("Fields Empty", "All fields all mandatory to be filled",
          colorText: Colors.red);
      return false;
    }
    return true;
  }

  //reset password
  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Warning!", "Please fill the email address",
          colorText: Colors.red);
      return;
    }
    final usersCollection =
        FirebaseFirestore.instance.collection('Email Users');

    // Check if the email exists in your database
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isEmpty) {
      // Email is not registered
      Get.snackbar("Oops!", "Email not registered, unable to reset password",
          colorText: Colors.red);
      print('Email not registered');
    } else {
      // Email is registered, proceed with sending the reset email
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Get.snackbar("Success!", "Password reset email sent!",
            colorText: lightGreen);
        print('Password reset email sent!');
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Oops!", "Error sending password reset email",
            colorText: Colors.red);
        print('Error sending password reset email: $e');
      }
    }
  }

  File? image;

  // function to pick image
  Future pickImage() async {
    try {
      final selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (selectedImage == null) {
        Get.snackbar(
          "Nothing selected",
          "Process terminated",
          colorText: Colors.red,
        );
        return;
      }

      final imageTemp = File(selectedImage.path);

      // Check file size
      if (imageTemp.lengthSync() > 1024 * 1024) {
        // Show snackbar for file size exceeding limit
        Get.snackbar(
          "File Size Exceeded",
          "File size exceeds the limit of 1 MB.",
          colorText: Colors.red,
        );
        return;
      }
      image = imageTemp;
      update();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}"); // Added logging for the exception message
    } catch (e) {
      print("Exception: $e"); // General exception logging
    }
  }

  //preview opted image
  Widget buildImagePreview() {
    if (image != null) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: PhotoViewGallery.builder(
          itemCount: 1,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(image!),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

}
