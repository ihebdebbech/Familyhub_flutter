import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/chat/chatPage.dart';
import 'package:flutter_application_1/services/chatServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatDirectoryPage extends StatefulWidget {
  const ChatDirectoryPage({Key? key}) : super(key: key);

  @override
  _ChatDirectoryPageState createState() => _ChatDirectoryPageState();
}

class _ChatDirectoryPageState extends State<ChatDirectoryPage> {
  late Future<List<dynamic>> _roomsFuture;
  late String username;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      // Get the stored username with a default fallback value if not found
      username = prefs.getString('username') ?? 'parentTest';
      _roomsFuture = ChatService.getRooms(username); // Call getRooms function
      setState(() {}); // Trigger a rebuild once data is fetched
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Directory'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0), // Add horizontal padding
              itemCount: rooms.length * 2 -
                  1, // Double the item count to add space between rooms
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return SizedBox(height: 8.0); // Add space between rooms
                }
                final roomIndex = index ~/ 2;
                final room = rooms[roomIndex];
                // Determine the other user's name
                final otherUsername = room.buyerUsername == username
                    ? room.sellerUsername
                    : room.buyerUsername;

                return Container(
                  color: Colors.yellow
                      .withOpacity(0.5), // Set yellow background color
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Add vertical padding
                      child: Text(
                        'Chatting with $otherUsername',
                        style: TextStyle(
                          fontSize:
                              18.0, // Set font size for the other user's name
                          fontWeight: FontWeight
                              .bold, // Set font weight for the other user's name
                          color: Colors.blue, // Set blue text color
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigate to ChatPage and pass the room ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessengerScreen(roomId: room.roomId),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}