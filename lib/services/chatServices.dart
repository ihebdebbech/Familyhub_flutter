import 'dart:convert';
import 'package:flutter_application_1/models/chat.dart';
import 'package:flutter_application_1/models/room.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'https://backend-secure-payment-for-kids.onrender.com/chat';

  static Future<void> sendMessage(
      String username, String text, int roomId) async {
    final url = Uri.parse('$baseUrl/send');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'text': text,
        'room_id': roomId.toString(), // Add roomId to the request body
      },
    );
    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      throw Exception('Failed to send message');
    }
  }

static Future<List<Chat>> getRoomMessages(int roomId) async {
  // Construct the URL with query parameters for roomId
  final url = Uri.parse('$baseUrl/getRoomMessages?room_id=$roomId');

  // Make a GET request to the modified endpoint
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // Decode the JSON response into a list of Chat objects
    final List<dynamic> responseData = json.decode(response.body);
    return responseData.map((json) => Chat.fromJson(json)).toList();
  } else {
    // Throw an exception if the request failed
    throw Exception('Failed to get room messages');
  }
}


  static Future<List<Room>> getRooms(String username) async {
    final url = Uri.parse('$baseUrl/getRooms/$username');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get rooms');
    }
  }

  static Future<int> createRoom(
    String buyerUsername, String sellerUsername) async {
    final url = Uri.parse('$baseUrl/createRoom');
    final response = await http.post(
      url,
      body: {
        'buyer_username': buyerUsername,
        'seller_id': sellerUsername,
      },
    );
    if (response.statusCode == 201) {
      // Parse the response JSON
      final responseData = json.decode(response.body);
      final roomId = responseData['room_id'];
      print('Room created successfully');
      return roomId; // Return the room ID
    } else {
      throw Exception('Failed to create room');
    }
  }
}