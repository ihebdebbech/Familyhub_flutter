import 'dart:convert';

updateProfileReqModel updateProfileReqModelFromJson(String str) =>
    updateProfileReqModel.fromJson(json.decode(str));

String updateProfileReqModelToJson(updateProfileReqModel data) =>
    json.encode(data.toJson());

class updateProfileReqModel {
  final String Username;
  final int PhoneNumber;
  final String image;
  final String Email;

  updateProfileReqModel({
    required this.Username,
    required this.PhoneNumber,
    required this.image,
    required this.Email,
  });

  factory updateProfileReqModel.fromJson(Map<String, dynamic> json) =>
      updateProfileReqModel(
        Username: json["Username"],
        PhoneNumber: json["PhoneNumber"],
        image: json["image"],
        Email: json["Email"],
      );

  Map<String, dynamic> toJson() => {
        "Username": Username,
        "Email": Email,
        "image": image,
        "PhoneNumber": PhoneNumber,
      };
}
