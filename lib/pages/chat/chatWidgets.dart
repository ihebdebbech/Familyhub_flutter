import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/chatServices.dart';
import 'package:flutter_application_1/models/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  late Future<List<Chat>> _messagesFuture;
  late String _username;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      // Get the stored username with a default fallback value if not found
      _username = prefs.getString('username') ?? 'parentTest';
      //_messagesFuture = ChatService.getRoomMessages(_username);
      setState(() {}); // Trigger a rebuild once data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          TitleWidget(),
          Expanded(
            child: FutureBuilder<List<Chat>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final messages = snapshot.data!;
                  return MessageListWidget(messages: messages);
                }
              },
            ),
          ),
          MessageInputWidget(),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Chat Room',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MessageInputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          SizedBox(width: 16.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Send message functionality
            },
          ),
        ],
      ),
    );
  }
}

class MessageListWidget extends StatelessWidget {
  final List<Chat> messages;
  

  const MessageListWidget({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        // Determine if the message is from "mohamed"
        final isMyMessage = message.username == 'mohamed';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment:
                isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}