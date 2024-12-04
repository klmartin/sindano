import 'package:SindanoShow/provider/generalprovider.dart';
import 'package:SindanoShow/provider/notificationprovider.dart';
import 'package:SindanoShow/provider/profileprovider.dart';
import 'package:SindanoShow/pages/profile.dart';
import 'package:SindanoShow/pages/bookmark.dart';
import 'package:SindanoShow/provider/bottomprovider.dart';
import 'package:SindanoShow/pages/search.dart';
import 'package:SindanoShow/pages/sidedrawer.dart';
import 'package:SindanoShow/pages/home.dart';
import 'package:SindanoShow/pages/notification.dart';
import 'package:badges/badges.dart' as badge;
import 'package:SindanoShow/pages/video.dart';
import 'package:SindanoShow/utils/adhelper.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/sharedpre.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bottompage extends StatefulWidget {
  const Bottompage({super.key});

  @override
  State<Bottompage> createState() => _BottompageState();
}

class _BottompageState extends State<Bottompage> {
  late NotificationProvider notificationProvider;
  final GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  SharedPre sharePref = SharedPre();
  int selectedIndex = 0;

  final List<Widget> _children = const [Home(), Video(), Bookmark(), Profile()];

  @override
  void initState() {
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    super.initState();
    getData();
  }

  getData() async {
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (!mounted) return;
    if (Constant.userID != null) {
      await profileProvider.getUserProfile(context);
    }
    notificationProvider.getAllNotification();
    if (!mounted) return;
    generalProvider.getGeneralsetting(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const Sidedrawer(),
      appBar: myAppBar(context),
      body: _children[currentIndex],
      bottomNavigationBar: Visibility(
        visible: context.watch<BottomProvider>().visibility,
        child: _buildBottomBar(),
      ),
    );
  }

  AppBar myAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colorPrimaryDark,
      elevation: 0,
      iconTheme: const IconThemeData(color: lightGray),
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Search(),
              ),
            );
          },
          child: MyImage(
            imagePath: 'ic_search.png',
            width: 20,
            height: 20,
            color: lightGray,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 8),
        /* Notification */
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notifications(),
                  ),
                );
              },
              padding: const EdgeInsets.only(top: 6),
              icon: _buildNotificationBadge(),
            );
          },
        ),
        const SizedBox(width: 8)
      ],
      title: MyImage(
        imagePath: 'logo5.png',
        fit: BoxFit.contain,
        width: 100,
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: appBgColor,
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
      elevation: 5,
      child: Card(
        elevation: 5,
        shadowColor: black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIcons(
                iconName: "ic_home",
                isSelected: currentIndex == 0,
                onClick: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () async {
                    setState(() {
                      currentIndex = 0;
                    });
                  });
                },
              ),
              _buildIcons(
                iconName: "ic_video",
                isSelected: currentIndex == 1,
                onClick: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () async {
                    setState(() {
                      currentIndex = 1;
                    });
                  });
                },
              ),
              _buildIcons(
                iconName: "ic_bookmarkfill",
                isSelected: currentIndex == 2,
                onClick: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () async {
                    setState(() {
                      currentIndex = 2;
                    });
                  });
                },
              ),
              _buildIcons(
                iconName: "ic_user",
                isSelected: currentIndex == 3,
                onClick: () {
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () async {
                    setState(() {
                      currentIndex = 3;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcons({
    required String iconName,
    required bool isSelected,
    required Function() onClick,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onClick,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isSelected ? colorPrimary : transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(10),
        child: MyImage(
          fit: BoxFit.contain,
          imagePath: "$iconName.png",
          color: isSelected ? white : gray,
        ),
      ),
    );
  }

  Widget _buildNotificationBadge() {
    if (notificationProvider.notificationModel.status == 200 &&
        notificationProvider.notificationModel.result != null) {
      if ((notificationProvider.notificationModel.result?.length ?? 0) > 0) {
        return badge.Badge(
          position: badge.BadgePosition.bottomStart(bottom: 12, start: 12),
          badgeStyle: const badge.BadgeStyle(badgeColor: white),
          badgeContent: MyText(
            text: notificationProvider.notificationModel.result?.length
                .toString(),
            fontsizeNormal: 8,
            fontsizeWeb: 8,
            fontstyle: FontStyle.normal,
            fontweight: FontWeight.w700,
            textalign: TextAlign.center,
            color: colorAccent,
          ),
          child: _buildNotiIcon(),
        );
      } else {
        return _buildNotiIcon();
      }
    } else {
      return _buildNotiIcon();
    }
  }

  Widget _buildNotiIcon() {
    return MyImage(
      imagePath: 'notification.png',
      width: 23,
      height: 23,
      color: lightGray,
      fit: BoxFit.contain,
    );
  }
}
