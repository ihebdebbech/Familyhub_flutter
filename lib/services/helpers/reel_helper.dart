import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/like.dart';

import 'package:flutter_application_1/models/request/reel_req.dart';
import 'package:flutter_application_1/models/response/reel_res.dart';
import 'package:flutter_application_1/models/view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/services/config.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReelHelper {
  static var client = http.Client();
//teestcommit
  static Future<List<ReelModel>> getReels() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    var jsonData = jsonEncode({"userId" : userId});
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    //var url = Uri.http(Config.apiUrl, Config.reelUrl);http://localhost:9090/api/
    var url = "https://backend-secure-payment-for-kids.onrender.com/api/getrecommendedreel";
    var response = await client.post(
      Uri.parse(url),
      //url,
       body: jsonData,
      headers: requestHeaders,
    );

    final responsedata = jsonDecode(response.body);
    // print(responsedata);

    if (response.statusCode == 201) {
      var responseBody = response.body;
      if (responseBody.isNotEmpty) {
        var postsList = getAllUsersReelsResFromJson(responseBody);
        print(responseBody);
        var reelsList = mapReelResListToReelModelList(postsList);
        return reelsList; // Return an empty list if reelsList is null
      } else {
        throw Exception("Empty response body");
      }
    } else {
      throw Exception(
          "Failed to get Reels. Status code: ${response.statusCode}");
    }
  }

  static Future<void> addReel(ReelReq reelData) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var url = Uri.https(Config.apiUrl, Config.reelUrl);
    // Convert reelData to JSON string
    var jsonData = jsonEncode(reelData.toJson());
    print('Reel Data (JSON): $jsonData');

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonData,
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print('Reel added successfully');
    } else {
      throw Exception(
          'Failed to add Reel. Status code: ${response.statusCode}');
    }
  }

  static Future<void> addalike(String reelId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
  
    var like = Like(userId: userId!, reelId: reelId);
    var jsonData = jsonEncode(like.toJson());
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var url = "https://backend-secure-payment-for-kids.onrender.com/api/reel/addalike";
    var response = await client.post(
      Uri.parse(url),
      //url,
      headers: requestHeaders,
      body: jsonData,
    );

    final responsedata = jsonDecode(response.body);

    print('Response Status Code for like: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print('like added successfully');
    } else {
      throw Exception(
          'Failed to add view. Status code: ${response.statusCode}');
    }
  }
   static Future<void> addaview(String reelId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
  
    var view = Viewreel(userId: userId!, reelId: reelId, );
    var jsonData = jsonEncode(view.toJson());
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var url = "https://backend-secure-payment-for-kids.onrender.com/api/reel/addaview";
    var response = await client.post(
      Uri.parse(url),
      //url,
      headers: requestHeaders,
      body: jsonData,
    );

    final responsedata = jsonDecode(response.body);

    print('Response Status Code for view: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      print('view added successfully');
    } else {
      throw Exception(
          'Failed to add view. Status code: ${response.statusCode}');
    }
  }
  static Future<void> deleteReel(String reelId) async {
    // Define request headers
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Construct the URL for the delete request
    var url = Uri.https(Config.apiUrl, '${Config.reelUrl}/$reelId');

    try {
      // Send the delete request
      var response = await client.delete(
        url,
        headers: requestHeaders,
      );

      // Check the response status code
      if (response.statusCode == 200) {
        print('Reel deleted successfully');
      } else {
        throw Exception(
            'Failed to delete Reel. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the delete request
      print('Error deleting Reel: $e');
      throw Exception('Failed to delete Reel: $e');
    }
  }
}
