class Chat {
  final String username;
  final String text;
  final String image;
  final int roomId;

  Chat({
    required this.username,
    required this.text,
    required this.image,
    required this.roomId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      username: json['username'],
      text: json['text'],
      image: json['image'] ?? '', // Handle cases where image is null
      roomId: json['room_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'image': image,
      'room_id': roomId,
    };
  }
}