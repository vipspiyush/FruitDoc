class UserModel {
  String name;
  String phoneNumber;
  String uid;

  UserModel(
      {required this.name,
        required this.phoneNumber,
        required this.uid});

  //to Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  //from Json to object back

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
