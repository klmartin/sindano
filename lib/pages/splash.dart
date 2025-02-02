import 'package:Sindano/pages/bottompage.dart';
import 'package:Sindano/provider/userstatusprovider.dart';
import 'package:Sindano/subscription/subscription.dart';
import 'package:Sindano/tvpages/tvhome.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/sharedpre.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? seen;
  SharedPre sharedPre = SharedPre();
  late UserStatusProvider userStatusProvider;

  @override
  void initState() {
       userStatusProvider =
        Provider.of<UserStatusProvider>(context, listen: false);
    userStatusProvider.checkUserStatus2();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (!mounted) return;
      isFirstCheck();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      body: MyImage(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        imagePath: (kIsWeb || Constant.isTV) ? "appicon2.png" : "spalsh2.png",
        fit: (kIsWeb || Constant.isTV) ? BoxFit.contain : BoxFit.cover,
      ),
    );
  }

  Future<void> isFirstCheck() async {
    seen = await sharedPre.read('seen') ?? "0";
    debugPrint("seen   :========> $seen");
final userStatusProvider =
        Provider.of<UserStatusProvider>(context, listen: false);
    Constant.userID = await sharedPre.read('userid');
    debugPrint("userID :========> ${Constant.userID}");

    if (!mounted) return;

    if (userStatusProvider.hasSubscription!) {
          debugPrint(
              'User has an active subscription splash. Navigating to BottomPage.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Bottompage()),
            (Route<dynamic> route) => false,
          );
        } else {
          debugPrint(
              'User does NOT have an active subscription splash. Navigating to SubscriptionPage.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Subscription()),
            (Route<dynamic> route) => false,
          );
        }
 
  }
}
