import 'dart:developer';

import 'package:SindanoShow/model/paymentoptionmodel.dart';
import 'package:SindanoShow/model/paytmmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentOptionModel paymentOptionModel = PaymentOptionModel();
  PayTmModel payTmModel = PayTmModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false, payLoading = false, couponLoading = false;
  String? currentPayment = "", finalAmount = "";

  Future<void> getPaymentOption() async {
    loading = true;
    paymentOptionModel = await ApiService().getPaymentOption();
    debugPrint("getPaymentOption status :==> ${paymentOptionModel.status}");
    debugPrint("getPaymentOption message :==> ${paymentOptionModel.message}");
    loading = false;
    notifyListeners();
  }

  setFinalAmount(String? amount) {
    finalAmount = amount;
    debugPrint("setFinalAmount finalAmount :==> $finalAmount");
    notifyListeners();
  }

  Future<void> getPaytmToken(merchantID, orderId, custmoreID, channelID,
      txnAmount, website, callbackURL, industryTypeID) async {
    debugPrint("getPaytmToken merchantID :=======> $merchantID");
    debugPrint("getPaytmToken orderId :==========> $orderId");
    debugPrint("getPaytmToken custmoreID :=======> $custmoreID");
    debugPrint("getPaytmToken channelID :========> $channelID");
    debugPrint("getPaytmToken txnAmount :========> $txnAmount");
    debugPrint("getPaytmToken website :==========> $merchantID");
    debugPrint("getPaytmToken callbackURL :======> $merchantID");
    debugPrint("getPaytmToken industryTypeID :===> $industryTypeID");
    loading = true;
    payTmModel = await ApiService().getPaytmToken(merchantID, orderId,
        custmoreID, channelID, txnAmount, website, callbackURL, industryTypeID);
    debugPrint("getPaytmToken status :===> ${payTmModel.status}");
    debugPrint("getPaytmToken message :==> ${payTmModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> addTransaction(packageId, description, amount, paymentId,
      currencyCode, couponCode) async {
    debugPrint("addTransaction userID :==> ${Constant.userID}");
    debugPrint("addTransaction packageId :==> $packageId");
    debugPrint("addTransaction couponCode :==> $couponCode");
    payLoading = true;
    successModel = await ApiService().addTransaction(
        packageId, description, amount, paymentId, currencyCode, couponCode);
    debugPrint("addTransaction status :==> ${successModel.status}");
    debugPrint("addTransaction message :==> ${successModel.message}");
    payLoading = false;
    notifyListeners();
  }

  setCurrentPayment(String? payment) {
    currentPayment = payment;
    notifyListeners();
  }

  clearProvider() {
    log("<================ clearProvider ================>");
    currentPayment = "";
    finalAmount = "";
    paymentOptionModel = PaymentOptionModel();
    successModel = SuccessModel();
  }
}
