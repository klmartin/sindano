import 'package:SindanoShow/model/profilemodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class ProfileEditProvider extends ChangeNotifier {
  ProfileModel profileModel = ProfileModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  Future<void> getProfile() async {
    debugPrint("getProfile userID :==> ${Constant.userID}");
    loading = true;
    profileModel = await ApiService().userProfile();
    debugPrint("getProfile status :==> ${profileModel.status}");
    debugPrint("getProfile message :==> ${profileModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> getUpdateProfile(
      fullName, email, mobileNumber, profileImg) async {
    debugPrint("getUpdateProfile userID :==> ${Constant.userID}");
    loading = true;
    successModel = await ApiService()
        .updateProfile(fullName, email, mobileNumber, profileImg);
    debugPrint("getUpdateProfile status :==> ${successModel.status}");
    debugPrint("getUpdateProfile message :==> ${successModel.message}");
    loading = false;
    notifyListeners();
  }

  clearProvider() {
    profileModel = ProfileModel();
    successModel = SuccessModel();
    loading = false;
  }
}
