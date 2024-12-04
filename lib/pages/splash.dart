import 'package:SindanoShow/pages/bottompage.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/sharedpre.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String? seen;
  SharedPre sharedPre = SharedPre();

  @override
  void initState() {
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

    Constant.userID = await sharedPre.read('userid');
    debugPrint("userID :========> ${Constant.userID}");

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const Bottompage();
        },
      ),
    );
  }
}
