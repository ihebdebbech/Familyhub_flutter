import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/chat.dart';
import 'package:flutter_application_1/services/chatServices.dart';

class ChatMessageProvider with ChangeNotifier {
  List<Chat> _messages = [];

  List<Chat> get messages => _messages;

  Future<void> fetchMessages(int roomId) async {
    _messages = await ChatService.getRoomMessages(roomId);
    notifyListeners();
  }

  Future<void> sendMessage(String username, String message, int roomId) async {
    try {
      await ChatService.sendMessage(username, message, roomId);
      // Optionally fetch the latest messages here or add the new message to the list
      await fetchMessages(roomId); // For simplicity, refetching all messages
    } catch (error) {
      print('Error sending message: $error');
    }
  }
}
