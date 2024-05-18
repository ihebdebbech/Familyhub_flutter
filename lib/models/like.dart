import 'dart:convert';

class Like {
  final String? id;
  final String userId;
  final String reelId;
  

  Like({
    this.id,
    required this.userId,
  
    required this.reelId,
   
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['_id'],
      userId: json['userId'],
      
      reelId: json['reelId'],
     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      
      'reelId': reelId,
    
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}