import 'dart:convert';
import 'dart:io';

import 'package:reels_viewer/reels_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<ReelRes> getAllUsersReelsResFromJson(String str) =>
    List<ReelRes>.from(json.decode(str).map((x) => ReelRes.fromJson(x)));

class ReelRes {
  final String? id;
  final String url;
  final List<LikeCount>? likeCount;
  final String userName;
  final String? profileUrl;
  final String reelDescription;
  final String musicName;
  final List<CommentList>? commentList;
  final int? v;

  ReelRes({
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
  factory ReelRes.fromJson(Map<String, dynamic> json) => ReelRes(
        id: json["_id"],
        url: json["url"],
        likeCount: json["likeCount"] != null
            ? List<LikeCount>.from(
                json["likeCount"].map((x) => LikeCount.fromJson(x)))
            : null,
        userName: json["userName"],
        profileUrl: json["profileUrl"],
        reelDescription: json["reelDescription"],
        musicName: json["musicName"],
        commentList: json["commentList"] != null
            ? List<CommentList>.from(
                json["commentList"].map((x) => CommentList.fromJson(x)))
            : null,
        v: json["__v"],
      );
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

Future<List<ReelModel>> mapReelResListToReelModelList(
    List<ReelRes> reelResList) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  return reelResList.map((reelRes) {
    var liked = false;
    if (reelRes.likeCount != null) {
      for (var like in reelRes.likeCount!) {
       
        if (like.userId == userId) {
          liked = true;
          break;
        }      
      }    
    }
    return ReelModel(
      reelRes.url,
      reelRes.userName,
      id: reelRes.id,
      isLiked: liked,
      likeCount: reelRes.likeCount?.length ?? 0,
      profileUrl: reelRes.profileUrl,
      reelDescription: reelRes.reelDescription,
      musicName: reelRes.musicName,
      commentList: reelRes.commentList
          ?.map((comment) => ReelCommentModel(
                id: comment.id,
                comment: comment.comment,
                userProfilePic: comment.userProfilePic,
                userName: comment.userName,
                commentTime: comment.commentTime,
              ))
          .toList(),
    );
  }).toList();
}
