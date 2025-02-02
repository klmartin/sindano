import 'dart:convert';
import 'dart:io';
import 'package:Sindano/pages/bottompage.dart';
import 'package:Sindano/pages/login.dart';
import 'package:Sindano/provider/userstatusprovider.dart';
import 'package:Sindano/subscription/subscription.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:Sindano/provider/bookmarkprovider.dart';
import 'package:Sindano/provider/bottomprovider.dart';
import 'package:Sindano/provider/generalprovider.dart';
import 'package:Sindano/provider/homeprovider.dart';
import 'package:Sindano/provider/homesectionprovider.dart';
import 'package:Sindano/provider/languageprovider.dart';
import 'package:Sindano/provider/languagesectionprovider.dart';
import 'package:Sindano/provider/newsdetailsprovider.dart';
import 'package:Sindano/provider/notificationprovider.dart';
import 'package:Sindano/provider/paymentprovider.dart';
import 'package:Sindano/provider/playerprovider.dart';
import 'package:Sindano/provider/profileeditprovider.dart';
import 'package:Sindano/provider/searchprovider.dart';
import 'package:Sindano/provider/profileprovider.dart';
import 'package:Sindano/provider/subscriptionprovider.dart';
import 'package:Sindano/provider/videoprovider.dart';
import 'package:Sindano/provider/viewallprovider.dart';
import 'package:Sindano/pages/splash.dart';
import 'package:Sindano/tvpages/tvhome.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Locales.init(['en', 'ar', 'hi', 'zh']);
              print('stats from main.dart 1');

  if (!kIsWeb) {
    await MobileAds.instance.initialize();
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Initialize OneSignal
    OneSignal.initialize(Constant.oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);
    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint("Has permission ==> $state");
    });
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint(
          "pushSubscription state ==> ${state.current.jsonRepresentation()}");
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProfileEditProvider()),
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => HomeSectionProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => LanguageSectionProvider()),
        ChangeNotifierProvider(create: (_) => ViewAllProvider()),
        ChangeNotifierProvider(create: (_) => BookMarkProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => NewsDetailsProvider()),
        ChangeNotifierProvider(create: (_) => UserStatusProvider()), // Add this
      ],
      child: const MyApp(),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: colorPrimaryDark,
    systemNavigationBarDividerColor: colorPrimaryDark,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _getDeviceInfo();
    if (!kIsWeb) {
      OneSignal.Notifications.addForegroundWillDisplayListener(
          _handleForgroundNotification);
    }
                  print('stats from main.dart2');

  }

  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<UserStatusProvider>(context, listen: false);
              print('stats from main.dart3');

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: Locales.delegates,
      supportedLocales: Locales.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<Map<String, dynamic>?>(
        future: userProvider.checkUserStatus2(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Splash());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<String, dynamic>? userData = snapshot.data;
            if (userData == null || userData.isEmpty) {
              return const Login();
            } else {
              bool isAuthenticated = userData['isAuthenticated'] ?? false;
              bool hasSubscription = userData['hasSubscription'] ?? false;
              print(isAuthenticated);
              print(hasSubscription);
              print('stats from main.dart');
              if (isAuthenticated) {
                if (hasSubscription) {
                  print('stats from TvHomemain.dart');
                  return const Bottompage();
                } else {
                  return const Subscription();
                }
              } else {
                return const Login();
              }
            }
          }
        },
      ),
    );
  }

  _handleForgroundNotification(OSNotificationWillDisplayEvent event) async {
    event.preventDefault();
    event.notification.display();

    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.getAllNotification();
  }

  _getDeviceInfo() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Constant.isTV =
          androidInfo.systemFeatures.contains('android.software.leanback');
      debugPrint("isTV =======================> ${Constant.isTV}");
    }
  }
}
