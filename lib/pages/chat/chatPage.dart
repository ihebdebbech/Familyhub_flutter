import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/chat.dart';
import 'package:flutter_application_1/services/chatServices.dart';
import 'package:flutter_application_1/services/chatSocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessengerScreen extends StatefulWidget {
  final int roomId;
  const MessengerScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  late String _username;
  List<Chat> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _initializeSocket();
  }

  void _initializeSocket() {
    ChatSocket.onMessageReceived((messageData) {
      print(messageData['room_id']);
      if (messageData['room_id'] == widget.roomId) {
        // Construct a Chat object from the received message data
        Chat receivedMessage = Chat(
          username: messageData['username'],
          text: messageData['text'],
          image: '',
          roomId: widget.roomId,
        );
        print(receivedMessage);

        // Update the UI by adding the received message to the message list
        setState(() {
          messages.insert(0,
              receivedMessage); // Insert message at the beginning of the list
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the stored username with a default fallback value if not found
    _username = prefs.getString('username') ?? 'parentTest';
    // Fetch initial messages and update the state.
    try {
      final initialMessages = await _fetchMessages();
      if (!mounted) return;
      setState(() {
        messages = initialMessages;
      });
    } catch (error) {
      print('Error initializing messages: $error');
    }
  }

  Future<List<Chat>> _fetchMessages() async {
    try {
      final List<Chat> messages =
          await ChatService.getRoomMessages(widget.roomId);
      return messages;
    } catch (error) {
      print('Error fetching messages: $error');
      return [];
    }
  }

  void _sendMessage() async {
    final String text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      try {
        // Call the sendMessage function from the service
        await ChatService.sendMessage(_username, text, widget.roomId);
        // Clear the text field after sending the message
        _textEditingController.clear();
        // Create a new Chat object for the sent message
        Chat sentMessage = Chat(
          username: _username,
          text: text,
          image: '',
          roomId: widget.roomId,
        );
        // Update the message list locally by adding the sent message
        setState(() {
          messages.insert(
              0, sentMessage); // Insert message at the beginning of the list
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch (error) {
        print('Error sending message: $error');
        // Handle error sending message
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Chat>>(
              future: _fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a spinner while waiting for data
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Show an error message if data fetching fails
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Display the message list once messages are loaded
                  final messages = snapshot.data!;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return buildMessageWidget(message);
                    },
                  );
                }
              },
            ),
          ),
          _buildMessageInputWidget(),
        ],
      ),
    );
  }

  Widget buildMessageWidget(Chat message) {
    final bool isMyMessage = message.username == _username;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          SizedBox(width: 16.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
