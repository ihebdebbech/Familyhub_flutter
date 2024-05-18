class Room {
  final int roomId;
  final String buyerUsername;
  final String sellerUsername;

  Room({
    required this.roomId,
    required this.buyerUsername,
    required this.sellerUsername,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['room_id'],
      buyerUsername: json['buyer_username'],
      sellerUsername: json['seller_username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'buyer_username': buyerUsername,
      'seller_username': sellerUsername,
    };
  }
}
