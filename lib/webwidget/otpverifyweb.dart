import 'package:Sindano/provider/generalprovider.dart';
import 'package:Sindano/provider/homeprovider.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/sharedpre.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'
    show FirebaseAuthPlatform;

class OTPVerifyWeb extends StatefulWidget {
  final String? mobileNumber;
  const OTPVerifyWeb(this.mobileNumber, {Key? key}) : super(key: key);

  @override
  State<OTPVerifyWeb> createState() => _OTPVerifyWebState();
}

class _OTPVerifyWebState extends State<OTPVerifyWeb> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPre sharePref = SharedPre();
  final pinPutController = OtpFieldController();
  String? verificationId;
  int? forceResendingToken;
  bool codeResended = false;
  String strSMSCode = "";

  @override
  void initState() {
    super.initState();
    recptcha();
  }

  recptcha() async {
    if (kIsWeb) {
      debugPrint("===>Web");
      ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(
        widget.mobileNumber ?? "",
        RecaptchaVerifier(
          container: 'recaptcha',
          onSuccess: () => codeSend(false),
          onError: (FirebaseAuthException error) => _onVerificationFailed,
          onExpired: () => _onVerificationFailed,
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.dark,
          auth: FirebaseAuthPlatform.instance,
        ),
      );
      debugPrint("verificationId ===> ${confirmationResult.verificationId}");
    } else {
      debugPrint("===>app");
      codeSend(false);
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    pinPutController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          (MediaQuery.of(context).size.width * 0.33) <= 360 ? 15 : 50,
          40,
          (MediaQuery.of(context).size.width * 0.33) <= 360 ? 15 : 50,
          40),
      constraints: BoxConstraints(
        minWidth: 360,
        minHeight: 200,
        maxWidth: (MediaQuery.of(context).size.width * 0.33) <= 360
            ? 360
            : (MediaQuery.of(context).size.width * 0.33),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                focusColor: white.withOpacity(0.5),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: 25,
                    height: 25,
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
            const SizedBox(height: 30),
            MyText(
              color: white,
              text: "verifyphonenumber",
              fontsizeNormal: 26,
              fontsizeWeb: 21,
              multilanguage: true,
              fontweight: FontWeight.bold,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
            ),
            const SizedBox(height: 8),
            MyText(
              color: otherColor,
              text: "code_sent_desc",
              fontsizeNormal: 15,
              fontsizeWeb: 16,
              fontweight: FontWeight.w600,
              maxline: 3,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              multilanguage: true,
              fontstyle: FontStyle.normal,
            ),
            MyText(
              color: otherColor,
              text: widget.mobileNumber ?? "",
              fontsizeNormal: 15,
              fontsizeWeb: 16,
              fontweight: FontWeight.w600,
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
              controller: pinPutController,
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
                setState(() {});
              },
            ),
            const SizedBox(height: 30),

            /* Confirm Button */
            InkWell(
              onTap: () {
                debugPrint("Clicked sms Code =====> $strSMSCode");
                if (strSMSCode.isEmpty) {
                  Utils.showSnackbar(context, "info", "enterreceivedotp", true);
                } else {
                  if (verificationId == null || verificationId == "") {
                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Utils.showSnackbar(
                        context, "info", "otp_not_working", true);
                    return;
                  }
                  _checkOTPAndLogin();
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
                    text: "confirm",
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
            const SizedBox(height: 30),

            /* Resend */
            InkWell(
              borderRadius: BorderRadius.circular(10),
              focusColor: white.withOpacity(0.5),
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
                  fontsizeWeb: 15,
                  fontweight: FontWeight.w700,
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
    );
  }

  codeSend(bool isResend) async {
    codeResended = isResend;
    await phoneSignIn(phoneNumber: widget.mobileNumber.toString());
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
      if (!mounted) return;
      Utils.showSnackbar(context, "fail", "otp_login_fail", true);
    }
  }

  _login(String mobile) async {
    debugPrint("click on Submit mobile => $mobile");
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    await generalProvider.loginWithOTP(mobile, "");

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

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginOTPModel.result?[0].id.toString();
        debugPrint('Constant userID ==>> ${Constant.userID}');
        await homeProvider.homeNotifyProvider();

        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", "${generalProvider.loginOTPModel.message}", false);
      }
    }
  }
}
