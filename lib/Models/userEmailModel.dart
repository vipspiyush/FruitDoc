class UserEmailModel {
  String email;
  String loginType;
  String uid;

  UserEmailModel(
      {
        required this.email,
        required this.loginType,
        required this.uid});

  //to Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'loginType': loginType,
    };
  }

  //from Json to object back

  factory UserEmailModel.fromJson(Map<String, dynamic> json) {
    return UserEmailModel(
      uid: json['uid'],
      email: json['email'], loginType: json['loginType'],
    );
  }
}
