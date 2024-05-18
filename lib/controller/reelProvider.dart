import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/request/reel_req.dart';
import 'package:flutter_application_1/services/helpers/reel_helper.dart';
import 'package:reels_viewer/reels_viewer.dart';

class ReelsNotifier extends ChangeNotifier {
  late Future<List<ReelModel>> reelsList;

  getReels() {
    reelsList = ReelHelper.getReels();
  }

  void addReel(ReelReq reel) {
    ReelHelper.addReel(reel);
  }
  void addalike(String reelId) {
    ReelHelper.addalike(reelId);
  }
  void addaview(String reelId) {
    ReelHelper.addaview(reelId);
  }
  void deleteReel(String reelid) {
    ReelHelper.deleteReel(reelid);
  }
}
