import 'dart:async';

import 'package:SindanoShow/model/subscriptionmodel.dart';
import 'package:SindanoShow/subscription/allpayment.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/widget/nodata.dart';
import 'package:SindanoShow/provider/subscriptionprovider.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class Subscription extends StatefulWidget {
  const Subscription({
    Key? key,
  }) : super(key: key);

  @override
  State<Subscription> createState() => SubscriptionState();
}

class SubscriptionState extends State<Subscription> {
  late SubscriptionProvider subscriptionProvider;

  @override
  void initState() {
    subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    super.initState();
    _getData();
  }

  _getData() async {
    Utils.getCurrencySymbol();
    await subscriptionProvider.getPackages();
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscriptionProvider.clearProvider();
    super.dispose();
  }

  _checkAndPay(List<Result>? packageList, int index) async {
    if (Utils.checkLoginUser(context)) {
      for (var i = 0; i < (packageList?.length ?? 0); i++) {
        if (packageList?[i].isBuy == 1) {
          debugPrint("<============= Purchaged =============>");
          Utils.showSnackbar(context, "info", "already_purchased", true);
          return;
        }
      }
      if (packageList?[index].isBuy == 0) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AllPayment(
                payType: 'Package',
                itemId: packageList?[index].id.toString() ?? '',
                price: packageList?[index].price.toString() ?? '',
                itemTitle: packageList?[index].name.toString() ?? '',
                productPackage:
                    packageList?[index].androidProductPackage.toString() ?? '',
                currency: packageList?[index].currencyType.toString() ?? '',
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: appBgColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildSubscription(),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: appBgColor,
        appBar: Utils.myAppBarWithBack(context, "subsciption", true),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: _buildSubscription(),
              ),
              /* Choose Plan */
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    debugPrint(
                        "purchasePos =========> ${subscriptionProvider.purchasePos}");
                    debugPrint(
                        "cPlanPosition =======> ${subscriptionProvider.cPlanPosition}");
                    if (subscriptionProvider.purchasePos != -1) {
                      Utils.showSnackbar(
                          context, "info", "already_purchased", true);
                      return;
                    }
                    if (subscriptionProvider.cPlanPosition == -1) {
                      Utils.showSnackbar(
                          context, "info", "select_sub_plan", true);
                      return;
                    }
                    _checkAndPay(subscriptionProvider.subscriptionModel.result,
                        subscriptionProvider.cPlanPosition);
                  },
                  child: Consumer<SubscriptionProvider>(
                    builder: (context, subscriptionProvider, child) {
                      return Container(
                        height: 45,
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: Utils.setBackground(
                            (subscriptionProvider.purchasePos == -1)
                                ? ((subscriptionProvider.cPlanPosition != -1)
                                    ? colorAccent
                                    : subscriptionBG)
                                : colorAccent,
                            6),
                        alignment: Alignment.center,
                        child: MyText(
                          color: (subscriptionProvider.purchasePos == -1)
                              ? ((subscriptionProvider.cPlanPosition != -1)
                                  ? white
                                  : gray)
                              : white,
                          text: (subscriptionProvider.purchasePos == -1)
                              ? ((subscriptionProvider.cPlanPosition != -1)
                                  ? "continue"
                                  : "chooseplan")
                              : "purchased",
                          textalign: TextAlign.center,
                          fontsizeNormal: 15,
                          fontsizeWeb: 16,
                          fontweight: FontWeight.w700,
                          multilanguage: true,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSubscription() {
    if (subscriptionProvider.loading) {
      return Center(child: Utils.pageLoader());
    } else {
      if (subscriptionProvider.subscriptionModel.status == 200) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: ((kIsWeb) && MediaQuery.of(context).size.width > 720)
                      ? 60
                      : 20),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: ((kIsWeb) && MediaQuery.of(context).size.width > 720)
                        ? 60
                        : 20,
                    right: ((kIsWeb) && MediaQuery.of(context).size.width > 720)
                        ? 60
                        : 20),
                alignment: Alignment.center,
                child: MyText(
                  color: otherColor,
                  text: "subsciptionnotes",
                  multilanguage: true,
                  textalign: TextAlign.center,
                  fontsizeNormal: 16,
                  fontsizeWeb: 16,
                  maxline: 2,
                  fontweight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
              SizedBox(
                  height: ((kIsWeb) && MediaQuery.of(context).size.width > 720)
                      ? 60
                      : 20),

              /* Remaining Data */
              _buildItems(subscriptionProvider.subscriptionModel.result),
              SizedBox(
                  height: ((kIsWeb) && MediaQuery.of(context).size.width > 720)
                      ? 60
                      : 20),
            ],
          ),
        );
      } else {
        return const NoData(title: '', subTitle: '');
      }
    }
  }

