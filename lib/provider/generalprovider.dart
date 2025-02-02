import 'dart:io';

import 'package:Sindano/model/generalsettingmodel.dart';
import 'package:Sindano/model/loginmodel.dart';
import 'package:Sindano/model/pagesmodel.dart';
import 'package:Sindano/model/sociallinkmodel.dart';
import 'package:Sindano/utils/adhelper.dart';
import 'package:Sindano/utils/sharedpre.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralSettingModel generalSettingModel = GeneralSettingModel();
  PagesModel pagesModel = PagesModel();
  SocialLinkModel socialLinkModel = SocialLinkModel();
  LoginModel loginSocialModel = LoginModel();
  LoginModel loginOTPModel = LoginModel();
  LoginModel loginTVModel = LoginModel();

  bool loading = false;
  String? appDescription;

  SharedPre sharedPre = SharedPre();

  Future<void> getGeneralsetting(BuildContext context) async {
    loading = true;
    generalSettingModel = await ApiService().genaralSetting();
    debugPrint('generalSettingData status ==> ${generalSettingModel.status}');
    if (generalSettingModel.status == 200) {
      if (generalSettingModel.result != null) {
        for (var i = 0; i < (generalSettingModel.result?.length ?? 0); i++) {
          await sharedPre.save(
            generalSettingModel.result?[i].key.toString() ?? "",
            generalSettingModel.result?[i].value.toString() ?? "",
          );
          debugPrint(
              '${generalSettingModel.result?[i].key.toString()} ==> ${generalSettingModel.result?[i].value.toString()}');
        }
        /* Get Ads Init */
        if (context.mounted) {
          if (!kIsWeb) AdHelper.getAds(context);
          Utils.getCurrencySymbol();
        }
        appDescription = await sharedPre.read("app_description") ?? "";
        debugPrint("appDescription ===========> $appDescription");
      }
    }
    loading = false;
    notifyListeners();
  }

  Future<void> getPages() async {
    loading = true;
    pagesModel = await ApiService().getPages();
    debugPrint("getPages status :==> ${pagesModel.status}");
    loading = false;
    notifyListeners();
  }

  Future<void> getSocialLinks() async {
    loading = true;
    socialLinkModel = await ApiService().getSocialLink();
    debugPrint("getSocialLinks status :==> ${socialLinkModel.status}");
    loading = false;
    notifyListeners();
  }

  Future<void> loginWithSocial(
      email, name, type, deviceToken, File? profileImg,firebaseId) async {
    debugPrint("loginWithSocial email       :==> $email");
    debugPrint("loginWithSocial name        :==> $name");
    debugPrint("loginWithSocial type        :==> $type");
    debugPrint("loginWithSocial deviceToken :==> $deviceToken");
    debugPrint("loginWithSocial profileImg  :==> ${profileImg?.path}");

    loading = true;
    loginSocialModel = await ApiService().login(email, name, type, deviceToken,firebaseId);
    debugPrint("loginWithSocial status  :==> ${loginSocialModel.status}");
    debugPrint("loginWithSocial message :==> ${loginSocialModel.message}");
    loading = false;
    notifyListeners();
  }

  Future<void> loginWithOTP(mobile, deviceToken) async {
    debugPrint("loginWithOTP mobile      :==> $mobile");
    debugPrint("loginWithOTP deviceToken :==> $deviceToken");

    loading = true;
    loginOTPModel = await ApiService().loginWithOtp(mobile, deviceToken);
    debugPrint("loginWithOTP status  :==> ${loginOTPModel.status}");
    debugPrint("loginWithOTP message :==> ${loginOTPModel.message}");
    loading = false;
    notifyListeners();
  }
}
