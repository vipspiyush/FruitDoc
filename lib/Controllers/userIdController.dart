import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  // Initialize GetStorage
  final GetStorage _storage = GetStorage();

  // Define RxString for uid and currentUser
  RxString? uid = ''.obs;
  RxString currentUser = ''.obs;

  // Setter for uid
  void setUid(String? value) {
    if (value != null) {
      uid?.value = value;
      _storage.write('uid', value);
      print("uid is during setuid $value");
    }
  }

  // Setter for currentUser
  void setEmail(String? value) {
    if (value != null) {
      _storage.write('email', value);
      currentUser.value = value;
    }
  }

  // Getter for uid
  String? getEmail() {
    // Try to get the UID from persistent storage
    String? storedEmail = _storage.read('email');
    if (storedEmail != null) {
      uid?.value = storedEmail;
      print("email is during setemail ${uid?.value}");
    }
    return uid?.value;
  }

  // Getter for uid
  String? getUid() {
    // Try to get the UID from persistent storage
    String? storedUid = _storage.read('uid');
    if (storedUid != null) {
      uid?.value = storedUid;
      print("uid is during setuid ${uid?.value}");

    }
    return uid?.value;
  }

  // Initialization method to load data from storage when the controller is created
  @override
  void onInit() {
    super.onInit();
    // Load uid from storage
    String? storedUid = _storage.read('uid');
    print("on init uid $storedUid");
    if (storedUid != null) {
      uid?.value = storedUid;
    }
  }
}

// Instantiate UserController
final UserController userController = UserController();
