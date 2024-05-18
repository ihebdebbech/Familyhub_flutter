import 'dart:convert';

import 'package:flutter_application_1/models/request/reportReel_req.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_1/services/config.dart';

class ReportlHelper {
  static var client = http.Client();

  static Future reportVideo(ReportReelReq model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    var url = Uri.http(Config.apiUrl, Config.reportReel);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      return [true];
    } else {
      return [false];
    }
  }
}
