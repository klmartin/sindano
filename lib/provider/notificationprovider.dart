import 'package:Sindano/model/notificationmodel.dart';
import 'package:Sindano/model/successmodel.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationModel notificationModel = NotificationModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  getAllNotification() async {
    loading = true;
    notificationModel = await ApiService().getNotification();
    debugPrint("getAllNotification status :==> ${notificationModel.status}");
    debugPrint("getAllNotification message :==> ${notificationModel.message}");
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  readNotification(int position) async {
    int? itemId = notificationModel.result?[position].id;
    debugPrint("readNotification itemId =======> $itemId");
    notificationModel.result?.removeAt(position);
    notifyListeners();
    readNotificationByID(itemId ?? 0);
  }

  readNotificationByID(notificationID) async {
    debugPrint("readNotificationByID notificationID =======> $notificationID");
    successModel = await ApiService().readNotification(notificationID);
    debugPrint(
        "readNotificationByID Status ==========> ${successModel.status}");
    getAllNotification();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    loading = false;
    notificationModel = NotificationModel();
    successModel = SuccessModel();
  }
}
