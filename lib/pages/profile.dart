import 'dart:async';

import 'package:SindanoShow/provider/profileprovider.dart';
import 'package:SindanoShow/pages/login.dart';
import 'package:SindanoShow/pages/profileedit.dart';
import 'package:SindanoShow/utils/adhelper.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/utils/strings.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/widget/myusernetworkimg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileProvider profileProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _getData();
  }

  _getData() async {
    if (Constant.userID != null) {
      await profileProvider.getUserProfile(context);
    }
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            return _buildPage();
          },
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (profileProvider.loading) {
      return Utils.pageLoader();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Image */
          Container(
            height: Dimens.widthProfile,
            width: Dimens.heightProfile,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: Utils.setBGWithBorder(
                transparent, colorAccent, Dimens.heightProfile, 1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.heightProfile),
              child: MyUserNetworkImage(
                imagePath: (profileProvider.profileModel.status == 200 &&
                        profileProvider.profileModel.result != null)
                    ? (profileProvider.profileModel.result?[0].image ?? "")
                    : "",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /* Name */
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: MyText(
              color: black,
              text: Constant.userID == null
                  ? youAreNotSignIn
                  : (profileProvider.profileModel.status == 200 &&
                          profileProvider.profileModel.result != null)
                      ? ((profileProvider.profileModel.result?[0].type == 1 &&
                              (profileProvider
                                          .profileModel.result?[0].fullName ??
                                      "") ==
                                  "")
                          ? (profileProvider.profileModel.result?[0].userName ??
                              "")
                          : (profileProvider.profileModel.result?[0].fullName ??
                              ""))
                      : "-",
              multilanguage: false,
              textalign: TextAlign.center,
              fontsizeNormal: 16,
              fontweight: FontWeight.w700,
              fontsizeWeb: 16,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ),

          /* EditProfile */
          if (Constant.userID != null)
            FittedBox(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: InkWell(
                  onTap: () async {
                    if (Utils.checkLoginUser(context)) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ProfileEdit();
                          },
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration:
                        Utils.setBGWithBorder(transparent, colorPrimary, 8, 1),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: MyText(
                      color: black,
                      text: "editprofile",
                      multilanguage: true,
                      textalign: TextAlign.center,
                      fontsizeNormal: 13,
                      fontweight: FontWeight.w600,
                      fontsizeWeb: 13,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 25),

          /* Details */
          Expanded(
            child: _buildDetails(),
          ),
          Utils.showBannerAd(context),
        ],
      );
    }
  }

  Widget _buildDetails() {
    return Container(
      decoration: Utils.setBackground(whiteLight, 0),
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildDetailItem(
            iconName: "ic_email",
            title: "emailid",
            profileData: (profileProvider.profileModel.status == 200 &&
                    profileProvider.profileModel.result != null)
                ? ((profileProvider.profileModel.result?[0].email == "")
                    ? "-"
                    : (profileProvider.profileModel.result?[0].email ?? ""))
                : "-",
          ),
          const SizedBox(height: 25),
          _buildDetailItem(
            iconName: "ic_mobile",
            title: "mobile_number",
            profileData: (profileProvider.profileModel.status == 200 &&
                    profileProvider.profileModel.result != null)
                ? ((profileProvider.profileModel.result?[0].mobileNumber == "")
                    ? "-"
                    : (profileProvider.profileModel.result?[0].mobileNumber ??
                        ""))
                : "-",
          ),

          /* Login/Logout */
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: InkWell(
                onTap: () {
                  debugPrint("Clicked on logOut!");
                  if (Utils.checkLoginUser(context)) {
                    AdHelper.showFullscreenAd(context, Constant.rewardAdType,
                        () {
                      logoutConfirmDialog();
                    });
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 45,
                  alignment: Alignment.center,
                  decoration: Utils.setBGWithBorder(
                      colorPrimary, colorPrimaryDark, 45, 1),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: MyText(
                    color: white,
                    text: (Constant.userID != null) ? "logout" : "login",
                    multilanguage: true,
                    textalign: TextAlign.center,
                    fontsizeNormal: 15,
                    fontweight: FontWeight.w700,
                    fontsizeWeb: 15,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String iconName,
    required String title,
    required String profileData,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: Utils.setBGWithBorder(
              colorAccent.withOpacity(0.3), colorAccent, 50, 1),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: MyImage(
              fit: BoxFit.contain,
              imagePath: "$iconName.png",
              color: colorAccent,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                color: otherColor,
                text: title,
                multilanguage: true,
                textalign: TextAlign.start,
                fontsizeNormal: 14,
                fontweight: FontWeight.w500,
                fontsizeWeb: 14,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
              const SizedBox(height: 3),
              MyText(
                color: black,
                text: profileData,
                multilanguage: false,
                textalign: TextAlign.start,
                fontsizeNormal: 15,
                fontweight: FontWeight.w700,
                fontsizeWeb: 15,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
            ],
          ),
        ),
      ],
    );
  }

  logoutConfirmDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(23),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          color: black,
                          text: "confirmsognout",
                          multilanguage: true,
                          textalign: TextAlign.start,
                          fontsizeNormal: 16,
                          fontweight: FontWeight.bold,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(height: 3),
                        MyText(
                          color: gray,
                          text: "logout_info_msg",
                          multilanguage: true,
                          textalign: TextAlign.start,
                          fontsizeNormal: 13,
                          fontsizeWeb: 13,
                          fontweight: FontWeight.w500,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 75,
                            ),
                            height: 50,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: otherColor,
                                width: .5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: MyText(
                              color: black,
                              text: "cancel",
                              multilanguage: true,
                              textalign: TextAlign.center,
                              fontsizeNormal: 16,
                              maxline: 1,
                              overflow: TextOverflow.ellipsis,
                              fontweight: FontWeight.w500,
                              fontstyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () async {
                            await Utils.setUserId(null);
                            profileProvider.clearProvider();
                            Utils.updatePremium("0");
                            if (context.mounted) {
                              debugPrint(
                                  "========= get_profile loadAds =========");
                              Utils.loadAds(context);
                            }
                            // Firebase Signout
                            try {
                              await _auth.signOut();
                              await GoogleSignIn().signOut();
                            } catch (e) {
                              debugPrint("Logout Exception =====> $e");
                            }
                            if (!mounted) return;
                            Navigator.pop(context);
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const Login();
                                },
                              ),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 75,
                            ),
                            height: 50,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.center,
                            decoration: Utils.setBGWithBorder(
                                colorAccent, colorPrimaryDark, 5, 0.5),
                            child: MyText(
                              color: white,
                              text: "logout",
                              textalign: TextAlign.center,
                              fontsizeNormal: 16,
                              multilanguage: true,
                              maxline: 1,
                              overflow: TextOverflow.ellipsis,
                              fontweight: FontWeight.w500,
                              fontstyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((value) {
      debugPrint("============= LOGOUT =============");
      if (Constant.userID == null) {
        Utils.updatePremium("0");
        if (context.mounted) {
          debugPrint("========= get_profile loadAds =========");
          Utils.loadAds(context);
        }
      }
      if (!mounted) return;
      setState(() {});
    });
  }
}
