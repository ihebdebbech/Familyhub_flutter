import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_application_1/models/request/payment_req.dart';
import 'package:flutter_application_1/models/response/payment_res.dart';
import 'package:flutter_application_1/services/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as https;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class PaymentHelper {
  final Logger _logger = Logger('MyApp');
  final storage = FlutterSecureStorage();
  static var client = https.Client();

  static Future<PaymentResModel> makePayment(int amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    // Create a PaymentReqModel object with the provided amount
    var paymentReq = PaymentReqModel(amount: amount, userId: userId!);

    // Serialize the PaymentReqModel to JSON
    var requestBody = paymentReqModelToJson(paymentReq);

    // Log the JSON data to be sent in the request body
    print('Request Body: $requestBody');

    // Define the request headers
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };

    // Construct the URL
    var url = Uri.https(Config.apiUrl, Config.paymentUrl);

    // Make the POST request with the serialized request body and headers
    var response =
        await client.post(url, headers: requestHeaders, body: requestBody);
    print(url);

    if (response.statusCode == 200) {
      var paymentRes = paymentResModelFromJson(response.body);
      print(paymentRes.result.link);
      return paymentRes;
    } else {
      throw Exception("Failed to make payment");
    }
  }

  Future<void> transfertochild(int amount, String childusername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print(childusername);
print("ihebbb");
    String? encrypted = await prefs.getString('encrypted');
    print(encrypted);
    print("ihebbb");
    developer.log('log me', name: 'my.app.category');
    _logger.info(encrypted);
    if (encrypted != null) {
      final url = Uri.parse(
          'https://backend-secure-payment-for-kids.onrender.com/api/payment/transfertochild'); // Replace with your create child endpoint
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'amount': amount,
        'parentid': userId,
        'cryptedkey': encrypted,
        'childusername': childusername,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          final responsedata = jsonDecode(response.body);

// Write value

          /*await storage.write(
            key: "iv:${childusername}",
            value: responsedata["iv"],
            aOptions: _getAndroidOptions());*/

          print(
              'Child money transfered successfully his private key crypted is :');
        } else {
          print('Failed to transfer money child: ${response.body}');
        }
      } catch (error) {
        print('Error transfering money child: $error');
      }
    } else {
      print("no private keyyyy for user found");
    }
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
}
