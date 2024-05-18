import 'dart:convert';

class Child {
  final String? id;
  final String username;

  final String password;
  final String? role;
  final String image;
  String? parentId;
  final int phoneNumber;
  final String? addressBlockchain;
  final List<String> prohibitedProductTypes;
  String? rfidtag;
  Child({
    this.id,
    required this.username,
    required this.password,
    this.role,
    required this.image,
    this.parentId,
    required this.phoneNumber,
    this.addressBlockchain,
    required this.prohibitedProductTypes,
    this.rfidtag,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['_id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
      image: json['image'],
      parentId: json['parentid'],
      phoneNumber: json['phoneNumber'],
      addressBlockchain: json['adressblockchain'],
      prohibitedProductTypes: json['prohibitedProductTypes'] != null
          ? List<String>.from(json['prohibitedProductTypes'])
          : [],
      rfidtag: json['rfid_tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role,
      'image': image,
      'parentid': parentId,
      'phoneNumber': phoneNumber,
      'adressblockchain': addressBlockchain,
      'prohibitedProductTypes': prohibitedProductTypes,
      'rfid_tag': rfidtag,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
