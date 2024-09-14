// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

class UserModel {
  int id;
  String firstName;
  String lastName;
  String? niceName;
  String? phoneNumber;
  String email;
  String? sex;
  String? avatar;
  String status;
  String apiToken;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.niceName,
    this.phoneNumber,
    required this.email,
    this.sex,
    this.avatar,
    required this.status,
    required this.apiToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        niceName: json["nice_name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        sex: json["sex"],
        avatar: json["avatar"],
        status: json["status"],
        apiToken: json["api_token"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "nice_name": niceName,
        "phone_number": phoneNumber,
        "email": email,
        "sex": sex,
        "avatar": avatar,
        "status": status,
        "api_token": apiToken,
      };

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? niceName,
    String? phoneNumber,
    String? email,
    String? sex,
    String? avatar,
    String? status,
    String? apiToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      niceName: niceName ?? this.niceName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      sex: sex ?? this.sex,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      apiToken: apiToken ?? this.apiToken,
    );
  }
}
