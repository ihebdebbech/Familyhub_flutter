import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerParent(
    String username, String email, String password, String phoneNumber) async {
       final storage = FlutterSecureStorage();
  try {
    final url = Uri.parse('https://backend-secure-payment-for-kids.onrender.com/parent/register');
    final Map<String, String> body = {
      'username': username,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body), // Encode body to JSON string
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Extracting data from the response
      final String encrypted = responseData['encrypted'];
      
      final String responseUsername = responseData['parent']['username'];
      final String responseEmail = responseData['parent']['email'];
      final bool verified = responseData['parent']['verified'];
       await storage.write(
          key: "crypt:${responseUsername}",
          value:encrypted,
          aOptions: _getAndroidOptions(),
        );

      // Save data to shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('encrypted', encrypted);
      
      await prefs.setString('username', responseUsername);
      await prefs.setString('email', responseEmail);
      await prefs.setBool('verified', verified);

      print('Registration successful');
    } else {
      print('Registration failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error registering user: $error');
  }
}
 AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
