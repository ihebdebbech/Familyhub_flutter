import 'dart:convert';
import 'package:flutter_application_1/models/Notificationsmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class notificationservices {
  final String baseUrl =
      'https://backend-secure-payment-for-kids.onrender.com/api'; // Replace with your API base URL

  Future<void> createnotification(notification notif) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final url = Uri.parse('$baseUrl/notifications/add');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({...notif.toJson(), 'recipientId': userId});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Notification created successfully for user $userId');
      } else {
        print('Failed to create notification: ${response.body}');
      }
    } catch (error) {
      print('Error creating notification: $error');
    }
  }

  Future<List<notification>> getnotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    final response = await http.get(
      Uri.parse('$baseUrl/notifications/$userId'),
    );
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return jsonResponse.map((notif) => notification.fromJson(notif)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> sendNotificationReact(
      Map<String, dynamic> notification, String iduser) async {
    final url = Uri.parse('$baseUrl/send-notification-react');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'notification': notification, 'iduser': iduser});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
  Future<void> sendNotificationReactyes(
      Map<String, dynamic> notification, String iduser,String crypted,String username, String amount ) async {
    final url = Uri.parse('$baseUrl/send-notification-reactyes');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'notification': notification, 'iduser': iduser , 'crypted':crypted,'username':username,'amount':amount });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (error) {
      print('Error sending notification: $error');
    }
  }
}
