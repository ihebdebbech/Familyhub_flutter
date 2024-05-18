import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/ChildsApi.dart';
import 'package:flutter_application_1/services/helpers/updateProfile_helper.dart';

class UpdateProfileNotifier extends ChangeNotifier {
  final ChildApi childapi = ChildApi();
  String solde = '';
  Future<bool> updateProfile(
      String username, String email, int phoneNumber, String image) async {
    try {
      // Call the updateProfileHelper to perform the update operation
      await updateProfileHelper.updateProfile(
          username, email, phoneNumber, image);
      // Return true if the update was successful
      return true;
    } catch (e) {
      // Return false if there was an error during the update operation
      return false;
    }
  }

  Future<void> getsolde(String username) async {
    print(username);
    solde = await childapi.getsolde(username);
   notifyListeners();
  }
}
