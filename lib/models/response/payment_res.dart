import 'dart:convert';

PaymentResModel paymentResModelFromJson(String str) =>
    PaymentResModel.fromJson(json.decode(str));

String paymentResModelToJson(PaymentResModel data) =>
    json.encode(data.toJson());

class PaymentResModel {
  final Result result;
  final int code;
  final String name;
  final String version;

  PaymentResModel({
    required this.result,
    required this.code,
    required this.name,
    required this.version,
  });

  factory PaymentResModel.fromJson(Map<String, dynamic> json) =>
      PaymentResModel(
        result: Result.fromJson(json["result"]),
        code: json["code"],
        name: json["name"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "result": result.toJson(),
        "code": code,
        "name": name,
        "version": version,
      };
}

class Result {
  final String link;
  final String paymentId;
  final String developerTrackingId;
  final bool success;

  Result({
    required this.link,
    required this.paymentId,
    required this.developerTrackingId,
    required this.success,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        link: json["link"],
        paymentId: json["payment_id"],
        developerTrackingId: json["developer_tracking_id"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "link": link,
        "payment_id": paymentId,
        "developer_tracking_id": developerTrackingId,
        "success": success,
      };
}
