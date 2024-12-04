import 'dart:io';

import 'package:SindanoShow/provider/profileeditprovider.dart';
import 'package:SindanoShow/provider/profileprovider.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/utils/sharedpre.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/widget/myusernetworkimg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:SindanoShow/widget/nodata.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late ProfileEditProvider profileEditProvider;
  SharedPre sharePref = SharedPre();
  late ProgressDialog prDialog;
  File? pickedProfileFile;
  final ImagePicker imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final mFullNameController = TextEditingController();
  final mEmailController = TextEditingController();
  final mMobileController = TextEditingController();

  @override
  void initState() {
    prDialog = ProgressDialog(context);
    profileEditProvider =
        Provider.of<ProfileEditProvider>(context, listen: false);
    profileEditProvider.getProfile();
    super.initState();
  }

  @override
  void dispose() {
    profileEditProvider.clearProvider();
    FocusManager.instance.primaryFocus?.unfocus();
    mFullNameController.dispose();
    mEmailController.dispose();
    mMobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: Utils.myAppBarWithBack(context, "editprofile", true),
      body: Column(
        children: [
          Expanded(
            child: _buildPage(),
          ),
          Utils.showBannerAd(context),
        ],
      ),
    );
  }

  Widget _buildPage() {
    return Consumer<ProfileEditProvider>(
      builder: (context, profileEditProvider, child) {
        if (!profileEditProvider.loading) {
          if (profileEditProvider.profileModel.status == 200 &&
              profileEditProvider.profileModel.result != null) {
            if ((profileEditProvider.profileModel.result?.length ?? 0) > 0) {
              if (mFullNameController.text.toString().isEmpty) {
                mFullNameController.text =
                    profileEditProvider.profileModel.result?[0].fullName ?? "";
              }
              if (mEmailController.text.toString().isEmpty) {
                mEmailController.text =
                    profileEditProvider.profileModel.result?[0].email ?? "";
              }
              if (mMobileController.text.toString().isEmpty) {
                mMobileController.text =
                    profileEditProvider.profileModel.result?[0].mobileNumber ??
                        "";
              }
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        /* User Image */
                        _buildFrontThumb(),
                        const SizedBox(height: 40),

                        /* FullName */
                        _buildTextFormField(
                          controller: mFullNameController,
                          hintText: "fullname",
                          inputType: TextInputType.name,
                          readOnly: false,
                        ),
                        const SizedBox(height: 25),

                        /* Email Address */
                        _buildTextFormField(
                          controller: mEmailController,
                          hintText: "email_address",
                          inputType: TextInputType.emailAddress,
                          readOnly: false,
                        ),
                        const SizedBox(height: 25),

                        /* Mobile Number */
                        _buildTextFormField(
                          controller: mMobileController,
                          hintText: "mobile_number",
                          inputType: TextInputType.phone,
                          readOnly: false,
                        ),
                        const SizedBox(height: 50),

                        /* Save */
                        Align(
                          alignment: Alignment.center,
                          child: saveButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const NoData(title: '', subTitle: '');
            }
          } else {
            return const NoData(title: '', subTitle: '');
          }
        } else {
          return Utils.pageLoader();
        }
      },
    );
  }

  Widget _buildFrontThumb() {
    return Container(
      decoration: Utils.setGradTTBBorderWithBG(
          colorPrimaryDark, colorPrimary, transparent, 55, 1),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(55),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            pickedProfileFile != null
                ? Image.file(
                    pickedProfileFile!,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100,
                  )
                : MyUserNetworkImage(
                    imagePath:
                        profileEditProvider.profileModel.result?[0].image ?? "",
                    fit: BoxFit.cover,
                    imgHeight: 100,
                    imgWidth: 100,
                  ),
            Container(
              height: 100,
              width: 100,
              decoration: Utils.setBackground(
                  pickedProfileFile != null
                      ? transparent
                      : black.withOpacity(0.5),
                  0),
            ),
            /* Camera Image */
            InkWell(
              onTap: () {
                imagePickDialog("front");
              },
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: const EdgeInsets.all(5),
                child: MyImage(
                  width: 25,
                  height: 25,
                  imagePath: "ic_edit.png",
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType inputType,
    required bool readOnly,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        obscureText: false,
        maxLines: 1,
        readOnly: readOnly,
        cursorColor: colorPrimary,
        cursorRadius: const Radius.circular(2),
        decoration: InputDecoration(
          filled: true,
          isDense: false,
          fillColor: transparent,
          focusedBorder: const GradientOutlineInputBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorPrimaryDark, colorPrimary],
            ),
            width: 1,
          ),
          border: GradientOutlineInputBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorPrimaryDark.withOpacity(0.5),
                colorPrimary.withOpacity(0.5)
              ],
            ),
            width: 1,
          ),
          label: MyText(
            multilanguage: true,
            color: otherColor,
            text: hintText,
            textalign: TextAlign.start,
            fontstyle: FontStyle.normal,
            fontsizeNormal: 14,
            fontsizeWeb: 14,
            fontweight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: GoogleFonts.inter(
          textStyle: const TextStyle(
            fontSize: 14,
            color: black,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }

  Future<void> imagePickDialog(String picType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                MyText(
                  multilanguage: true,
                  text: "add_photo",
                  color: black,
                  fontsizeNormal: 18,
                  fontsizeWeb: 16,
                  maxline: 4,
                  fontstyle: FontStyle.normal,
                  fontweight: FontWeight.bold,
                  textalign: TextAlign.start,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: MyText(
                multilanguage: true,
                text: "choose_from_gallery",
                color: black,
                fontsizeNormal: 16,
                fontsizeWeb: 16,
                fontstyle: FontStyle.normal,
                fontweight: FontWeight.bold,
                textalign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getFromGallery(picType);
              },
            ),
            TextButton(
              child: MyText(
                multilanguage: true,
                text: "take_photo",
                color: black,
                fontsizeNormal: 16,
                fontsizeWeb: 16,
                fontstyle: FontStyle.normal,
                fontweight: FontWeight.bold,
                textalign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                getFromCamera(picType);
              },
            ),
            TextButton(
              child: MyText(
                multilanguage: true,
                text: "cancel",
                color: black,
                fontsizeNormal: 16,
                fontsizeWeb: 16,
                fontstyle: FontStyle.normal,
                fontweight: FontWeight.w500,
                textalign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Get from gallery
  void getFromGallery(String picType) async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      setState(() {
        pickedProfileFile = File(pickedFile.path);
        debugPrint("Gallery pickedProfileFile ==> ${pickedProfileFile?.path}");
      });
    }
  }

  /// Get from Camera
  void getFromCamera(String picType) async {
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      setState(() {
        pickedProfileFile = File(pickedFile.path);
        debugPrint("Camera pickedProfileFile ==> ${pickedProfileFile?.path}");
      });
    }
  }

  Widget saveButton() {
    return InkWell(
      focusColor: white,
      onTap: () => validateAndUpdate(),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Dimens.buttonHeight,
        decoration:
            Utils.setBGWithBorder(colorPrimary, colorPrimaryDark, 30, 1),
        alignment: Alignment.center,
        child: MyText(
          multilanguage: true,
          text: "save",
          color: white,
          textalign: TextAlign.center,
          fontsizeNormal: 20,
          fontsizeWeb: 20,
          fontweight: FontWeight.w700,
          fontstyle: FontStyle.normal,
        ),
      ),
    );
  }

  validateAndUpdate() async {
    print("nimefika hapa");
    FocusManager.instance.primaryFocus?.unfocus();
    String fullName = mFullNameController.text.toString().trim();
    String email = mEmailController.text.toString().trim();
    String mobile = mMobileController.text.toString().trim();

    final isValidForm = _formKey.currentState!.validate();
    debugPrint("isValidForm => $isValidForm");
    // Validate returns true if the form is valid, or false otherwise.
    if (isValidForm) {
      debugPrint("fullName =====> $fullName");
      debugPrint("Email ========> $email");
      debugPrint("MobileNumber => $mobile");
      debugPrint("pickedProfileFile ==> ${pickedProfileFile?.path}");

      if (fullName.isEmpty) {
        Utils.showSnackbar(context, "info", "enter_fullname", true);
        return;
      }
      if (email.isEmpty) {
        Utils.showSnackbar(context, "info", "enter_email", true);
        return;
      }
      if (mobile.isEmpty) {
        Utils.showSnackbar(context, "info", "enter_mobile_number", true);
        return;
      }
      if (!EmailValidator.validate(mEmailController.text.toString())) {
        Utils.showSnackbar(context, "info", "enter_valid_email", true);
        return;
      }
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      // updateprofile API call
      Utils.showProgress(context, prDialog);
      try {
        await profileEditProvider.getUpdateProfile(fullName, email, mobile,
            (pickedProfileFile != null) ? pickedProfileFile : null);
      } catch (e) {
        prDialog.hide();
        debugPrint('getUpdateProfile Exception ==>> $e');
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "server_error", false);
      }

      debugPrint(
          'validateAndUpdate loading ==>> ${profileEditProvider.loading}');
      if (!profileEditProvider.loading) {
        clearControllers();
        // Hide Progress Dialog
        prDialog.hide();
        if (profileEditProvider.successModel.status == 200) {
          if (!mounted) return;
          Utils.showSnackbar(context, "success",
              profileEditProvider.successModel.message ?? "", false);
          await profileProvider.getUserProfile(context);
          await profileEditProvider.getProfile();
          if (profileEditProvider.profileModel.status == 200) {
            debugPrint(
                'EditProfile email ==>> ${profileEditProvider.profileModel.result?[0].email.toString()}');

            /* Save Users Credentials */
            Utils.saveUserCreds(
              userID: profileEditProvider.profileModel.result?[0].id.toString(),
              userName: profileEditProvider.profileModel.result?[0].fullName
                      .toString() ??
                  "",
              userEmail: profileEditProvider.profileModel.result?[0].email
                      .toString() ??
                  "",
              userMobile: profileEditProvider
                      .profileModel.result?[0].mobileNumber
                      .toString() ??
                  "",
              userImage: profileEditProvider.profileModel.result?[0].image
                      .toString() ??
                  "",
              userType:
                  profileEditProvider.profileModel.result?[0].type.toString() ??
                      "",
              userPremium: profileEditProvider.profileModel.result?[0].isBuy
                      .toString() ??
                  "0",
            );
          }
        } else {
          if (!mounted) return;
          Utils.showSnackbar(context, "info",
              profileEditProvider.successModel.message ?? "", false);
        }
      }
    }
  }

  clearControllers() {
    pickedProfileFile = null;
    mFullNameController.clear();
    mEmailController.clear();
    mMobileController.clear();
  }
}
