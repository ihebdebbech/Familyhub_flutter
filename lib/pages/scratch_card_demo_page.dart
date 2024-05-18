import 'package:flutter/material.dart';
import 'package:flutter_application_1/res/colors.dart';
import 'package:flutter_application_1/widgets/load_image.dart';
import 'package:flutter_application_1/res/gaps.dart';
import 'package:flutter_application_1/util/theme_utils.dart';
import 'package:scratcher/scratcher.dart';

class ScratchCardDemoPage extends StatefulWidget {
  const ScratchCardDemoPage({Key? key}) : super(key: key);

  @override
  _ScratchCardDemoPageState createState() => _ScratchCardDemoPageState();
}

class _ScratchCardDemoPageState extends State<ScratchCardDemoPage> {
  late List<GlobalKey<ScratcherState>> scratchKeys;
  late List<String> images;
  late List<String> gameImages;
  int tries = 0;
  int matchesFound = 0;
  late String firstImage; // Variable to store the first image
  late int
      image1MatchesFound; // Track the number of instances of image1 revealed

  @override
  void initState() {
    super.initState();
    scratchKeys = List.generate(9, (index) => GlobalKey<ScratcherState>());

    // Initialize lists for images
    images = List.generate(6, (index) => 'image${index + 1}');
    gameImages = [];

    // Select three indices for images similar to image1
    List<int> similarIndices = [];
    for (int i = 0; i < 6; i++) {
      if (images[i] == 'image1') {
        similarIndices.add(i);
      }
    }

    // Shuffle similar indices and take the first three
    similarIndices.shuffle();
    similarIndices = similarIndices.take(3).toList();

    // Add three instances of image1 to gameImages
    gameImages.addAll(List.generate(3, (_) => 'image1'));

    // Add two instances of each remaining even image (except image1) to gameImages
    images.where((image) => image != 'image1').forEach((image) {
      if (int.parse(image.substring(5)) % 2 == 0) {
        // Check if the image number is even
        for (int i = 0; i < 2; i++) {
          gameImages.add(image);
        }
      }
    });

    // Shuffle the gameImages list
    gameImages.shuffle();

    // Assign the first image to the firstImage variable
    firstImage = gameImages[0];

    // Initialize image1MatchesFound to 0
    image1MatchesFound = 0;

    // Log initial game state
    debugPrint('Initial Game Images: $gameImages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.isDark ? Colours.dark_bg_color : Colors.blue,
        title: const Text('ScratchCard Game'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scratcher(
              key: scratchKeys[index],
              brushSize: 10,
              threshold: 30,
              color: Colors.grey,
              onChange: (value) => debugPrint(
                  'Scratch progress ${index + 1}: ${value.toStringAsFixed(2)}%'),
              onThreshold: () {
                debugPrint('Threshold reached for card ${index + 1}!');
                scratchKeys[index].currentState!.reveal(
                      duration: const Duration(milliseconds: 1000),
                    );

                // Check if the revealed image matches the first image
                if (gameImages[index] == firstImage) {
                  // Increment image1MatchesFound
                  image1MatchesFound++;
                  debugPrint('Image 1 Matches Found: $image1MatchesFound');
                  if (image1MatchesFound == 3) {
                    // Check win condition
                    _showWinDialog();
                    debugPrint('Win Condition Reached!');
                  }
                }

                tries++;
                debugPrint('Tries: $tries');
                if (tries >= 6 && matchesFound < 3) {
                  // Check loss condition
                  debugPrint('Loss Condition Reached!');
                  _showLossDialog();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: LoadAssetImage(
                    gameImages[index]), // Assign each scratcher a unique image
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            child: const Text('Reset All'),
            onPressed: () {
              _resetGame();
            },
          ),
          ElevatedButton(
            child: const Text('Reveal All'),
            onPressed: () {
              for (var key in scratchKeys) {
                key.currentState!.reveal(
                  duration: const Duration(milliseconds: 2000),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You won the game!'),
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

  void _showLossDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('You lost the game!'),
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

  void _resetGame() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }
}
