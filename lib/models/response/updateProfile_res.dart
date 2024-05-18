import 'dart:convert';

UpdateProfileResModel updateProfileResModelFromJson(String str) =>
    UpdateProfileResModel.fromJson(json.decode(str));

String updateProfileResModelToJson(UpdateProfileResModel data) =>
    json.encode(data.toJson());

class UpdateProfileResModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role;
  final String image;
  final int PhoneNumber;
  final List<String> prohibitedProductTypes;
  final bool verified;
  final bool banned;
  final int v;

  UpdateProfileResModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.image,
    required this.PhoneNumber,
    required this.prohibitedProductTypes,
    required this.verified,
    required this.banned,
    required this.v,
  });

  factory UpdateProfileResModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResModel(
        id: json["_id"],
        username: json["Username"],
        email: json["Email"],
        password: json["Password"],
        role: json["Role"],
        image: json["image"],
        PhoneNumber: json["PhoneNumber"],
        prohibitedProductTypes:
            List<String>.from(json["ProhibitedProductTypes"].map((x) => x)),
        verified: json["Verified"],
        banned: json["Banned"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Username": username,
        "Email": email,
        "Password": password,
        "Role": role,
        "image": image,
        "PhoneNumber": PhoneNumber,
        "ProhibitedProductTypes":
            List<dynamic>.from(prohibitedProductTypes.map((x) => x)),
        "Verified": verified,
        "Banned": banned,
        "__v": v,
      };
}
