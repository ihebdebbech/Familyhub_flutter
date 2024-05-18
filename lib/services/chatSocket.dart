import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatSocket {
  static const String _usernameKey = 'username';
  static late SharedPreferences _prefs;
  static late io.Socket _socket;

  // Maintain a list of callbacks to handle new message events.
  static final List<Function(Map<String, dynamic>)> _messageListeners = [];

  static Future<void> init() async {
    print('Socket starting...');
    _prefs = await SharedPreferences.getInstance();

    // Assuming username is used for some functionality, though it's not used directly below.
    final username = _prefs.getString(_usernameKey) ?? 'houba-';

    _socket = io.io('https://backend-secure-payment-for-kids.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.on('connect', (_) => print('Connected to server'));
    _socket.on('disconnect', (_) => print('Disconnected from server'));

    // Setup a listener for 'chatMessage' events to notify all registered callbacks.
    _socket.on('chatMessage', (data) {
      // 'data' should already be a Map<String, dynamic> if the socket_io_client package automatically decodes JSON strings.
      if (data is Map<String, dynamic>) {
        _notifyMessageListeners(data);
        print("message");
      } else {
        print(
            'Unexpected data type received: ${data.runtimeType}. Expected Map<String, dynamic>.');
      }
    });

    _socket.connect(); // Manually trigger the connection.
  }

  // Method to register callbacks that should be invoked when a new message is received.
  static void onMessageReceived(Function(Map<String, dynamic>) callback) {
    print("callback");
    print(callback);
    _messageListeners.add(callback);
  }

  // Helper method to iterate over all registered listeners and pass them the new message data.
  static void _notifyMessageListeners(Map<String, dynamic> messageData) {
    for (var listener in _messageListeners) {
      listener(messageData);
    }
  }
}