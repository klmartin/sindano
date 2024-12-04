import 'package:SindanoShow/model/profilemodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  getUserProfile(BuildContext context) async {
    loading = true;
    profileModel = await ApiService().userProfile();
    debugPrint("getProfile status :==> ${profileModel.status}");
    debugPrint("getProfile message :==> ${profileModel.message}");
    if (profileModel.status == 200 && profileModel.result != null) {
      if ((profileModel.result?.length ?? 0) > 0) {
        Utils.updatePremium(profileModel.result?[0].isBuy.toString() ?? "0");
        if (context.mounted) {
          debugPrint("========= get_profile loadAds =========");
          Utils.loadAds(context);
        }
      }
    }
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    loading = false;
    profileModel = ProfileModel();
    successModel = SuccessModel();
  }
}
