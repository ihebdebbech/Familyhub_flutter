import 'dart:convert';

PaymentReqModel paymentReqModelFromJson(String str) =>
    PaymentReqModel.fromJson(json.decode(str));

String paymentReqModelToJson(PaymentReqModel data) =>
    json.encode(data.toJson());

class PaymentReqModel {
  final int amount;
  final String userId;
  PaymentReqModel({
    required this.amount,
    required this.userId,
  });

  factory PaymentReqModel.fromJson(Map<String, dynamic> json) =>
      PaymentReqModel(
        amount: json["amount"],
        userId: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
"userid": userId,
      };
}
