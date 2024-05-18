import 'package:flutter_application_1/models/request/updateProfile_req.dart';
import 'package:flutter_application_1/models/response/updateProfile_res.dart';
import 'package:flutter_application_1/services/config.dart';
import 'package:http/http.dart' as https;

import 'package:shared_preferences/shared_preferences.dart';

class updateProfileHelper {
  static var client = https.Client();

  static Future<UpdateProfileResModel> updateProfile(
      String username, String email, int PhoneNumber, String image) async {
    // Create a PaymentReqModel object with the provided amount
    var updateReq = updateProfileReqModel(
        Username: username,
        Email: email,
        PhoneNumber: PhoneNumber,
        image: image);

    // Serialize the PaymentReqModel to JSON
    var requestBody = updateProfileReqModelToJson(updateReq);

    // Log the JSON data to be sent in the request body
    print('Request Body: $requestBody');

    // Define the request headers
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    // Construct the URL
    var url = Uri.http(Config.apiUrl, Config.updateProfile);

    // Make the POST request with the serialized request body and headers
    var response =
        await client.put(url, headers: requestHeaders, body: requestBody);
    print(url);

    if (response.statusCode == 200) {
      var updateRes = updateProfileResModelFromJson(response.body);

      // Store the reset code in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', updateRes.username);
      prefs.setString('Email', updateRes.email);
      prefs.setInt('number', updateRes.PhoneNumber);
      print(prefs.getInt('number'));
      return updateRes;
    } else {
      throw Exception("Failed to make update profile");
    }
  }
}
