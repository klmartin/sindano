import 'package:carousel_slider/carousel_slider.dart';
import 'package:SindanoShow/provider/homeprovider.dart';
import 'package:SindanoShow/provider/homesectionprovider.dart';
import 'package:SindanoShow/pages/viewall.dart';
import 'package:SindanoShow/shimmer/shimmerutils.dart';
import 'package:SindanoShow/utils/adhelper.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/utils/sharedpre.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mynetworkimg.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeSections extends StatefulWidget {
  final String categoryId;
  const HomeSections({required this.categoryId, super.key});

  @override
  State<HomeSections> createState() => _HomeSectionsState();
}

class _HomeSectionsState extends State<HomeSections> {
  SharedPre sharePref = SharedPre();
  late HomeProvider homeProvider;
  late HomeSectionProvider homeSectionProvider;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeSectionProvider =
        Provider.of<HomeSectionProvider>(context, listen: false);
    super.initState();
  }

  openDetailPage(String itemId, String categoryId) async {
    debugPrint("itemId ========> $itemId");
    debugPrint("categoryId ====> $categoryId");
    if (!mounted) return;
    Utils.openDetails(
      context: context,
      itemId: itemId,
      categoryId: categoryId,
    );
  }

  @override
  void dispose() {
    homeSectionProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(top: (Dimens.homeTabHeight + 10), bottom: 20),
              child: Column(
                children: [
                  _buildHomeBanner(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Utils.showBannerAd(context),
                  ),

                  /* Top News */
                  _buildTitleViewAll(
                    title: "topnews",
                    isMultiLang: true,
                    onViewAll: () {
                      AdHelper.showFullscreenAd(
                          context, Constant.interstialAdType, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewAll(
                              catId: widget.categoryId,
                              appBarTitle: 'topnews',
                              dataType: 'topnews',
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  _buildTopNews(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Utils.showBannerAd(context),
                  ),

                  /* Recent News */
                  _buildTitleViewAll(
                    title: "recent_news",
                    isMultiLang: true,
                    onViewAll: () {
                      AdHelper.showFullscreenAd(
                          context, Constant.interstialAdType, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewAll(
                              catId: widget.categoryId,
                              appBarTitle: 'recent_news',
                              dataType: 'recentnews',
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  _buildRecentNews(),
                ],
              ),
            ),
          ),
          Utils.showBannerAd(context),
        ],
      ),
    );
  }

  Widget _buildTitleViewAll({
    required String title,
    required bool isMultiLang,
    required Function() onViewAll,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: MyText(
              color: black,
              text: title,
              multilanguage: isMultiLang,
              textalign: TextAlign.start,
              fontsizeNormal: 14,
              fontweight: FontWeight.w700,
              fontsizeWeb: 14,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(2),
            onTap: onViewAll,
            child: Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: MyText(
                color: colorAccent,
                text: "viewall",
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
        ],
      ),
    );
  }

  Widget _buildHomeBanner() {
    return Consumer<HomeSectionProvider>(
      builder: (context, homeSectionProvider, child) {
        if (homeSectionProvider.loadingBanner) {
          return ShimmerUtils.bannerMobile(context);
        } else {
          if (homeSectionProvider.bannerModel.status == 200 &&
              homeSectionProvider.bannerModel.result != null) {
            if ((homeSectionProvider.bannerModel.result?.length ?? 0) > 0) {
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: Dimens.homeBanner,
                    child: CarouselSlider.builder(
                      itemCount:
                          (homeSectionProvider.bannerModel.result?.length ?? 0),
                      carouselController: carouselController,
                      options: CarouselOptions(
                        initialPage: 0,
                        height: Dimens.homeBanner,
                        enlargeCenterPage: false,
                        autoPlay: true,
                        autoPlayCurve: Curves.linear,
                        enableInfiniteScroll: true,
                        autoPlayInterval:
                            Duration(milliseconds: Constant.bannerDuration),
                        autoPlayAnimationDuration:
                            Duration(milliseconds: Constant.animationDuration),
                        viewportFraction: 1.0,
                        onPageChanged: (val, _) async {
                          await homeSectionProvider.setCurrentBanner(val);
                        },
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int pageViewIndex) {
                        return _buildBannerItem(index: index);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<HomeSectionProvider>(
                    builder: (context, homeSectionProvider, child) {
                      return AnimatedSmoothIndicator(
                        count:
                            (homeSectionProvider.bannerModel.result?.length ??
                                0),
                        activeIndex: homeSectionProvider.cBannerIndex ?? 0,
                        effect: const ScrollingDotsEffect(
                          spacing: 8,
                          radius: 4,
                          activeDotColor: dotsActiveColor,
                          dotColor: dotsDefaultColor,
                          dotHeight: 8,
                          dotWidth: 8,
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _buildBannerItem({required int index}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: Dimens.homeBanner,
      child: Card(
        elevation: 5,
        shadowColor: black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          focusColor: white,
          borderRadius: BorderRadius.circular(0),
          onTap: () {
            debugPrint("Clicked on index ==> $index");
            openDetailPage(
                homeSectionProvider.bannerModel.result?[index].id.toString() ??
                    "",
                homeSectionProvider.bannerModel.result?[index].categoryId
                        .toString() ??
                    "");
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      MyNetworkImage(
                        imagePath: homeSectionProvider
                                .bannerModel.result?[index].bannerImage ??
                            "",
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: Utils.setBackground(
                              (homeSectionProvider.bannerModel.result?[index]
                                          .isBookmark ==
                                      1)
                                  ? white
                                  : otherColor,
                              50),
                          child: InkWell(
                            onTap: () async {
                              if (Utils.checkLoginUser(context)) {
                                await homeSectionProvider.addBookmark(
                                    context,
                                    "banner",
                                    index,
                                    homeSectionProvider
                                            .bannerModel.result?[index].id
                                            .toString() ??
                                        "");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              child: MyImage(
                                fit: BoxFit.contain,
                                imagePath: (homeSectionProvider.bannerModel
                                            .result?[index].isBookmark ==
                                        1)
                                    ? "ic_bookmarkfill.png"
                                    : "ic_bookmark.png",
                                color: (homeSectionProvider.bannerModel
                                            .result?[index].isBookmark ==
                                        1)
                                    ? colorAccent
                                    : white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                child: MyText(
                  text: homeSectionProvider.bannerModel.result?[index].name
                          .toString() ??
                      "",
                  color: lightBlack,
                  fontsizeNormal: 14,
                  fontsizeWeb: 14,
                  fontweight: FontWeight.w500,
                  maxline: 2,
                  multilanguage: false,
                  textalign: TextAlign.start,
                  fontstyle: FontStyle.normal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: MyText(
                        text: homeSectionProvider
                                .bannerModel.result?[index].categoryName
                                .toString() ??
                            "",
                        color: colorPrimaryDark,
                        fontsizeNormal: 13,
                        fontsizeWeb: 13,
                        fontweight: FontWeight.w600,
                        maxline: 1,
                        multilanguage: false,
                        textalign: TextAlign.start,
                        fontstyle: FontStyle.normal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MyText(
                      text: (homeSectionProvider
                                      .bannerModel.result?[index].createdAt
                                      .toString() ??
                                  "")
                              .isNotEmpty
                          ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                              homeSectionProvider
                                      .bannerModel.result?[index].createdAt
                                      .toString() ??
                                  "")))
                          : "",
                      color: otherColor,
                      fontsizeNormal: 12,
                      fontsizeWeb: 12,
                      fontweight: FontWeight.w600,
                      maxline: 1,
                      multilanguage: false,
                      textalign: TextAlign.start,
                      fontstyle: FontStyle.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridImage({required String thumbnailImg}) {
    return Container(
      constraints: BoxConstraints(
        minHeight: Dimens.heightGridView,
        maxWidth: MediaQuery.of(context).size.width * 0.3,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MyNetworkImage(
          imagePath: thumbnailImg,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTopNews() {
    return Consumer<HomeSectionProvider>(
      builder: (context, homeSectionProvider, child) {
        if (homeSectionProvider.loadingSection) {
          return ShimmerUtils.buildGridShimmer(context, 3);
        } else {
          if (homeSectionProvider.topNewsModel.status == 200 &&
              homeSectionProvider.topNewsModel.result != null) {
            if ((homeSectionProvider.topNewsModel.result?.length ?? 0) > 0) {
              return AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    (homeSectionProvider.topNewsModel.result?.length ?? 0) >= 5
                        ? 5
                        : homeSectionProvider.topNewsModel.result?.length ?? 0,
                itemBuilder: (BuildContext context, int position) {
                  return Container(
                    constraints: BoxConstraints(
                      minHeight: Dimens.heightGridView,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      shadowColor: black.withOpacity(0.4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          debugPrint("Clicked on position ==> $position");
                          openDetailPage(
                              homeSectionProvider
                                      .topNewsModel.result?[position].id
                                      .toString() ??
                                  "",
                              homeSectionProvider
                                      .topNewsModel.result?[position].categoryId
                                      .toString() ??
                                  "");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildGridImage(
                              thumbnailImg: homeSectionProvider
                                      .topNewsModel.result?[position].image
                                      .toString() ??
                                  "",
                            ),
                            _buildTopNewsDetails(index: position),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _buildTopNewsDetails({required int index}) {
    return Flexible(
      child: Container(
        constraints: BoxConstraints(
          minHeight: Dimens.heightGridView,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: MyText(
                    text: homeSectionProvider
                            .topNewsModel.result?[index].categoryName
                            .toString() ??
                        "",
                    color: colorPrimaryDark,
                    fontsizeNormal: 13,
                    fontsizeWeb: 13,
                    fontweight: FontWeight.w600,
                    maxline: 1,
                    multilanguage: false,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                    onTap: () async {
                      if (Utils.checkLoginUser(context)) {
                        await homeSectionProvider.addBookmark(
                            context,
                            "topnews",
                            index,
                            homeSectionProvider.topNewsModel.result?[index].id
                                    .toString() ??
                                "");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: MyImage(
                        fit: BoxFit.contain,
                        imagePath: (homeSectionProvider
                                    .topNewsModel.result?[index].isBookmark ==
                                1)
                            ? "ic_bookmarkfill.png"
                            : "ic_bookmark.png",
                        color: (homeSectionProvider
                                    .topNewsModel.result?[index].isBookmark ==
                                1)
                            ? colorAccent
                            : otherColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyText(
                text: homeSectionProvider.topNewsModel.result?[index].name
                        .toString() ??
                    "",
                color: lightBlack,
                fontsizeNormal: 14,
                fontsizeWeb: 14,
                fontweight: FontWeight.w500,
                maxline: 2,
                multilanguage: false,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            MyText(
              text: ((homeSectionProvider.topNewsModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty)
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      homeSectionProvider.topNewsModel.result?[index].createdAt
                              .toString() ??
                          "")))
                  : "-",
              color: otherColor,
              fontsizeNormal: 12,
              fontsizeWeb: 12,
              fontweight: FontWeight.w600,
              maxline: 1,
              multilanguage: false,
              textalign: TextAlign.start,
              fontstyle: FontStyle.normal,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentNews() {
    return Consumer<HomeSectionProvider>(
      builder: (context, homeSectionProvider, child) {
        if (homeSectionProvider.loadingSection) {
          return ShimmerUtils.buildGridShimmer(context, 3);
        } else {
          return AlignedGridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                (homeSectionProvider.recentNewsModel.result?.length ?? 0) >= 5
                    ? 5
                    : homeSectionProvider.recentNewsModel.result?.length ?? 0,
            itemBuilder: (BuildContext context, int position) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: Dimens.heightGridView,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  shadowColor: black.withOpacity(0.4),
                  child: InkWell(
                    onTap: () {
                      debugPrint("Clicked on position ==> $position");
                      openDetailPage(
                          homeSectionProvider
                                  .recentNewsModel.result?[position].id
                                  .toString() ??
                              "",
                          homeSectionProvider
                                  .recentNewsModel.result?[position].categoryId
                                  .toString() ??
                              "");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildGridImage(
                          thumbnailImg: homeSectionProvider
                                  .recentNewsModel.result?[position].image
                                  .toString() ??
                              "",
                        ),
                        _buildRecentNewsDetails(index: position),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildRecentNewsDetails({required int index}) {
    return Flexible(
      child: Container(
        constraints: BoxConstraints(
          minHeight: Dimens.heightGridView,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: MyText(
                    text: homeSectionProvider
                            .recentNewsModel.result?[index].categoryName
                            .toString() ??
                        "",
                    color: colorPrimaryDark,
                    fontsizeNormal: 13,
                    fontsizeWeb: 13,
                    fontweight: FontWeight.w600,
                    maxline: 1,
                    multilanguage: false,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: GestureDetector(
                    onTap: () async {
                      if (Utils.checkLoginUser(context)) {
                        await homeSectionProvider.addBookmark(
                            context,
                            "recentnews",
                            index,
                            homeSectionProvider
                                    .recentNewsModel.result?[index].id
                                    .toString() ??
                                "");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: MyImage(
                        fit: BoxFit.contain,
                        imagePath: (homeSectionProvider.recentNewsModel
                                    .result?[index].isBookmark ==
                                1)
                            ? "ic_bookmarkfill.png"
                            : "ic_bookmark.png",
                        color: (homeSectionProvider.recentNewsModel
                                    .result?[index].isBookmark ==
                                1)
                            ? colorAccent
                            : otherColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyText(
                text: homeSectionProvider.recentNewsModel.result?[index].name
                        .toString() ??
                    "",
                color: lightBlack,
                fontsizeNormal: 14,
                fontsizeWeb: 14,
                fontweight: FontWeight.w500,
                maxline: 2,
                multilanguage: false,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            MyText(
              text: ((homeSectionProvider
                              .recentNewsModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty)
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      homeSectionProvider
                              .recentNewsModel.result?[index].createdAt
                              .toString() ??
                          "")))
                  : "-",
              color: otherColor,
              fontsizeNormal: 12,
              fontsizeWeb: 12,
              fontweight: FontWeight.w600,
              maxline: 1,
              multilanguage: false,
              textalign: TextAlign.start,
              fontstyle: FontStyle.normal,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
