import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SecretKeyResetPage extends StatefulWidget {
  @override
  _SecretKeyResetPageState createState() => _SecretKeyResetPageState();
}

Future<Map<String, dynamic>> forgetKeys(
    String mnemonic, String accountId) async {
  final response = await http.post(
    Uri.parse(
        'https://backend-secure-payment-for-kids.onrender.com/parent/newPhrase'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'mnemonic': mnemonic,
      'accountId': accountId,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to update private key: ${response.body}');
  }
}

class _SecretKeyResetPageState extends State<SecretKeyResetPage> {
  TextEditingController _textController = TextEditingController();
  List<String> _wordList = []; // List to store entered words
  String _newPrivateKey = '';

  Future<void> _handleSubmit() async {
    if (_wordList.length != 12) {
      _showErrorDialog('Please enter 12 words.');
      return;
    }

    // Check if entered words match predefined words
    try {
      final Map<String, dynamic> data =
          await forgetKeys(_wordList.join(' '), "0.0.3971845");

      // Check if the response contains the privateKey
      if (data.containsKey('privateKey')) {
        setState(() {
          _newPrivateKey = data['privateKey'];

        });
      } else {
        _showErrorDialog('Please enter valid words.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secret Key Recover'),
        backgroundColor: Colors.white, // Set app bar background color
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white, // Set background color of the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  _wordList = value.split(' ');
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter 12 Words',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Set button background color
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Private Key:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, // Adjust font size
                color: Colors.black, // Set text color
              ),
            ),
            Text(
              _newPrivateKey ?? '', // Ensure _newPrivateKey is not null
              style: TextStyle(
                fontWeight: FontWeight.normal, // Set font weight to normal
                fontSize: 16, // Adjust font size
                color: Colors.grey, // Set text color
                fontStyle: FontStyle.italic, // Set italic style
              ),
            ),
            /* SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: Text('Get Back'),
            ),*/
          ],
        ),
      ),
    );
  }
}
