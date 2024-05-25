import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../Models/UserModel.dart';
import '../Ui_Helper/colorHelper.dart';
import '/Controllers/signUpController.dart';
import '/Controllers/userIdController.dart';
import '/Ui_Helper/styleHelper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<ProfilePage> {
  String? newUid = Get.find<UserController>().getUid();
  String? newEmail = Get.find<UserController>().getEmail();

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return GetBuilder<SignUpController>(
      assignId: true,
      autoRemove: false,
      builder: (SignUpCtrl) {
        return Scaffold(
          body: FutureBuilder(
              future: SignUpCtrl.fetchUserProfile(newUid!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: lightGreen,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  //got my object just fetch the data, here data is in map format
                  final UserModel? user = snapshot.data;
                  return Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white),
                      ),
                      Container(
                        height: Height * 0.27,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      Positioned(
                        top: Height * 0.06,
                        left: Width * 0.77,
                        child: Card(
                          elevation: 5,
                          child: Container(
                            height: Height * 0.04,
                            width: Height * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: InkWell(
                              onTap: () {
                                FutureBuilder(
                                    future: SignUpCtrl.signOut(context),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: lightGreen,
                                        ));
                                      }
                                      return Container();
                                    });
                              },
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: SignUpCtrl.getProfilePhotoUrl(newUid!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Positioned(
                              top: Height * 0.15,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: Height * 0.2,
                                width: Width * 0.2,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: lightGreen, width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: Height * 0.2,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            String? url = snapshot.data;
                            if (url != null) {
                              return Positioned(
                                top: Height * 0.15,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: Height * 0.2,
                                  width: Width * 0.2,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: lightGreen, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(url),
                                    radius: Height * 0.2,
                                  ),
                                ),
                              );
                            } else {
                              return Positioned(
                                top: Height * 0.15,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: Height * 0.2,
                                  width: Width * 0.2,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: lightGreen, width: 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/logos/user.png",
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      // Return a default image widget in case of an error
                                      return Image.asset(
                                          "assets/logos/user.png");
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      Positioned(
                        top: Height * 0.45,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            elevation: 2,
                            child: Container(
                              height: Height * 0.21,
                              width: Width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: lightGreen,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: SizedBox(
                                              width: Width,
                                              child: Center(
                                                child: Text(user!.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        textStyle: const TextStyle(
                                                            fontSize: 20))),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.phone_android_rounded,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        styleText(
                                            txtColor: Colors.white,
                                            text: user.phoneNumber),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.email_rounded,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                newEmail!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  textStyle: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
              }),
        );
      },
    );
  }
}
