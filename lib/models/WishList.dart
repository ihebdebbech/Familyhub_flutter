class WishList {
  final String id;
  final String childId;
  final String productId;
  final bool statut;

  WishList({
    required this.id,
    required this.childId,
    required this.productId,
    required this.statut,
  });

  factory WishList.fromJson(Map<String, dynamic> json) {
    return WishList(
      id: json['_id'],
      childId: json['childId'],
      productId: json['productId'],
      statut: json['statut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'productId': productId,
      'statut': statut,
    };
  }
}
