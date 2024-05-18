import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/reelProvider.dart';
import 'package:flutter_application_1/models/request/reel_req.dart';
import 'package:flutter_application_1/theme/theme_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  late VideoPlayerController _controller;
  TextEditingController _reelDescriptionController = TextEditingController();
  TextEditingController _musicNameController = TextEditingController();

  String? storedUsername; // Declare storedUsername here

  @override
  void initState() {
    super.initState();
    getStoredUsername().then((value) {
      setState(() {
        storedUsername = value;
      });
    });

    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _reelDescriptionController.dispose();
    _musicNameController.dispose();
  }

  Future<String?> getStoredUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String> uploadVideo(File videoFile) async {
    // Create a reference to the video in Firebase Storage
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('videos1')
        .child('video_${DateTime.now().millisecondsSinceEpoch}.mp4');

    // Upload the video file to Firebase Storage
    await ref.putFile(videoFile);

    // Get the download URL of the uploaded video
    final downloadURL = await ref.getDownloadURL();

    // Return the download URL
    return downloadURL;
  }

  pickVideo(ImageSource src) async {
    final video = await ImagePicker().pickVideo(source: src);
    if (video != null) {
      final videoFile = File(video.path);
      final downloadURL = await uploadVideo(videoFile);

      // Set the video URL to the download URL
      setState(() {
        _controller = VideoPlayerController.network(downloadURL)
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  _showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () => pickVideo(ImageSource.gallery),
              child: const ListTile(
                leading: Icon(Icons.image),
                title: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const ListTile(
                leading: Icon(Icons.cancel),
                title: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Video'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20), // Add padding for consistent spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_controller.value.isInitialized)
              Container(
                height: 200, // Adjust the height according to your preference
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              const CircularProgressIndicator(),
            SizedBox(height: 20),
            TextFormField(
              controller: _reelDescriptionController,
              decoration: InputDecoration(
                labelText: 'Reel Description',
                labelStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                hintText: 'Enter your reel description...',
                hintStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Color(0xFF17233D),
                ),
                errorStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Color.fromARGB(255, 159, 24, 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 253, 252),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 152, 41, 0),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF17233D),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 253, 254, 255),
                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 12),
              ),
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: Color(0xFF17233D),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _musicNameController,
              decoration: InputDecoration(
                labelText: 'Music Name',
                labelStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                hintText: 'Enter the name of the music...',
                hintStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Color(0xFF17233D),
                ),
                errorStyle: TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Color.fromARGB(255, 159, 24, 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 253, 252),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 152, 41, 0),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF17233D),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 253, 254, 255),
                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 12, 0, 12),
              ),
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: Color(0xFF17233D),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showDialogBox(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding
              ),
              child: Text(
                'Pick Video',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ReelReq reel = ReelReq(
                  userName: storedUsername ?? '',
                  reelDescription: _reelDescriptionController.text,
                  musicName: _musicNameController.text,
                  url: _controller.dataSource!,
                );
                Provider.of<ReelsNotifier>(context, listen: false)
                    .addReel(reel);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding
              ),
              child: Text(
                'Confirm'.toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
