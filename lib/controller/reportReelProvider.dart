import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/request/reportReel_req.dart';
import 'package:flutter_application_1/services/helpers/report_helper.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReportNotifier extends ChangeNotifier {
  reportReel(ReportReelReq model) {
    ReportlHelper.reportVideo(model).then((value) {
      Get.snackbar("Reel Reported successfully", "Please Check your bookmarks",
          colorText: Colors.green,
          backgroundColor: Colors.white,
          icon: const Icon(Icons.report));
    });
  }
}
