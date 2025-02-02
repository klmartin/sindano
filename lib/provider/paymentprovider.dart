import 'dart:async';
import 'dart:developer';

import 'package:Sindano/model/paymentoptionmodel.dart';
import 'package:Sindano/model/paytmmodel.dart';
import 'package:Sindano/model/successmodel.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentOptionModel paymentOptionModel = PaymentOptionModel();
  PayTmModel payTmModel = PayTmModel();
  SuccessModel successModel = SuccessModel();
  bool _isPaying = false;
  bool _payed = false;
  bool _isFinishPaying = false;
  bool _paymentCanceled = false;
  String _payedPost = '';
  String _payingText = 'Processing Payment...';
  bool get isPaying => _isPaying;
  bool get isFinishPaying => _isFinishPaying;
  bool get payed => _payed;
  String get payingText => _payingText;
  String get payedPost => _payedPost;
  bool get paymentCanceled => _paymentCanceled;
  Timer? _processingStatusTimer;
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

  Future<bool> _fetchPaymentStatus(String transactionId) async {
    var status = await ApiService().getPaymentStatus(transactionId);

    print(status);

    print("payment status fetched is .........$status");
    if (status == true) {
      _payed = true;
      _processingStatusTimer?.cancel();
      notifyListeners();
    }
    if (_paymentCanceled == true) {
      _isFinishPaying = true;
      _isPaying = false;
      _processingStatusTimer?.cancel();
      notifyListeners();
    }
    return status;
  }

  Future<void> startPaying(phoneNumber, amount, itemId, userId) async {
    _isPaying = true;
    _payedPost = itemId.toString();
    notifyListeners();
    Map<String, dynamic> pay =  await ApiService().makePayment(userId, amount, phoneNumber, itemId);
    print("pay is complete..... $pay");
    if (pay.isNotEmpty) {
      var transactionId = pay['id'];
      print("transactions id in provider is.. $transactionId");
      print(transactionId);
      print('transId');
      _isPaying = false;
      notifyListeners();
      _processingStatusTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _fetchPaymentStatus(transactionId.toString());
        notifyListeners();
      });
    } else {
      _isPaying = false;
      notifyListeners();
    }
  }

  clearProvider() {
    log("<================ clearProvider ================>");
    currentPayment = "";
    finalAmount = "";
    paymentOptionModel = PaymentOptionModel();
    successModel = SuccessModel();
  }

  set paymentCanceled(bool value) {
    _paymentCanceled = value;
    _isPaying = false;
    notifyListeners();
  }
}
