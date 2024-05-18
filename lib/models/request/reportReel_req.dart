import 'dart:convert';

ReportReelReq reportReelReqFromJson(String str) =>
    ReportReelReq.fromJson(json.decode(str));

String reportReelReqToJson(ReportReelReq data) => json.encode(data.toJson());

class ReportReelReq {
  final String userId;
  final String videoId;
  final String reportType;

  ReportReelReq({
    required this.userId,
    required this.videoId,
    required this.reportType,
  });

  factory ReportReelReq.fromJson(Map<String, dynamic> json) => ReportReelReq(
        userId: json["userId"],
        videoId: json["videoId"],
        reportType: json["reportType"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "videoId": videoId,
        "reportType": reportType,
      };
}
