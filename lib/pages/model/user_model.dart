import 'dart:convert';


class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? icNumber;
  String? phoneNumber;
  List? modelData;

  UserModel({this.uid, this.email, this.fullName, this.icNumber,this.phoneNumber, this.modelData,});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      icNumber: map['icNumber'],
      phoneNumber: map['phoneNumber'],
      modelData: jsonDecode(map['model_data']),
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'icNumber':icNumber,
      'phoneNumber':phoneNumber,
      'model_data': jsonEncode(modelData),
    };
  }
}