import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/reelProvider.dart';
import 'package:flutter_application_1/controller/reportReelProvider.dart';
import 'package:flutter_application_1/models/request/reportReel_req.dart';
import 'package:flutter_application_1/pages/addReel.dart';
import 'package:flutter_application_1/pages/pinball.dart';
import 'package:flutter_application_1/pages/scratch_card_demo_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reels_viewer/reels_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class reelsPage extends StatefulWidget {
  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<reelsPage> {
  late Future<List<ReelModel>> reelsListFuture;
  late var reels = [];
   late var reels2 = [];
  var indeX = 0;
  var indexcounter = 0;
  @override
  initState() {
    super.initState();
    _fetchReels();
    _getUserId();
  }

  Future<void> _fetchReels() async {
    final reelsNotifier = ReelsNotifier();
    reelsNotifier.getReels();

    reelsListFuture = reelsNotifier.reelsList;

    reelsListFuture.then((List<ReelModel> reelsList) {
      // Accessing data at a certain index
      reels = reelsList;

      // Now you can use the 'reel' object as needed
    });
  }

  Future<void> _fetchextraReels() async {
    final reelsNotifier = ReelsNotifier();
    reelsNotifier.getReels();
   late var reels2 = [];
    reelsListFuture = reelsNotifier.reelsList;
    reelsListFuture.then((List<ReelModel> reelsList) {
      // Accessing data at a certain index
      reels.addAll(reelsList);

      // Now you can use the 'reel' object as needed
    });
     print("reels.lengthhhhh");
    //reels.addAll(reels2);
     print("reels.lengthhhhh");
    print(reels.length);
    setState(() {
      reelsListFuture = Future.value(reels as FutureOr<List<ReelModel>>?);
    });
  }

  Future<void> addalike(String reelId) async {
    final reelsNotifier = ReelsNotifier();
    reelsNotifier.addalike(reelId);
  }

  Future<void> addaview(String reelId) async {
    final reelsNotifier = ReelsNotifier();
    reelsNotifier.addaview(reelId);
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString('userId')!;
    username = prefs.getString('username')!;
    print(userID);
  }

  late String reelID;
  String userID = "";
  String username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<ReelModel>>(
            future: reelsListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return const Center(
                  child: Text('Error fetching reels'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 180),
                  child: Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set the width to match the screen width
                    height: MediaQuery.of(context).size.height,
                    child: ReelsViewer(
                      reelsList: snapshot.data!,
                      indeX: indeX,
                      onLike: (url) async {
                        if (!reels[indeX].isLiked) {
                          var like = await addalike(url);
                          reels[indeX].likeCount += 1;
                          reels[indeX].isLiked = true;
                          setState(() {
                            reelsListFuture = Future.value(
                                reels as FutureOr<List<ReelModel>>?);
                            print(reelsListFuture);
                          });
                        }
                      },
                      onFollow: () {},
                      onClickMoreBtn: () {
                        print(
                            'Reel Owner Username: ${snapshot.data!.first.userName}');
                        print('Current Username: $username');

                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100, 100, 0, 0),
                          items: [
                            PopupMenuItem(
                              child: GestureDetector(
                                onTap: () {
                                  // Implement delete functionality here
                                  print("Delete video");
                                  Provider.of<ReelsNotifier>(context,
                                          listen: false)
                                      .deleteReel(
                                          snapshot.data!.first.id.toString());
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete),
                                    Text("Delete")
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ReportTypeBottomSheet(
                                        userID: userID,
                                        reelID:
                                            snapshot.data!.first.id.toString(),
                                      );
                                    },
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.report),
                                    Text("Report")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onClickBackArrow: () {
                        log('======> Clicked on back arrow <======');
                      },
                      onIndexChanged: (index) async {
                        addaview(reels[index - 1].id);
                        indeX = index;
                        indexcounter++;
                        if (indexcounter >= 3) {
                          indexcounter = 0;

                        
                       await    _fetchextraReels();
                        }
                        print(reels.length);
                      },
                      showProgressIndicator: true,
                      showVerifiedTick: false,
                      showAppbar: false,
                    ),
                  ),
                );
              }
            },
          ),
          Positioned(
            top: 20, // Adjust this value according to your design
            right: 20, // Adjust this value according to your design
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddVideoScreen()),
                );
              },
              backgroundColor: Colors.grey, // Set background color to white
              child: Icon(
                Icons.add,
                color: Colors.white, // Set icon color to black
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportTypeBottomSheet extends StatefulWidget {
  final String reelID;
  final String userID;

  const ReportTypeBottomSheet(
      {super.key, required this.reelID, required this.userID});
  @override
  _ReportTypeBottomSheetState createState() => _ReportTypeBottomSheetState();
}

class _ReportTypeBottomSheetState extends State<ReportTypeBottomSheet> {
  final List<String> reportTypes = [
    'Spam',
    'Hate Speech',
    'Violence',
    'Nudity',
    'Copyright Infringement',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reportTypes.length,
      itemBuilder: (BuildContext context, int index) {
        return Consumer<ReportNotifier>(
            builder: (context, reportNotifier, child) {
          return ListTile(
            title: Text(reportTypes[index]),
            onTap: () {
              ReportReelReq model = ReportReelReq(
                  userId: "65cbde1b4cdef616743bc873",
                  videoId: widget.reelID,
                  reportType: reportTypes[index]);
              reportNotifier.reportReel(model);
              // Handle report type selection
              print('Selected report type: ${reportTypes[index]}');
              Navigator.pop(context); // Close the bottom sheet
            },
          );
        });
      },
    );
  }
}
