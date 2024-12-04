import 'dart:io';

import 'package:SindanoShow/provider/bottomprovider.dart';
import 'package:SindanoShow/provider/generalprovider.dart';
import 'package:SindanoShow/pages/aboutprivacyterms.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mynetworkimg.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class Sidedrawer extends StatefulWidget {
  const Sidedrawer({Key? key}) : super(key: key);

  @override
  State<Sidedrawer> createState() => _SidedrawerState();
}

class _SidedrawerState extends State<Sidedrawer> with WidgetsBindingObserver {
  late GeneralProvider generalProvider;

  @override
  void initState() {
    super.initState();
    generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    _getData();
  }

  _getData() async {
    await generalProvider.getPages();

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: transparent,
      body: Container(
        width: kIsWeb
            ? (MediaQuery.of(context).size.width * 0.35)
            : (MediaQuery.of(context).size.width),
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/drawer.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /* Close & App Icon */
              _buildAppBar(),

              /* Feature buttons */
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
                  child: Column(
                    children: [
                      _buildFeatureRow(
                        item1: _buildFeatureBtn(
                          iconName: "ic_language",
                          isUrl: false,
                          title: "language",
                          isTitleMultilang: true,
                          onClick: () {
                            _languageChangeDialog();
                          },
                        ),
                        item2: _buildFeatureBtn(
                          iconName: "ic_subscription",
                          isUrl: false,
                          title: "subscription",
                          isTitleMultilang: true,
                          onClick: () {
                            Utils.openSubscription(context: context);
                          },
                        ),
                      ),
                      _buildLine(isVertical: false),
                      _buildFeatureRow(
                        item1: _buildFeatureBtn(
                          iconName: "ic_rate",
                          isUrl: false,
                          title: "rateapp",
                          isTitleMultilang: true,
                          onClick: () async {
                            debugPrint("Clicked on rateApp");
                            await Utils.redirectToStore();
                          },
                        ),
                        item2: _buildFeatureBtn(
                          iconName: "ic_share",
                          isUrl: false,
                          title: "shareapp",
                          isTitleMultilang: true,
                          onClick: () async {
                            await Utils.shareApp(Platform.isIOS
                                ? Constant.iosAppShareUrlDesc
                                : Constant.androidAppShareUrlDesc);
                          },
                        ),
                      ),
                      _buildLine(isVertical: false),
                      _buildPages(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              final bottomProvider =
                  Provider.of<BottomProvider>(context, listen: false);
              Navigator.pop(context);
              bottomProvider.checkVisibility(true);
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: 50,
              padding: const EdgeInsets.all(17),
              alignment: Alignment.center,
              child: MyImage(
                imagePath: "ic_close.png",
                fit: BoxFit.contain,
                color: white,
              ),
            ),
          ),
          const SizedBox(width: 15),
          MyImage(
            imagePath: "logo5.png",
            fit: BoxFit.contain,
            width: 170,
            height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }

  Widget _buildLine({required bool isVertical}) {
    if (isVertical) {
      return Container(
        width: 1,
        height: MediaQuery.of(context).size.height,
        decoration: Utils.setBackground(white, 1),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 1,
        decoration: Utils.setBackground(white, 1),
      );
    }
  }

  Widget _buildFeatureRow({
    required Widget item1,
    required Widget item2,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(maxHeight: 110),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: item1,
          ),
          _buildLine(isVertical: true),
          Expanded(
            child: item2,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBtn({
    required String iconName,
    required bool isUrl,
    required String title,
    required bool isTitleMultilang,
    required Function() onClick,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onClick,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (isUrl)
                ? MyNetworkImage(
                    width: 30,
                    height: 30,
                    imagePath: iconName,
                    fit: BoxFit.contain,
                  )
                : MyImage(
                    width: 30,
                    height: 30,
                    imagePath: "$iconName.png",
                    color: white,
                  ),
            const SizedBox(height: 10),
            MyText(
              color: white,
              text: title,
              multilanguage: isTitleMultilang,
              textalign: TextAlign.center,
              fontsizeNormal: 14,
              fontweight: FontWeight.w500,
              fontsizeWeb: 14,
              maxline: 2,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPages() {
    if (generalProvider.pagesModel.status == 200 &&
        generalProvider.pagesModel.result != null) {
      return AlignedGridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        itemCount: (generalProvider.pagesModel.result?.length ?? 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                constraints: const BoxConstraints(maxHeight: 110),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildFeatureBtn(
                        iconName:
                            generalProvider.pagesModel.result?[position].icon ??
                                '',
                        isUrl: true,
                        title: generalProvider
                                .pagesModel.result?[position].title ??
                            '',
                        isTitleMultilang: false,
                        onClick: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AboutPrivacyTerms(
                                appBarTitle: generalProvider
                                        .pagesModel.result?[position].title ??
                                    '',
                                loadURL: generalProvider
                                        .pagesModel.result?[position].url ??
                                    '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if ((position % 2) == 0) _buildLine(isVertical: true),
                  ],
                ),
              ),
              _buildLine(isVertical: false),
            ],
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _languageChangeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      elevation: 20,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, state) {
            return Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: white,
                  padding: const EdgeInsets.all(23),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              color: black,
                              text: "changelanguage",
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
                              color: otherColor,
                              text: "selectyourlanguage",
                              multilanguage: true,
                              textalign: TextAlign.start,
                              fontsizeNormal: 12,
                              fontweight: FontWeight.w500,
                              maxline: 1,
                              overflow: TextOverflow.ellipsis,
                              fontstyle: FontStyle.normal,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /* English */
                      _buildLanguageItem(
                        title: "English",
                        onClick: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('en');
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),

                      /* Arabic */
                      _buildLanguageItem(
                        title: "Arabic",
                        onClick: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('ar');
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),

                      /* Hindi */
                      _buildLanguageItem(
                        title: "Hindi",
                        onClick: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('hi');
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 20),

                      /* Chinese */
                      _buildLanguageItem(
                        title: "Chinese",
                        onClick: () {
                          state(() {});
                          LocaleNotifier.of(context)?.change('zh');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageItem({
    required String title,
    required Function() onClick,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: onClick,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        height: 48,
        padding: const EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorAccent,
            width: .5,
          ),
          color: transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: MyText(
          color: black,
          text: title,
          textalign: TextAlign.center,
          fontsizeNormal: 15,
          fontsizeWeb: 15,
          multilanguage: false,
          maxline: 1,
          overflow: TextOverflow.ellipsis,
          fontweight: FontWeight.w700,
          fontstyle: FontStyle.normal,
        ),
      ),
    );
  }
}
