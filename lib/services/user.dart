import 'dart:convert';
import 'package:flutter_application_1/models/ChildModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // Import the user model
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static Future<dynamic> signIn(String identifier, String password) async {
    try {
      print(identifier);
      print(password);
      var url = Uri.parse('https://backend-secure-payment-for-kids.onrender.com/signin');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? fcmToken = prefs.getString('tokendevice');

      var response = await http.post(url, body: {
        'identifier': identifier,
        'password': password,
        'fcmtoken': fcmToken,
      });

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);

        // Check if user role is "child"
        if (userData['role'] == 'child') {
          // If user role is "child", create a Child object
          final child = Child.fromJson(userData);
          // Store child data in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', child.username);
          prefs.setInt('number', child.phoneNumber);
          return child;
        } else {
          // If user role is not "child", create a User object
          final user = User.fromJson(userData);
          // Store user data in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('username', user.username);
          prefs.setString('email', user.email);
          prefs.setInt('number', user.phoneNumber);
          prefs.setBool('firsttime', userData['first_time']);
          print(userData['first_time']);

          return user;
        }
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to sign in error: $error');
    }
  }

  static Future<String> sendPasswordResetEmail(String email) async {
    final Uri uri = Uri.parse('https://backend-secure-payment-for-kids.onrender.com/forgot-password');
    final Map<String, String> requestBody = {'email': email};

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Password reset email sent successfully
        final jsonResponse = json.decode(response.body);
        final resetCode = jsonResponse['resetCode'];

        // Store the reset code in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('resetCode', resetCode);
        prefs.setString('email', email);
        print('Reset code: $resetCode');

        return 'Password reset email sent successfully';
      } else if (response.statusCode == 404) {
        return 'User not found';
      } else if (response.statusCode == 401) {
        return 'Your email is not verified yet, please verify your email first';
      } else {
        return 'Failed to send password reset email';
      }
    } catch (e) {
      print('Error sending password reset email: $e');
      return 'Internal server error';
    }
  }

  static Future<String> resetPassword(String email, String newPassword) async {
    final url = Uri.https('https://backend-secure-payment-for-kids.onrender.com', 'update-password');
    final Map<String, String> requestBody = {
      'email': email,
      'newPassword': newPassword,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return 'Password reset successfully';
      } else {
        return 'Failed to reset password';
      }
    } catch (e) {
      print('Error resetting password: $e');
      return 'Internal server error';
    }
  }
}

Future<String> firstimereset(String email, String newPassword) async {
  final storage = FlutterSecureStorage();
  final Map<String, String> requestBody = {
    'email': email,
    'newPassword': newPassword,
  };

  try {
    final response = await http.post(
      Uri.parse('https://backend-secure-payment-for-kids.onrender.com/resetfirsttime'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      var userData = jsonDecode(response.body);

      // Store user data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var username = prefs.getString('username');
      await storage.write(
        key: "crypt:${username}",
        value: userData['encrypted'],
        aOptions: _getAndroidOptions(),
      );
      String? value = await storage.read(
          key: "crypt:${username}", aOptions: _getAndroidOptions());
      print('Child created successfully his private key crypted is :$value');
          prefs.setBool('firsttime', false);
      return 'Password reset successfully';
    } else {
      return 'Failed to reset password';
    }
  } catch (e) {
    print('Error resetting password: $e');
    return 'Internal server error';
  }
}

Future<dynamic> signinwithsecret(String mnemonic) async {
  final storage = FlutterSecureStorage();
  final response = await http.post(
    Uri.parse('https://backend-secure-payment-for-kids.onrender.com/signinwithsecret'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'mnemonic': mnemonic,
    }),
  );

  if (response.statusCode == 200) {
    var userData = jsonDecode(response.body);
    print(userData);
    print(userData['privatekey']);
    // Check if user role is "child"
    if (userData['role'] == 'child') {
      // If user role is "child", create a Child object
      final child = Child.fromJson(userData);
      // Store child data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', child.username);
      prefs.setInt('number', child.phoneNumber);
      await storage.write(
        key: "crypt:${child.username}",
        value: userData['privatekey'],
        aOptions: _getAndroidOptions(),
      );
      return child;
    } else {
      // If user role is not "child", create a User object
      final user = User.fromJson(userData);
      // Store user data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', user.username);
      prefs.setString('email', user.email);
      prefs.setInt('number', user.phoneNumber);
      await storage.write(
        key: "crypt:${user.username}",
        value: userData['privatekey'],
        aOptions: _getAndroidOptions(),
      );
      return user;
    }
  } else {
    throw Exception('Failed to sign in: ${response.statusCode}');
  }
}

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
      // sharedPreferencesName: 'Test2',
      // preferencesKeyPrefix: 'Test'
    );