  Widget _buildItems(List<Result>? packageList) {
    if ((kIsWeb) && MediaQuery.of(context).size.width > 800) {
      return buildWebItem(packageList);
    } else {
      return buildMobileItem(packageList);
    }
  }

  Widget buildMobileItem(List<Result>? packageList) {
    if (packageList != null) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ResponsiveGridList(
          minItemWidth: MediaQuery.of(context).size.width,
          verticalGridSpacing: 15,
          horizontalGridSpacing: 6,
          minItemsPerRow: 1,
          maxItemsPerRow: 3,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          children: List.generate(
            (packageList.length),
            (index) {
              return Consumer<SubscriptionProvider>(
                builder: (context, subscriptionProvider, child) {
                  return Container(
                    decoration: Utils.setBGWithBorder(
                        (subscriptionProvider.purchasePos == -1)
                            ? ((subscriptionProvider.cPlanPosition == index)
                                ? colorPrimaryDark
                                : subscriptionBG)
                            : ((subscriptionProvider.purchasePos == index)
                                ? colorPrimaryDark
                                : subscriptionBG),
                        (subscriptionProvider.purchasePos == -1)
                            ? ((subscriptionProvider.cPlanPosition == index)
                                ? colorPrimary
                                : colorPrimary.withOpacity(0.3))
                            : ((subscriptionProvider.purchasePos == index)
                                ? colorPrimary
                                : colorPrimary.withOpacity(0.3)),
                        6,
                        1),
                    child: InkWell(
                      onTap: () async {
                        debugPrint("Clicked on index =======> $index");
                        if (subscriptionProvider.purchasePos == -1) {
                          await subscriptionProvider.setCurrentPlan(index);
                        } else {
                          Utils.showSnackbar(
                              context, "info", "already_purchased", true);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    color: white,
                                    text: packageList[index].name ?? "",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 20,
                                    fontsizeWeb: 20,
                                    maxline: 1,
                                    multilanguage: false,
                                    overflow: TextOverflow.ellipsis,
                                    fontweight: FontWeight.w700,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(height: 8),
                                  MyText(
                                    color: whiteLight,
                                    text:
                                        "${Constant.currencySymbol}${packageList[index].price.toString()} / ${packageList[index].time.toString()} ${packageList[index].type.toString()}",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 14,
                                    fontsizeWeb: 14,
                                    maxline: 1,
                                    multilanguage: false,
                                    overflow: TextOverflow.ellipsis,
                                    fontweight: FontWeight.w700,
                                    fontstyle: FontStyle.normal,
                                  ),
                                ],
                              ),
                            ),

                            /* Tick Mark */
                            Container(
                              height: 24,
                              width: 24,
                              decoration: Utils.setBackground(
                                  (subscriptionProvider.purchasePos == -1)
                                      ? (subscriptionProvider.cPlanPosition ==
                                              index
                                          ? colorAccent
                                          : otherColor)
                                      : ((subscriptionProvider.purchasePos ==
                                              index)
                                          ? colorAccent
                                          : otherColor),
                                  20),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              child: MyImage(
                                imagePath: "ic_tick.png",
                                height: 12,
                                width: 12,
                                color: white,
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildWebItem(List<Result>? packageList) {
    if (packageList != null) {
      return Container(
        padding: EdgeInsets.only(
            left:
                ((kIsWeb) && MediaQuery.of(context).size.width > 720) ? 60 : 30,
            right:
                ((kIsWeb) && MediaQuery.of(context).size.width > 720) ? 60 : 30,
            bottom: ((kIsWeb) && MediaQuery.of(context).size.width > 720)
                ? 30
                : 15),
        width: (MediaQuery.of(context).size.width > 720)
            ? (MediaQuery.of(context).size.width * 0.5)
            : (MediaQuery.of(context).size.width),
        child: ResponsiveGridList(
          minItemWidth: (MediaQuery.of(context).size.width > 720)
              ? Dimens.widthPackageWeb
              : Dimens.widthPackage,
          verticalGridSpacing: 20,
          horizontalGridSpacing: 20,
          minItemsPerRow: 1,
          maxItemsPerRow: 1,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          children: List.generate(
            (packageList.length),
            (index) {
              return Consumer<SubscriptionProvider>(
                builder: (context, subscriptionProvider, child) {
                  return Container(
                    decoration: Utils.setBGWithBorder(
                        (subscriptionProvider.purchasePos == -1)
                            ? ((subscriptionProvider.cPlanPosition == index)
                                ? colorPrimaryDark
                                : subscriptionBG)
                            : ((subscriptionProvider.purchasePos == index)
                                ? colorPrimaryDark
                                : subscriptionBG),
                        (subscriptionProvider.purchasePos == -1)
                            ? ((subscriptionProvider.cPlanPosition == index)
                                ? colorPrimary
                                : colorPrimary.withOpacity(0.3))
                            : ((subscriptionProvider.purchasePos == index)
                                ? colorPrimary
                                : colorPrimary.withOpacity(0.3)),
                        6,
                        1),
                    child: InkWell(
                      onTap: () async {
                        debugPrint("Clicked on index =======> $index");
                        if (subscriptionProvider.purchasePos == -1) {
                          _checkAndPay(
                              subscriptionProvider.subscriptionModel.result,
                              index);
                        } else {
                          Utils.showSnackbar(
                              context, "info", "already_purchased", true);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    color: white,
                                    text: packageList[index].name ?? "",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 20,
                                    fontsizeWeb: 20,
                                    maxline: 1,
                                    multilanguage: false,
                                    overflow: TextOverflow.ellipsis,
                                    fontweight: FontWeight.w700,
                                    fontstyle: FontStyle.normal,
                                  ),
                                  const SizedBox(height: 8),
                                  MyText(
                                    color: whiteLight,
                                    text:
                                        "${Constant.currencySymbol}${packageList[index].price.toString()} / ${packageList[index].time.toString()} ${packageList[index].type.toString()}",
                                    textalign: TextAlign.start,
                                    fontsizeNormal: 14,
                                    fontsizeWeb: 14,
                                    maxline: 1,
                                    multilanguage: false,
                                    overflow: TextOverflow.ellipsis,
                                    fontweight: FontWeight.w700,
                                    fontstyle: FontStyle.normal,
                                  ),
                                ],
                              ),
                            ),
                            /* Tick Mark */
                            Container(
                              height: 24,
                              width: 24,
                              decoration: Utils.setBackground(
                                  (subscriptionProvider.purchasePos == -1)
                                      ? (subscriptionProvider.cPlanPosition ==
                                              index
                                          ? colorAccent
                                          : otherColor)
                                      : ((subscriptionProvider.purchasePos ==
                                              index)
                                          ? colorAccent
                                          : otherColor),
                                  20),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              child: MyImage(
                                imagePath: "ic_tick.png",
                                height: 12,
                                width: 12,
                                color: (subscriptionProvider.purchasePos == -1)
                                    ? (subscriptionProvider.cPlanPosition ==
                                            index
                                        ? colorPrimaryDark
                                        : white)
                                    : ((subscriptionProvider.purchasePos ==
                                            index)
                                        ? colorPrimaryDark
                                        : white),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
