import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_classification_mobilenet/Ui_Helper/colorHelper.dart';
import 'package:image_classification_mobilenet/Ui_Helper/styleHelper.dart';
import 'package:image_classification_mobilenet/Views/UserProfilePage.dart';
import '../ui/gallery.dart';

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  late CameraDescription cameraDescription;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const GalleryScreen(),const ProfilePage()
  ];

  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: _selectedIndex == 0 ? AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: styleText(text: "FruitDoc",size: 25)),
          backgroundColor: lightGreen,
        ) : null,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: lightGreen,
          items:  const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_max_rounded),
              label: 'HomePage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
