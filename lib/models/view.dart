import 'dart:convert';

class Viewreel {
  final String? id;
  final String userId;
  final String reelId;
  

  Viewreel({
    this.id,
    required this.userId,
  
    required this.reelId,
   
  });

  factory Viewreel.fromJson(Map<String, dynamic> json) {
    return Viewreel(
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