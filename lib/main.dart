import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:SindanoShow/provider/bookmarkprovider.dart';
import 'package:SindanoShow/provider/bottomprovider.dart';
import 'package:SindanoShow/provider/generalprovider.dart';
import 'package:SindanoShow/provider/homeprovider.dart';
import 'package:SindanoShow/provider/homesectionprovider.dart';
import 'package:SindanoShow/provider/languageprovider.dart';
import 'package:SindanoShow/provider/languagesectionprovider.dart';
import 'package:SindanoShow/provider/newsdetailsprovider.dart';
import 'package:SindanoShow/provider/notificationprovider.dart';
import 'package:SindanoShow/provider/paymentprovider.dart';
import 'package:SindanoShow/provider/playerprovider.dart';
import 'package:SindanoShow/provider/profileeditprovider.dart';
import 'package:SindanoShow/provider/searchprovider.dart';
import 'package:SindanoShow/provider/profileprovider.dart';
import 'package:SindanoShow/provider/subscriptionprovider.dart';
import 'package:SindanoShow/provider/videoprovider.dart';
import 'package:SindanoShow/provider/viewallprovider.dart';
import 'package:SindanoShow/pages/splash.dart';
import 'package:SindanoShow/tvpages/tvhome.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Locales.init(['en', 'ar', 'hi', 'zh']);

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
    // if (!kIsWeb) Utils.enableScreenCapture();
    if (!kIsWeb) _getDeviceInfo();

    if (!kIsWeb) {
      OneSignal.Notifications.addForegroundWillDisplayListener(
          _handleForgroundNotification);
    }
    super.initState();
  }

  _handleForgroundNotification(OSNotificationWillDisplayEvent event) async {
    /// preventDefault to not display the notification
    event.preventDefault();

    /// Do async work
    /// notification.display() to display after preventing default
    event.notification.display();

    /* Get Notification */
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.getAllNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: LocaleBuilder(
        builder: (locale) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver], //HERE
          theme: ThemeData(
            primaryColor: colorPrimary,
            primaryColorDark: colorPrimaryDark,
            primaryColorLight: colorPrimary,
            scaffoldBackgroundColor: appBgColor,
          ).copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(
              thumbColor: MaterialStateProperty.all(white),
              trackVisibility: MaterialStateProperty.all(true),
              trackColor: MaterialStateProperty.all(whiteTransparent),
            ),
          ),
          title: Constant.appName,
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) {
            return locale;
          },
          builder: (context, child) {
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 360, name: MOBILE),
                const Breakpoint(start: 361, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1000, name: DESKTOP),
                const Breakpoint(start: 1001, end: double.infinity, name: '4K'),
              ],
            );
          },
          home: (kIsWeb) ? const TVHome(pageName: "") : const Splash(),
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
              PointerDeviceKind.trackpad
            },
          ),
        ),
      ),
    );
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
