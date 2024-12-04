class Constant {
  final String baseurl = 'https://www.sindanoshow.com/public/api/';

  static String appName = "Sindano Show";
  static String appPackageName = "com.sindano.sindanoshow";
  static String appleAppId = "6463490785";

  /* OneSignal App ID */
  static const String oneSignalAppId = "";

  /* Constant for TV check */
  static bool isTV = false;

  static String? userID;
  static String currencySymbol = "";
  static String currency = "";

  static String androidAppShareUrlDesc =
      "Let me recommend you this application\n\n$androidAppUrl";
  static String iosAppShareUrlDesc =
      "Let me recommend you this application\n\n$iosAppUrl";

  static String androidAppUrl =
      "https://play.google.com/store/apps/details?id=${Constant.appPackageName}";
  static String iosAppUrl =
      "https://apps.apple.com/us/app/id${Constant.appleAppId}";

  /* Transaction Id constants */
  static int fixFourDigit = 1317;
  static int fixSixDigit = 161613;
  /* Banner Change Duration */
  static int bannerDuration = 10000; // in milliseconds
  static int animationDuration = 800; // in milliseconds

  /* Show Ad By Type */
  static String rewardAdType = "rewardAd";
  static String interstialAdType = "interstialAd";
}
