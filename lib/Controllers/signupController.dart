import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Models/UserModel.dart';
import '../Models/userEmailModel.dart';
import '../Ui_Helper/colorHelper.dart';
import '../Views/loginScreen.dart';


enum DocumentType {
  ProfilePhoto,
}

class SignUpController extends GetxController {
  //actual admin registration form controller
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();


  //signUp admin controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //user details
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseFirestore firestoreFirebase = FirebaseFirestore.instance;
  late CollectionReference userData;
  late CollectionReference userEmail;

  @override
  void onInit() {
    //here User Registration will be our actual collection name on firebase
    userData = firestore.collection("User Data");
    userEmail = firestoreFirebase.collection("Email Users");
    super.onInit();
  }

  //it will add user's email id and role to firestore
  addUser({required String uid}) {
    try {
      //it will refer to collection inside which our doc will be created
      DocumentReference doc = userEmail.doc();

      //add model to add details to firebase
      UserEmailModel user = UserEmailModel(
        uid: uid,
        email: emailController.text.trim(),
        loginType: 'Logged in through email',
      );
      //set is used to add data to firebase doc and then toJson
      doc.set(user.toJson());
    } catch (e) {
      print(e);
    }
  }

  //fun to add user's data to firebase
  addUserData({required String uid}) {
    try {
      DocumentReference doc = userData.doc();

      UserModel user = UserModel(
          name: name.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          uid: uid);
      //set is used to add data to firebase doc and then toJson
      doc.set(user.toJson());
      name.clear();
      phoneNumber.clear();
    } catch (e) {
      print(e);
    }
  }

