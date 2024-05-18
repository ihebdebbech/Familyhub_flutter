import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/chatServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomsPage extends StatefulWidget {
  const ChatRoomsPage({Key? key}) : super(key: key);

  @override
  _ChatRoomsPageState createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  List<dynamic> _chatRooms = []; // List to hold fetched chat rooms

  @override
  void initState() {
    super.initState();
    _fetchChatRooms(); // Fetch chat rooms when the page is initialized
  }

  Future<void> _fetchChatRooms() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the stored username with a default fallback value if not found
    String username = prefs.getString('username') ?? 'parentTest';

    try {
      final chatRooms = await ChatService.getRooms(
          username);
      setState(() {
        _chatRooms = chatRooms;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch chat rooms: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Rooms'),
      ),
      body: _chatRooms.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = _chatRooms[index];
                return ListTile(
                  title: Text(chatRoom[
                      'name']), // Replace 'name' with the actual property name of the chat room
                  // Add onTap handler to navigate to chat room page
                  onTap: () {
                    // Navigate to chat room page
                    // You can pass the chat room information to the chat room page if needed
                    // Example: Navigator.pushNamed(context, '/chatroom', arguments: chatRoom);
                  },
                );
              },
            ),
    );
  }
}