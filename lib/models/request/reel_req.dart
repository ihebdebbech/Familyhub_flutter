import 'dart:convert';

ReelReq reelReqFromJson(String str) => ReelReq.fromJson(json.decode(str));

String reelReqToJson(ReelReq data) => json.encode(data.toJson());

class ReelReq {
  String? id;
  final String url;
  List<LikeCount>? likeCount;
  final String userName;
  String? profileUrl;
  final String reelDescription;
  final String musicName;
  List<CommentList>? commentList;
  int? v;

  ReelReq({
    this.id,
    required this.url,
    this.likeCount,
    required this.userName,
    this.profileUrl,
    required this.reelDescription,
    required this.musicName,
    this.commentList,
    this.v,
  });

  factory ReelReq.fromJson(Map<String, dynamic> json) => ReelReq(
        id: json["_id"],
        url: json["url"],
        likeCount: List<LikeCount>.from(
            json["likeCount"].map((x) => LikeCount.fromJson(x))),
        userName: json["userName"],
        profileUrl: json["profileUrl"],
        reelDescription: json["reelDescription"],
        musicName: json["musicName"],
        commentList: List<CommentList>.from(
            json["commentList"].map((x) => CommentList.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        // Convert the nullable id field to JSON
        "url": url,
        "likeCount": likeCount != null && likeCount!.isNotEmpty
            ? List<dynamic>.from(likeCount!.map((x) => x.toJson()))
            : [], // Convert the likeCount list to JSON if it's not null or empty
        "userName": userName,
        "profileUrl":
            profileUrl ?? "", // Convert the nullable profileUrl field to JSON
        "reelDescription": reelDescription,
        "musicName": musicName,
        "commentList": commentList != null && commentList!.isNotEmpty
            ? List<dynamic>.from(commentList!.map((x) => x.toJson()))
            : [], // Convert the commentList list to JSON if it's not null or empty
        // Convert the nullable v field to JSON
      };
}

class CommentList {
  final String comment;
  final String userProfilePic;
  final String userName;
  final DateTime commentTime;
  final String id;

  CommentList({
    required this.comment,
    required this.userProfilePic,
    required this.userName,
    required this.commentTime,
    required this.id,
  });

  factory CommentList.fromJson(Map<String, dynamic> json) => CommentList(
        comment: json["comment"],
        userProfilePic: json["userProfilePic"],
        userName: json["userName"],
        commentTime: DateTime.parse(json["commentTime"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "userProfilePic": userProfilePic,
        "userName": userName,
        "commentTime": commentTime.toIso8601String(),
        "_id": id,
      };
}

class LikeCount {
  final String userId;
  final String reelId;
  final String id;

  LikeCount({
    required this.userId,
    required this.reelId,
    required this.id,
  });

  factory LikeCount.fromJson(Map<String, dynamic> json) => LikeCount(
        userId: json["userId"],
        reelId: json["reelId"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "reelId": reelId,
        "_id": id,
      };
}
