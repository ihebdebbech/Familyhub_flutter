import 'dart:convert';

class notification {
  String? id;
  final String type;
  final String content;
  final String     senderId;
   String ?    recipientId;
 final bool read;
   DateTime? timestamp;

   notification({
     this.id,
    required this.type,
    required this.content,
    required this.senderId,
     this.recipientId,
    this.read = false,
     this.timestamp,
  }) ;

factory notification.fromJson(Map<String, dynamic> json) {
    return notification(
      id: json['_id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      read: json['read'] as bool ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Method to convert a NotificationModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'senderId': senderId,
      'recipientId': recipientId,
      'read': read,
      'timestamp': timestamp!.toIso8601String(),
    };
  }
   @override
  String toString() {
    return jsonEncode(toJson());
  }
}