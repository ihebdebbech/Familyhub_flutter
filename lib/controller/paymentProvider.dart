// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/response/payment_res.dart';
import 'package:flutter_application_1/services/helpers/payment_helper.dart';

class PaymentNotifier extends ChangeNotifier {
  late Future<PaymentResModel> paymentResult;
  final PaymentHelper ph = PaymentHelper();
  makePayment(int amount) {
    paymentResult = PaymentHelper.makePayment(amount);
  }

  Future<void> transfertochild(int amount, String childusername) async {
    print(childusername);
    await ph.transfertochild(amount, childusername);
    notifyListeners();
  }
}