  //to create user's account
//to create user's account
  Future<bool> createUser({documentType}) async {
    bool isSuccess = false;
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          color: lightGreen,
        ),
      ),
      barrierDismissible: false,
    );

    // Check if all fields are filled and passwords match
    if (checkFields() || !checkPasswords()) {
      Get.back();
      return isSuccess; // Return false if fields are not filled or passwords don't match
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // Get current user
      String? uid = userCredential.user?.uid;
      print(uid);

      // Registration completed
      isSuccess = true;

      // Call addUser with UID and role
      addUser(uid: uid!);
      addUserData(uid: uid);

      // Check if any files have been selected
      if (selectedFiles.isNotEmpty) {
        // If files are selected, upload them
        await uploadFiles(uid);
      }

      // Remove picked file for ProfilePhoto if it exists
      removePickedFile(DocumentType.ProfilePhoto);

      Get.back();
      Get.snackbar("Success", "Registered Successfully",
          colorText: lightGreen);
      return isSuccess;
    } catch (e) {
      Get.back();
      print("Unexpected error: $e");
      String errorMessage = "Unknown error";

      if (e.runtimeType == FirebaseAuthException) {
        FirebaseAuthException authException = e as FirebaseAuthException;

        switch (authException.code) {
          case "weak-password":
            errorMessage = "The password provided is too weak";
            break;
          case "email-already-in-use":
            errorMessage =
            "The email address is already registered with another account";
            break;
          case "network-request-failed":
            errorMessage =
            "There is a network-related issue during the signup process";
            break;
          case "user-disabled":
            errorMessage = "The user account has been disabled";
            break;
          case "user-not-found":
            errorMessage =
            "The provided email address is not associated with any account";
            break;
          case "account-exists-with-different-credential":
            errorMessage =
            "An account already exists with the same email address but different sign-in credentials";
            break;
          default:
            errorMessage;
        }
      }
      Get.snackbar("Error", errorMessage, colorText: Colors.red, barBlur: 6);
      print(e);

      // Set isSuccess to false since there was an error
      isSuccess = false;

      return isSuccess;
    }
  }

  //valid email check
  bool isValidEmail(String email) {
    // Define a regular expression for validating email format
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    // Check if the email matches the defined format
    return emailRegExp.hasMatch(email);
  }

  //check password and email
  bool checkPasswords() {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim() &&
        isValidEmail(emailController.text.trim())) {
      return true;
    } else {
      Get.snackbar(
          "Warning!", "Passwords mismatched or email format is not valid",
          colorText: Colors.red);
      return false;
    }
  }

  //fun to check all details must be filled
  bool checkFields() {
    if (name.text
        .trim()
        .isEmpty ||
        phoneNumber.text
            .trim()
            .isEmpty) {
      Get.snackbar("Field Empty", "Please fill in all fields",
          colorText: Colors.red);
      //empty
      return true;
    }
    // if (selectedFiles.isEmpty) {
    //   Get.snackbar("No Image Selected", "Please pick a profile image",
    //       colorText: Colors.red);
    //   return true; // No image selected
    // }
    //not empty
    return false;
  }

  // Track picked files for each document type
  Map<DocumentType, PlatformFile?> pickedFiles = {
    DocumentType.ProfilePhoto: null,
  };

  List<PlatformFile> selectedFiles = [];

  // Function to pick a file for a specific document type
  Future<void> pickFile(DocumentType documentType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'jpg', 'img'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // Check if the selected file has allowed extension
      if (['jpeg', 'jpg', 'img'].contains(file.extension?.toLowerCase())) {
        // Check file size
        if (file.size <= 3 * 1024 * 1024) {
          // Check if the file is already picked
          if (!selectedFiles.contains(file)) {
            // Update picked file for the specified document type
            pickedFiles[documentType] = file;
            selectedFiles.add(file); // Add to the list
            update(); // Trigger UI update

            // Show snackbar for successful file pick
            Get.snackbar(
              "File Picked",
              "File '${file.name}' successfully picked for ${documentType
                  .toString()
                  .split('.')
                  .last}",
              colorText: Colors.green,
            );
          } else {
            // Show snackbar for duplicate file selection
            Get.snackbar(
              "Duplicate File",
              "File '${file.name}' is already selected.",
              colorText: Colors.red,
            );
          }
        } else {
          // Show snackbar for file size exceeding limit
          Get.snackbar(
            "File Size Exceeded",
            "File size of '${file.name}' exceeds the limit of ${3} MB.",
            colorText: Colors.red,
          );
        }
      } else {
        // Show snackbar for invalid extension
        Get.snackbar(
          "Invalid File Type",
          "Please choose a file with either PDF, JPG, or JPEG extension.",
          colorText: Colors.red,
        );
      }
    } else {
      // Show snackbar if no file is selected
      Get.snackbar(
        "Nothing selected",
        "Process terminated",
        colorText: Colors.red,
      );
    }
  }

  // Function to remove the picked file for a specific document type
  void removePickedFile(DocumentType documentType) {
    // Find the file in the selectedFiles list
    PlatformFile? fileToRemove = pickedFiles[documentType];
    if (fileToRemove != null) {
      // Remove the file from the selectedFiles list
      selectedFiles.remove(fileToRemove);
      // Remove the file from the pickedFiles map
      pickedFiles[documentType] = null;
      // Trigger UI update
      update();
    }
  }

  // Function to upload files to firebase
  Future<void> uploadFiles(String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(uid);

      // Iterate through each picked file and upload to the appropriate folder
      await Future.forEach(pickedFiles.entries,
              (MapEntry<DocumentType, PlatformFile?> entry) async {
            DocumentType documentType = entry.key;
            PlatformFile? file = entry.value;

            if (file != null) {
              // Check if the documentType corresponds to the profile photo
              if (documentType == DocumentType.ProfilePhoto) {
                // Save the file as profile.jpg in the ProfilePhoto folder
                final profilePhotoRef =
                storageRef.child('ProfilePhoto/profile.jpg');
                await profilePhotoRef.putFile(File(file.path!));
                print("Profile photo uploaded successfully!");
              } else {
                // For other document types, use the original file name
                final documentTypeFolder = documentType
                    .toString()
                    .split('.')
                    .last;
                final fileName = file.name;

                final documentTypeRef =
                storageRef.child('$documentTypeFolder/$fileName');
                await documentTypeRef.putFile(File(file.path!));
              }
            }
          });
      print("All files uploaded successfully!");
    } catch (e) {
      print("Error uploading files: $e");
    }
  }

  //read vendor's profile data
  Future<UserModel?> fetchUserProfile(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('User Data')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("null found");
        return null;
      } else {
        return UserModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
    return null;
  }

  final GetStorage _storage = GetStorage();

  //signOut
  Future signOut(context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      _storage.remove('uid');
      // Listen for auth state changes and navigate to LogInScreen if user is null
      StreamSubscription<User?>? subscription;
      subscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user == null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogInScreen()));
              subscription?.cancel();
            }
          });

      Get.snackbar("Success", "LoggedOut successfully", colorText: lightGreen);
      print('Vendor updated successfully');
    } catch (e) {
      print(e);
      Get.snackbar("Oops!", "Something went wrong", colorText: Colors.red);
    }
  }

  //fetch vendor profile image
  Future<String?> getProfilePhotoUrl(String uid) async {
    try {
      // Reference to the image in Firebase Storage
      Reference ref =
      FirebaseStorage.instance.ref('$uid/ProfilePhoto/profile.jpg');
      // Get the download URL
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error getting profile photo URL: $e");
      return null;
    }
  }


}
