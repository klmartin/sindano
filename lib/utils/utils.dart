import 'dart:io';
import 'dart:math' as number;

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:SindanoShow/players/player_video.dart';
import 'package:SindanoShow/players/player_vimeo.dart';
import 'package:SindanoShow/players/player_youtube.dart';
import 'package:SindanoShow/pages/newsdetails.dart';
import 'package:SindanoShow/pages/login.dart';
import 'package:SindanoShow/subscription/subscription.dart';
import 'package:SindanoShow/tvpages/tvnewsdetails.dart';
import 'package:SindanoShow/utils/adhelper.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/sharedpre.dart';
import 'package:SindanoShow/webwidget/loginsocialweb.dart';
import 'package:SindanoShow/webwidget/otpverifyweb.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class Utils {
  static void enableScreenCapture() async {
    await ScreenProtector.preventScreenshotOn();
    if (Platform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlur();
    } else if (Platform.isAndroid) {
      await ScreenProtector.protectDataLeakageOn();
    }
  }

  static menuBarDialog(
    BuildContext context,
    Widget Function(BuildContext) horizontalDrawerBuilder,
  ) async {
    showAlignedDialog(
      context: context,
      builder: horizontalDrawerBuilder,
      followerAnchor: Alignment.topRight,
      isGlobal: true,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
              .animate(animation),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );
  }

  static Future<void> buildWebAlertDialog(
      BuildContext context, String pageName, String? reqData) async {
    Widget? child;
    if (pageName == "login") {
      child = const LoginSocialWeb();
    } else if (pageName == "otp") {
      child = OTPVerifyWeb(reqData ?? "");
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: const EdgeInsets.fromLTRB(50, 25, 50, 25),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: lightBlack,
          child: child,
        );
      },
    );
  }

  static Future<dynamic> openDetails({
    required BuildContext context,
    required String itemId,
    required String categoryId,
  }) async {
    debugPrint("openDetails itemId ========> $itemId");
    debugPrint("openDetails categoryID ====> $categoryId ");
    if (kIsWeb || Constant.isTV) {
      if (!(context.mounted)) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TvNewsDetails(
              itemId: itemId,
              categoryId: categoryId,
            );
          },
        ),
      );
    } else {
      if (!(context.mounted)) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NewsDetails(
              itemId: itemId,
              categoryId: categoryId,
            );
          },
        ),
      );
    }
  }

  static openSubscription({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Subscription();
        },
      ),
    );
  }

  static openPlayer({
    required BuildContext context,
    required String videoId,
    required String videoUrl,
    required String vUploadType,
    required String videoThumb,
  }) {
    if (kIsWeb) {
      /* Normal, Vimeo & Youtube Player */
      if (!context.mounted) return;
      if (vUploadType == "youtube") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerYoutube(
                videoId,
                videoUrl,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      } else if (vUploadType == "external") {
        if (videoUrl.contains('youtube')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PlayerYoutube(
                  videoId,
                  videoUrl,
                  vUploadType,
                  videoThumb,
                );
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PlayerVideo(
                  videoId,
                  videoUrl,
                  vUploadType,
                  videoThumb,
                );
              },
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerVideo(
                videoId,
                videoUrl,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      }
    } else {
      /* Better, Youtube & Vimeo Players */
      if (vUploadType == "youtube") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerYoutube(
                videoId,
                videoUrl,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      } else if (vUploadType == "vimeo") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerVimeo(
                videoId,
                videoUrl,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      } else if (vUploadType == "external") {
        if (videoUrl.contains('youtube')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PlayerYoutube(
                  videoId,
                  videoUrl,
                  vUploadType,
                  videoThumb,
                );
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PlayerVideo(
                  videoId,
                  videoUrl,
                  vUploadType,
                  videoThumb,
                );
              },
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerVideo(
                videoId,
                videoUrl,
                vUploadType,
                videoThumb,
              );
            },
          ),
        );
      }
    }
  }

  static checkLoginUser(BuildContext context) {
    if (Constant.userID != null) {
      return true;
    }
    if ((kIsWeb || Constant.isTV)) {
      Utils.buildWebAlertDialog(context, "login", "");
      return false;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Login();
        },
      ),
    );
    return false;
  }

  static Widget showBannerAd(BuildContext context) {
    if (!kIsWeb) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 0,
          minWidth: 0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: AdHelper.bannerAd(context),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static loadAds(BuildContext context) async {
    bool? isPremiumBuy = await Utils.checkPremiumUser();
    debugPrint("loadAds isPremiumBuy :==> $isPremiumBuy");
    if (context.mounted) {
      AdHelper.getAds(context);
    }
    if (!kIsWeb && !isPremiumBuy) {
      AdHelper.createInterstitialAd();
      AdHelper.createRewardedAd();
    }
  }

  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: white,
        textColor: black,
        fontSize: 14);
  }

  dateConvert(String date, String format) {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(now);
  }

  static void getCurrencySymbol() async {
    SharedPre sharedPref = SharedPre();
    Constant.currencySymbol = await sharedPref.read("currency_code") ?? "";
    debugPrint('Constant currencySymbol ==> ${Constant.currencySymbol}');
    Constant.currency = await sharedPref.read("currency") ?? "";
    debugPrint('Constant currency ==> ${Constant.currency}');
  }

  static saveUserCreds({
    required userID,
    required userName,
    required userEmail,
    required userMobile,
    required userImage,
    required userPremium,
    required userType,
  }) async {
    SharedPre sharedPref = SharedPre();
    if (userID != null) {
      await sharedPref.save("userid", userID);
      await sharedPref.save("username", userName);
      await sharedPref.save("useremail", userEmail);
      await sharedPref.save("usermobile", userMobile);
      await sharedPref.save("userimage", userImage);
      await sharedPref.save("userpremium", userPremium);
      await sharedPref.save("usertype", userType);
    } else {
      await sharedPref.remove("userid");
      await sharedPref.remove("username");
      await sharedPref.remove("userimage");
      await sharedPref.remove("useremail");
      await sharedPref.remove("usermobile");
      await sharedPref.remove("userpremium");
      await sharedPref.remove("usertype");
    }
    Constant.userID = await sharedPref.read("userid");
    debugPrint('setUserId userID ==> ${Constant.userID}');
  }

  static Future<bool> checkPremiumUser() async {
    SharedPre sharedPre = SharedPre();
    String? isPremiumBuy = await sharedPre.read("userpremium");
    debugPrint('checkPremiumUser isPremiumBuy ==> $isPremiumBuy');
    if (isPremiumBuy != null && isPremiumBuy == "1") {
      return true;
    } else {
      return false;
    }
  }

  static void updatePremium(String isPremiumBuy) async {
    debugPrint('updatePremium isPremiumBuy ==> $isPremiumBuy');
    SharedPre sharedPre = SharedPre();
    await sharedPre.save("userpremium", isPremiumBuy);
    String? isPremium = await sharedPre.read("userpremium");
    debugPrint('updatePremium ===============> $isPremium');
  }

  static setUserId(userID) async {
    SharedPre sharedPref = SharedPre();
    if (userID != null) {
      await sharedPref.save("userid", userID);
    } else {
      await sharedPref.remove("userid");
      await sharedPref.remove("username");
      await sharedPref.remove("userimage");
      await sharedPref.remove("useremail");
      await sharedPref.remove("usermobile");
      await sharedPref.remove("userpremium");
      await sharedPref.remove("usertype");
    }
    Constant.userID = await sharedPref.read("userid");
    debugPrint('setUserId userID ==> ${Constant.userID}');
  }

  static setFirstTime(value) async {
    SharedPre sharedPref = SharedPre();
    await sharedPref.save("seen", value);
    String seenValue = await sharedPref.read("seen");
    debugPrint('setFirstTime seen ==> $seenValue');
  }

  static Future<String> getPrivacyTandCText(
      String privacyUrl, String termsConditionUrl) async {
    debugPrint('privacyUrl ==> $privacyUrl');
    debugPrint('T&C Url =====> $termsConditionUrl');

    String strPrivacyAndTNC =
        "<p style=color:white; > By continuing , I understand and agree with <a href=$privacyUrl>Privacy Policy</a> and <a href=$termsConditionUrl>Terms and Conditions</a> of ${Constant.appName}. </p>";

    debugPrint('strPrivacyAndTNC =====> $strPrivacyAndTNC');
    return strPrivacyAndTNC;
  }

  static Future<void> deleteCacheDir() async {
    if (Platform.isAndroid) {
      var tempDir = await getTemporaryDirectory();

      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    }
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Widget buildBackBtnDesign(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MyImage(
        height: 17,
        width: 17,
        imagePath: "ic_back.png",
        fit: BoxFit.contain,
        color: white,
      ),
    );
  }

  static AppBar myAppBarWithBack(
      BuildContext context, String appBarTitle, bool multilanguage) {
    return AppBar(
      elevation: 5,
      backgroundColor: colorPrimaryDark,
      centerTitle: false,
      leading: IconButton(
        autofocus: true,
        focusColor: white.withOpacity(0.5),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: MyImage(
          imagePath: "ic_back.png",
          fit: BoxFit.contain,
          height: 16,
          width: 16,
          color: white,
        ),
      ),
      title: MyText(
        text: appBarTitle,
        multilanguage: multilanguage,
        fontsizeNormal: 16,
        fontsizeWeb: 18,
        fontstyle: FontStyle.normal,
        fontweight: FontWeight.bold,
        textalign: TextAlign.center,
        color: white,
      ),
    );
  }

  static void showProgress(
      BuildContext context, ProgressDialog prDialog) async {
    prDialog = ProgressDialog(context);
    //For normal dialog
    prDialog = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: false);

    prDialog.style(
      message: "Please Wait",
      borderRadius: 5,
      progressWidget: Container(
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(),
      ),
      maxProgress: 100,
      progressTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      backgroundColor: white,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: const TextStyle(
        color: colorPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );

    await prDialog.show();
  }

  static Widget pageLoader() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: colorAccent,
      ),
    );
  }

  static void showSnackbar(BuildContext context, String showFor, String message,
      bool multilanguage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: showFor == "fail"
            ? failureBG
            : showFor == "info"
                ? infoBG
                : showFor == "success"
                    ? successBG
                    : colorAccent,
        content: MyText(
          text: message,
          fontsizeNormal: 14,
          fontsizeWeb: 14,
          multilanguage: multilanguage,
          fontstyle: FontStyle.normal,
          fontweight: FontWeight.w500,
          color: white,
          textalign: TextAlign.center,
        ),
      ),
    );
  }

  static BoxDecoration setBGWithRadius(
      Color colorBg,
      double radiusTopLeft,
      double radiusTopRight,
      double radiusBottomLeft,
      double radiusBottomRight) {
    return BoxDecoration(
      color: colorBg,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radiusTopLeft),
        topRight: Radius.circular(radiusTopRight),
        bottomLeft: Radius.circular(radiusBottomLeft),
        bottomRight: Radius.circular(radiusBottomRight),
      ),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setBackground(Color color, double radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setBGWithBorder(
      Color color, Color borderColor, double radius, double border) {
    return BoxDecoration(
      color: color,
      border: Border.all(
        color: borderColor,
        width: border,
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradLTRBorderWithBG(Color colorStart, Color colorEnd,
      Color bgColor, double radius, double border) {
    return BoxDecoration(
      border: GradientBoxBorder(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[colorStart, colorEnd],
        ),
        width: border,
      ),
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradTTBBorderWithBG(Color colorTop, Color colorBottom,
      Color bgColor, double radius, double border) {
    return BoxDecoration(
      border: GradientBoxBorder(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[colorTop, colorBottom],
        ),
        width: border,
      ),
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradTTBBorderAndGradBG(
      Color colorTop, Color colorBottom, double radius, double border) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[colorTop, colorBottom],
      ),
      border: GradientBoxBorder(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[colorTop, colorBottom],
        ),
        width: border,
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradLTRBGWithBorder(Color colorStart, Color colorEnd,
      Color borderColor, double radius, double border) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: border,
      ),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[colorStart, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradTTBBGWithBorder(Color colorStart, Color colorEnd,
      Color borderColor, double radius, double border) {
    return BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: border,
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[colorStart, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradBGWithCenter(
      Color colorStart, Color colorCenter, Color colorEnd, double radius) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[colorStart, colorCenter, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradTTBBGWithCenter(
      Color colorTop, Color colorCenter, Color colorBottom, double radius) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[colorTop, colorCenter, colorBottom],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static BoxDecoration setGradTTBWithCenter(
      Color colorStart, Color colorCenter, Color colorEnd, double radius) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[colorStart, colorCenter, colorEnd],
      ),
      borderRadius: BorderRadius.circular(radius),
      shape: BoxShape.rectangle,
    );
  }

  static Html htmlTexts(var strText) {
    return Html(
      data: strText,
      style: {
        "body": Style(
          color: otherColor,
          fontSize: FontSize(15),
          fontWeight: FontWeight.w500,
        ),
        "link": Style(
          color: colorAccent,
          fontSize: FontSize(15),
          fontWeight: FontWeight.w500,
        ),
      },
      onLinkTap: (url, _, ___) async {
        if (await canLaunchUrl(Uri.parse(url!))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.platformDefault,
          );
        } else {
          throw 'Could not launch $url';
        }
      },
      shrinkWrap: false,
    );
  }

  static Html htmlNewsDesc(var strText) {
    var content = """<!DOCTYPE html>
                  <html>
                    <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
                    <body style='margin: 0; padding: 0;'>
                      <div>
                        $strText
                      </div>
                    </body>
                  </html>""";
    return Html(
      data: content,
      style: {
        "body": Style(
          color: grayDark,
          fontSize: FontSize(15),
          fontWeight: FontWeight.w500,
        ),
        "link": Style(
          color: colorAccent,
          fontSize: FontSize(15),
          fontWeight: FontWeight.w500,
        ),
      },
      onLinkTap: (url, _, ___) async {
        if (await canLaunchUrl(Uri.parse(url!))) {
          await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.platformDefault,
          );
        } else {
          throw 'Could not launch $url';
        }
      },
      shrinkWrap: false,
    );
  }

  static Future<File?> saveImageInStorage(imgUrl) async {
    try {
      var response = await http.get(Uri.parse(imgUrl));
      Directory? documentDirectory;
      if (Platform.isAndroid) {
        documentDirectory = await getExternalStorageDirectory();
      } else {
        documentDirectory = await getApplicationDocumentsDirectory();
      }
      File file = File(path.join(documentDirectory?.path ?? "",
          '${DateTime.now().millisecondsSinceEpoch.toString()}.png'));
      file.writeAsBytesSync(response.bodyBytes);
      return file;
    } catch (e) {
      debugPrint("saveImageInStorage Exception ===> $e");
      return null;
    }
  }

  static Future<void> shareData(context, itemTitle) async {
    try {
      String? shareMessage, shareDesc;
      shareDesc =
          "Hey!!! I'm reading & watching $itemTitle news article. Check it out now on ${Constant.appName}! and more.";
      if (Platform.isAndroid) {
        shareMessage = "$shareDesc\n${Constant.androidAppUrl}";
      } else {
        shareMessage = "$shareDesc\n${Constant.iosAppUrl}";
      }
      await FlutterShare.share(
        title: Constant.appName,
        linkUrl: shareMessage,
      );
    } catch (e) {
      debugPrint("shareFile Exception ===> $e");
      return;
    }
  }

  static Future<void> redirectToUrl(String url) async {
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> redirectToStore() async {
    final appId =
        Platform.isAndroid ? Constant.appPackageName : Constant.appleAppId;
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    debugPrint("_launchUrl url ===> $url");
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(
        Uri.parse(url.toString()),
        mode: LaunchMode.platformDefault,
      );
    } else {
      throw "Could not launch $url";
    }
  }

  static Future<void> shareApp(shareMessage) async {
    try {
      await FlutterShare.share(
        title: Constant.appName,
        linkUrl: shareMessage,
      );
    } catch (e) {
      debugPrint("shareFile Exception ===> $e");
      return;
    }
  }

  /* ***************** generate Unique OrderID START ***************** */
  static String generateRandomOrderID() {
    int getRandomNumber;
    String? finalOID;
    debugPrint("fixFourDigit =>>> ${Constant.fixFourDigit}");
    debugPrint("fixSixDigit =>>> ${Constant.fixSixDigit}");

    number.Random r = number.Random();
    int ran5thDigit = r.nextInt(9);
    debugPrint("Random ran5thDigit =>>> $ran5thDigit");

    int randomNumber = number.Random().nextInt(9999999);
    debugPrint("Random randomNumber =>>> $randomNumber");
    if (randomNumber < 0) {
      randomNumber = -randomNumber;
    }
    getRandomNumber = randomNumber;
    debugPrint("getRandomNumber =>>> $getRandomNumber");

    finalOID = "${Constant.fixFourDigit.toInt()}"
        "$ran5thDigit"
        "${Constant.fixSixDigit.toInt()}"
        "$getRandomNumber";
    debugPrint("finalOID =>>> $finalOID");

    return finalOID;
  }
  /* ***************** generate Unique OrderID END ***************** */
}
