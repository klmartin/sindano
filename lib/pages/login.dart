import 'dart:convert';
import 'dart:io';
import 'package:Sindano/provider/userstatusprovider.dart';
import 'package:Sindano/subscription/subscription.dart';
import 'package:crypto/crypto.dart';
import 'package:Sindano/provider/generalprovider.dart';
import 'package:Sindano/pages/otpverify.dart';
import 'package:Sindano/pages/bottompage.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/sharedpre.dart';
import 'package:Sindano/utils/strings.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late ProgressDialog prDialog;
  late GeneralProvider generalProvider;
  late UserStatusProvider userStatusProvider;
  File? mProfileImg;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userEmail = "";
  TextEditingController phoneController = TextEditingController();
  String? mobileNumber,
      email,
      userName,
      strType,
      strDeviceType,
      strDeviceToken,
      strPrivacyAndTNC;
  SharedPre sharePref = SharedPre();

  @override
  void initState() {
    prDialog = ProgressDialog(context);
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    userStatusProvider =
        Provider.of<UserStatusProvider>(context, listen: false);
    userStatusProvider.checkUserStatus2();
    super.initState();
    _getData();
    _getDeviceToken();
  }

  _getData() async {
    String? privacyUrl, termsConditionUrl;
    await generalProvider.getPages();
    if (!generalProvider.loading) {
      if (generalProvider.pagesModel.status == 200 &&
          generalProvider.pagesModel.result != null) {
        if ((generalProvider.pagesModel.result?.length ?? 0) > 0) {
          for (var i = 0;
              i < (generalProvider.pagesModel.result?.length ?? 0);
              i++) {
            if ((generalProvider.pagesModel.result?[i].pageName ?? "")
                .toLowerCase()
                .contains("privacy")) {
              privacyUrl = generalProvider.pagesModel.result?[i].url;
            }
            if ((generalProvider.pagesModel.result?[i].pageName ?? "")
                .toLowerCase()
                .contains("terms")) {
              termsConditionUrl = generalProvider.pagesModel.result?[i].url;
            }
          }
        }
      }
    }
    debugPrint('privacyUrl ==> $privacyUrl');
    debugPrint('termsConditionUrl ==> $termsConditionUrl');

    strPrivacyAndTNC = await Utils.getPrivacyTandCText(
        privacyUrl ?? "", termsConditionUrl ?? "");
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  _getDeviceToken() async {
    if (Platform.isAndroid) {
      strDeviceType = "1";
      strDeviceToken = await FirebaseMessaging.instance.getToken();
    } else {
      strDeviceType = "2";
      strDeviceToken = OneSignal.User.pushSubscription.token;
    }
    debugPrint("===>strDeviceToken $strDeviceToken");
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bglogin.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: MyImage(
                  imagePath: "logo5.png",
                  fit: BoxFit.contain,
                ),
              ),

              /* Enter Mobile Number */
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                  textAlignVertical: TextAlignVertical.center,
                  autovalidateMode: AutovalidateMode.disabled,
                  controller: phoneController,
                  style: const TextStyle(fontSize: 16, color: white),
                  showCountryFlag: false,
                  showDropdownIcon: false,
                  initialCountryCode: 'TZ',
                  dropdownTextStyle: GoogleFonts.inter(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: false,
                    hintStyle: GoogleFonts.inter(
                      color: whiteLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: enterYourMobileNumber,
                  ),
                  onChanged: (phone) {
                    debugPrint('===> ${phone.completeNumber}');
                    debugPrint('===> ${phoneController.text}');
                    mobileNumber = phone.completeNumber;
                    debugPrint('===>mobileNumber $mobileNumber');
                  },
                  onCountryChanged: (country) {
                    debugPrint('===> ${country.name}');
                    debugPrint('===> ${country.code}');
                  },
                ),
              ),
              const SizedBox(height: 25),

              /* Login Button */
              Container(
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: InkWell(
                  onTap: () {
                    debugPrint("Click mobileNumber ==> $mobileNumber");
                    if (phoneController.text.toString().isEmpty) {
                      Utils.showSnackbar(
                          context, "info", "login_with_mobile_note", true);
                    } else {
                      debugPrint("mobileNumber ==> $mobileNumber");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OTPVerify(mobileNumber ?? ""),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: colorAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: MyText(
                      color: white,
                      text: "login",
                      multilanguage: true,
                      fontsizeNormal: 17,
                      fontsizeWeb: 19,
                      fontweight: FontWeight.w700,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /* Privacy & TermsCondition link */
              if (strPrivacyAndTNC != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Utils.htmlTexts(strPrivacyAndTNC),
                ),

              /* Or */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 1,
                    color: otherColor,
                  ),
                  const SizedBox(width: 15),
                  MyText(
                    color: otherColor,
                    text: "or",
                    multilanguage: true,
                    fontsizeNormal: 14,
                    fontsizeWeb: 16,
                    fontweight: FontWeight.w500,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 80,
                    height: 1,
                    color: otherColor,
                  ),
                ],
              ),
              const SizedBox(height: 25),

              /* Google Login Button */
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                margin: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    debugPrint("Clicked on : ====> loginWith Google");
                    _gmailLogin();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyImage(
                        width: 30,
                        height: 30,
                        imagePath: "ic_google.png",
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 30),
                      MyText(
                        color: black,
                        text: "loginwithgoogle",
                        fontsizeNormal: 14,
                        fontsizeWeb: 16,
                        multilanguage: true,
                        fontweight: FontWeight.w600,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ],
                  ),
                ),
              ),

              /* Apple Login Button */
              if (Platform.isIOS)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      debugPrint("Clicked on : ====> loginWith Apple");
                      signInWithApple();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage(
                          width: 30,
                          height: 30,
                          imagePath: "ic_apple.png",
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 30),
                        MyText(
                          color: black,
                          text: "loginwithapple",
                          fontsizeNormal: 14,
                          fontsizeWeb: 16,
                          multilanguage: true,
                          fontweight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /* Google Login */
  Future<void> _gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    Utils.showProgress(context, prDialog);

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

      checkAndNavigate(user.email, user.displayName ?? "", "2", firebasedid);
    } on FirebaseAuthException catch (e) {
      debugPrint('===>Exp${e.code.toString()}');
      debugPrint('===>Exp${e.message.toString()}');
      if (e.code.toString() == "user-not-found") {
      } else if (e.code == 'wrong-password') {
        // Hide Progress Dialog
        await prDialog.hide();
        debugPrint('Wrong password provided.');
        Utils().showToast('Wrong password provided.');
      } else {
        // Hide Progress Dialog
        await prDialog.hide();
      }
    }
  }

  /* Apple Login */
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await _auth.signInWithCredential(oauthCredential);

      String? displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      userEmail = authResult.user?.email.toString() ?? "";
      debugPrint("===>userEmail $userEmail");
      debugPrint("===>displayName $displayName");
      debugPrint("===>firebasedId ${authResult.user?.uid}");

      final firebaseUser = authResult.user;

      dynamic firebasedId = firebaseUser?.uid.toString();

      if (displayName != 'null' || displayName != 'null null') {
        await firebaseUser?.updateDisplayName(displayName);
      }
      displayName = firebaseUser?.displayName.toString();

      if (userEmail.isNotEmpty || userEmail != 'null') {
        await firebaseUser
            ?.updateEmail(authResult.user?.email.toString() ?? "");
      }
      userEmail = firebaseUser?.email.toString() ?? "";

      debugPrint("userEmail =====FINAL==> $userEmail");
      debugPrint("firebasedId ===FINAL==> $firebasedId");
      debugPrint("displayName ===FINAL==> $displayName");

      checkAndNavigate(userEmail, displayName ?? "", "3", firebasedId);
    } catch (exception) {
      debugPrint("Apple Login exception =====> $exception");
    }
    return null;
  }

  checkAndNavigate(
      String mail, String displayName, String type, String firebaseId) async {
    email = mail;
    userName = displayName;
    strType = type;
    debugPrint('checkAndNavigate email ==>> $email');
    debugPrint('checkAndNavigate userName ==>> $userName');
    debugPrint('checkAndNavigate strType ==>> $strType');
    debugPrint('checkAndNavigate mProfileImg :===> $mProfileImg');
    debugPrint('checkAndNavigate firebaseId :===> $firebaseId');
    if (!prDialog.isShowing()) {
      Utils.showProgress(context, prDialog);
    }
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    final userStatusProvider =
        Provider.of<UserStatusProvider>(context, listen: false);
    await generalProvider.loginWithSocial(
        email, userName, strType, strDeviceToken, mProfileImg, firebaseId);
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
        /* Update Premium */
        Utils.updatePremium(
            generalProvider.loginSocialModel.result?[0].isBuy.toString() ??
                "0");

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginSocialModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');

        // Hide Progress Dialog
        await prDialog.hide();
        if (!mounted) return;
        if (userStatusProvider.hasSubscription!) {
          debugPrint(
              'User has an active subscription login. Navigating to BottomPage.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Bottompage()),
            (Route<dynamic> route) => false,
          );
        } else {
          debugPrint(
              'User does NOT have an active subscription login. Navigating to SubscriptionPage.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Subscription()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        // Hide Progress Dialog
        await prDialog.hide();
        if (!mounted) return;
        Utils.showSnackbar(context, "fail",
            "${generalProvider.loginSocialModel.message}", false);
      }
    }
  }
}
