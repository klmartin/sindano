import 'dart:async';
import 'dart:io';

import 'package:Sindano/provider/generalprovider.dart';
import 'package:Sindano/pages/bottompage.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/sharedpre.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class OTPVerify extends StatefulWidget {
  final String mobileNumber;
  const OTPVerify(this.mobileNumber, {Key? key}) : super(key: key);

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ProgressDialog prDialog;
  SharedPre sharePref = SharedPre();
  final otpController = OtpFieldController();
  int? forceResendingToken;
  bool codeResended = false;
  String? verificationId, strDeviceType, strDeviceToken;
  String strSMSCode = "";

  @override
  void initState() {
    super.initState();
    prDialog = ProgressDialog(context);
    codeSend(false);
    _getDeviceToken();
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
    FocusManager.instance.primaryFocus?.unfocus();
    otpController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appBgColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bglogin.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    MyText(
                      color: white,
                      text: "verifyphonenumber",
                      fontsizeNormal: 22,
                      multilanguage: true,
                      fontweight: FontWeight.bold,
                      fontfamily: "RubikMedium",
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 8),
                    MyText(
                      color: otherColor,
                      text: "code_sent_desc",
                      fontsizeNormal: 15,
                      fontweight: FontWeight.w500,
                      fontfamily: "RubikMedium",
                      maxline: 3,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      multilanguage: true,
                      fontstyle: FontStyle.normal,
                    ),
                    MyText(
                      color: otherColor,
                      text: widget.mobileNumber,
                      fontsizeNormal: 15,
                      fontweight: FontWeight.w500,
                      fontfamily: 'Popins',
                      maxline: 3,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      multilanguage: false,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 40),

                    /* Enter Received OTP */
                    OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 45,
                      controller: otpController,
                      fieldStyle: FieldStyle.box,
                      otpFieldStyle: OtpFieldStyle(
                        backgroundColor: otherColor,
                        borderColor: colorAccent,
                      ),
                      outlineBorderRadius: 5,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: white,
                        fontWeight: FontWeight.w700,
                      ),
                      onChanged: (pin) {},
                      onCompleted: (pin) {
                        debugPrint("onCompleted pin =====> $pin");
                        strSMSCode = pin.toString();
                        if (pin.isEmpty) {
                          Utils.showSnackbar(
                              context, "info", "enterreceivedotp", true);
                        } else {
                          if (verificationId == null || verificationId == "") {
                            Utils.showSnackbar(
                                context, "info", "otp_not_working", true);
                            return;
                          }
                          Utils.showProgress(context, prDialog);
                          _checkOTPAndLogin();
                        }
                      },
                    ),
                    const SizedBox(height: 50),

                    /* Confirm Button */
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        debugPrint("Clicked strSMSCode =====> $strSMSCode");
                        if (strSMSCode.isEmpty) {
                          Utils.showSnackbar(
                              context, "info", "enterreceivedotp", true);
                        } else {
                          if (verificationId == null || verificationId == "") {
                            Utils.showSnackbar(
                                context, "info", "otp_not_working", true);
                            return;
                          }
                          Utils.showProgress(context, prDialog);
                          _checkOTPAndLogin();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        decoration: BoxDecoration(
                          color: colorAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: MyText(
                          color: white,
                          text: "confirm",
                          fontsizeNormal: 17,
                          multilanguage: true,
                          fontweight: FontWeight.w700,
                          fontfamily: "RubikMedium",
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),

                    /* Resend */
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (!codeResended) {
                          codeSend(true);
                        }
                      },
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 70),
                        padding: const EdgeInsets.all(5),
                        child: MyText(
                          color: white,
                          text: "resend",
                          multilanguage: true,
                          fontsizeNormal: 16,
                          fontweight: FontWeight.w700,
                          fontfamily: "RubikMedium",
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: MyImage(
                        fit: BoxFit.contain,
                        imagePath: "ic_back.png",
                        color: white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  codeSend(bool isResend) async {
    codeResended = isResend;
    await phoneSignIn(phoneNumber: widget.mobileNumber.toString());
    prDialog.hide();
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    debugPrint("phoneSignIn phoneNumber =======> $phoneNumber");
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    debugPrint("verification completed ======> ${authCredential.smsCode}");
    setState(() {
      strSMSCode = authCredential.smsCode ?? "";
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      debugPrint("The phone number entered is invalid!");
      Utils.showSnackbar(context, "fail", "invalidphonenumber", true);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
    debugPrint("verificationId =======> $verificationId");
    debugPrint("resendingToken =======> ${forceResendingToken.toString()}");
    debugPrint("code sent");
  }

  _onCodeTimeout(String verificationId) {
    debugPrint("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    prDialog.hide();
    codeResended = false;
    return null;
  }

  _checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    debugPrint("_checkOTPAndLogin verificationId ====> $verificationId");
    debugPrint("_checkOTPAndLogin strSMSCode ========> $strSMSCode");

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: strSMSCode,
    );

    debugPrint(
        "phoneAuthCredential.smsCode        =====> ${phoneAuthCredential.smsCode}");
    debugPrint(
        "phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      debugPrint(
          "_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      prDialog.hide();
      debugPrint("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "otp_invalid", true);
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "otp_session_expired", true);
        return;
      } else {
        error = true;
      }
    }
    debugPrint(
        "Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      _login(widget.mobileNumber.toString());
    } else {
      prDialog.hide();
      if (!mounted) return;
      Utils.showSnackbar(context, "fail", "otp_login_fail", true);
    }
  }

  _login(String mobile) async {
    debugPrint("click on Submit mobile => $mobile");
    var generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    if (!prDialog.isShowing()) {
      Utils.showProgress(context, prDialog);
    }
    await generalProvider.loginWithOTP(mobile, strDeviceToken);

    if (!generalProvider.loading) {
      if (generalProvider.loginOTPModel.status == 200) {
        debugPrint(
            'loginOTPModel ==>> ${generalProvider.loginOTPModel.toString()}');
        debugPrint('Login Successfull!');
        Utils.saveUserCreds(
          userID: generalProvider.loginOTPModel.result?[0].id.toString(),
          userName:
              generalProvider.loginOTPModel.result?[0].fullName.toString(),
          userEmail: generalProvider.loginOTPModel.result?[0].email.toString(),
          userMobile:
              generalProvider.loginOTPModel.result?[0].mobileNumber.toString(),
          userImage: generalProvider.loginOTPModel.result?[0].image.toString(),
          userPremium:
              generalProvider.loginOTPModel.result?[0].isBuy.toString(),
          userType: generalProvider.loginOTPModel.result?[0].type.toString(),
        );
        /* Update Premium */
        Utils.updatePremium(
            generalProvider.loginOTPModel.result?[0].isBuy.toString() ?? "0");

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginOTPModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');

        await prDialog.hide();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Bottompage()),
          (Route<dynamic> route) => false,
        );
      } else {
        await prDialog.hide();
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", "${generalProvider.loginOTPModel.message}", false);
      }
    }
  }
}
