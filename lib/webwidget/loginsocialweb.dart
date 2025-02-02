import 'dart:io';

import 'package:Sindano/provider/generalprovider.dart';
import 'package:Sindano/provider/homeprovider.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/strings.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class LoginSocialWeb extends StatefulWidget {
  const LoginSocialWeb({super.key});

  @override
  State<LoginSocialWeb> createState() => _LoginSocialWebState();
}

class _LoginSocialWebState extends State<LoginSocialWeb> {
  final numberController = TextEditingController();
  String? mobileNumber, email, userName, strType;
  File? mProfileImg;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          (MediaQuery.of(context).size.width * 0.33) <= 360 ? 15 : 50,
          35,
          (MediaQuery.of(context).size.width * 0.33) <= 360 ? 15 : 50,
          35),
      constraints: BoxConstraints(
        minWidth: 360,
        minHeight: 200,
        maxWidth: (MediaQuery.of(context).size.width * 0.33) <= 360
            ? 360
            : (MediaQuery.of(context).size.width * 0.33),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: MyImage(
                        imagePath: "logo5.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    focusColor: white.withOpacity(0.5),
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: MyImage(
                        fit: BoxFit.contain,
                        imagePath: "ic_close.png",
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            /* Enter Mobile Number */
            Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary,
                  width: 0.7,
                ),
                color: edtBG,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: IntlPhoneField(
                disableLengthCheck: true,
                controller: numberController,
                textAlignVertical: TextAlignVertical.center,
                autovalidateMode: AutovalidateMode.disabled,
                style: const TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                showCountryFlag: false,
                showDropdownIcon: false,
                initialCountryCode: 'IN',
                dropdownTextStyle: GoogleFonts.montserrat(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.montserrat(
                    color: otherColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: enterYourMobileNumber,
                ),
                onChanged: (phone) {
                  debugPrint('===> ${phone.completeNumber}');
                  mobileNumber = phone.completeNumber;
                  debugPrint('===>mobileNumber $mobileNumber');
                },
                onCountryChanged: (country) {
                  debugPrint('===> ${country.name}');
                  debugPrint('===> ${country.code}');
                },
              ),
            ),
            const SizedBox(height: 35),

            /* Login Button */
            InkWell(
              onTap: () {
                debugPrint("Click mobileNumber ==> $mobileNumber");
                if (numberController.text.toString().isEmpty) {
                  Utils.showSnackbar(
                      context, "info", "login_with_mobile_note", true);
                } else {
                  debugPrint("mobileNumber ==> $mobileNumber");
                  Utils.buildWebAlertDialog(context, "otp", mobileNumber);
                }
              },
              focusColor: white,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        colorPrimary,
                        colorPrimaryDark,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: MyText(
                    color: white,
                    text: "login",
                    multilanguage: true,
                    fontsizeNormal: 15,
                    fontsizeWeb: 15,
                    fontweight: FontWeight.w600,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: colorAccent,
                  ),
                ),
                const SizedBox(width: 15),
                MyText(
                  color: otherColor,
                  text: "or",
                  multilanguage: true,
                  fontsizeNormal: 14,
                  fontsizeWeb: 15,
                  fontweight: FontWeight.w500,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 1,
                    color: colorAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),

            /* Google Login Button */
            InkWell(
              onTap: () {
                debugPrint("Clicked on : ====> loginWith Google");
                _gmailLogin();
              },
              focusColor: colorPrimary,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyImage(
                        width: 20,
                        height: 20,
                        imagePath: "ic_google.png",
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 25),
                      Flexible(
                        child: MyText(
                          color: black,
                          text: "loginwithgoogle",
                          fontsizeNormal: 14,
                          fontsizeWeb: 12,
                          multilanguage: true,
                          fontweight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Google(Gmail) Login */
  Future<void> _gmailLogin() async {
    final googleUser =
        await GoogleSignIn().signIn().onError((error, stackTrace) async {
      debugPrint('GoogleSignIn onError ===> : ${error.toString()}');
      return await GoogleSignIn().signInSilently();
    });
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      debugPrint("User Name: ${userCredential.user?.displayName}");
      debugPrint("User Email ${userCredential.user?.email}");
      debugPrint("User photoUrl ${userCredential.user?.photoURL}");
      debugPrint("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      debugPrint('firebasedid :===> $firebasedid');

      /* Save PhotoUrl in File */
      mProfileImg =
          await Utils.saveImageInStorage(userCredential.user?.photoURL ?? "");
      debugPrint('mProfileImg :===> $mProfileImg');

      checkAndNavigate(user.email, user.displayName ?? "", "2",firebasedid);
    } on FirebaseAuthException catch (e) {
      debugPrint('===>Exp${e.code.toString()}');
      debugPrint('===>Exp${e.message.toString()}');
      if (e.code.toString() == "user-not-found") {
        // registerFirebaseUser(user.email, user.displayName ?? "", "2");
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
        Utils().showToast('Wrong password provided.');
      } else {}
    }
  }

  void checkAndNavigate(String mail, String displayName, String type,String firebaseId) async {
    email = mail;
    userName = displayName;
    strType = type;
    debugPrint('checkAndNavigate email ==>> $email');
    debugPrint('checkAndNavigate userName ==>> $userName');
    debugPrint('checkAndNavigate strType ==>> $strType');
    debugPrint('checkAndNavigate mProfileImg :===> $mProfileImg');
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    await generalProvider.loginWithSocial(
        email, userName, strType, strType, mProfileImg,firebaseId);
    debugPrint('checkAndNavigate loading ==>> ${generalProvider.loading}');

    if (!generalProvider.loading) {
      if (generalProvider.loginSocialModel.status == 200) {
        debugPrint('Login Successfull!');
        Utils.saveUserCreds(
          userID: generalProvider.loginSocialModel.result?[0].id.toString(),
          userName:
              generalProvider.loginSocialModel.result?[0].fullName.toString(),
          userEmail:
              generalProvider.loginSocialModel.result?[0].email.toString(),
          userMobile: generalProvider.loginSocialModel.result?[0].mobileNumber
              .toString(),
          userImage:
              generalProvider.loginSocialModel.result?[0].image.toString(),
          userPremium:
              generalProvider.loginSocialModel.result?[0].isBuy.toString(),
          userType: generalProvider.loginSocialModel.result?[0].type.toString(),
        );

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginSocialModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');
        await homeProvider.homeNotifyProvider();

        if (!mounted) return;
        Navigator.pop(context);
      } else {
        // Hide Progress Dialog
        if (!mounted) return;
        Utils.showSnackbar(context, "fail",
            "${generalProvider.loginSocialModel.message}", false);
      }
    }
  }
}
