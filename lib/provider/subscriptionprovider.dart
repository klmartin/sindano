import 'package:Sindano/model/subscriptionmodel.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionModel subscriptionModel = SubscriptionModel();

  bool loading = false;
  int cPlanPosition = -1, purchasePos = -1;

  Future<void> getPackages() async {
    debugPrint("getPackages userID :==> ${Constant.userID}");
    loading = true;
    subscriptionModel = await ApiService().getPackages();
    debugPrint("getPackages status :==> ${subscriptionModel.status}");
    debugPrint("getPackages message :==> ${subscriptionModel.message}");
    if (subscriptionModel.status == 200 && subscriptionModel.result != null) {
      if ((subscriptionModel.result?.length ?? 0) > 0) {
        for (var i = 0; i < (subscriptionModel.result?.length ?? 0); i++) {
          if (subscriptionModel.result?[i].isBuy == 1) {
            debugPrint("<============= Purchased =============>");
            setPurchasedPlan(i);
          }
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  setPurchasedPlan(int position) {
    debugPrint("setPurchasedPlan position :==> $position");
    purchasePos = position;
  }

  setCurrentPlan(int position) {
    debugPrint("setCurrentPlan position :==> $position");
    cPlanPosition = position;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearSubscriptionProvider ================>");
    subscriptionModel = SubscriptionModel();
    loading = false;
    cPlanPosition = -1;
    purchasePos = -1;
  }
}
