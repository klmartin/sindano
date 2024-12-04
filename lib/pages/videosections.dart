import 'package:carousel_slider/carousel_slider.dart';
import 'package:SindanoShow/provider/videoprovider.dart';
import 'package:SindanoShow/shimmer/shimmerutils.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/utils/sharedpre.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mynetworkimg.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VideoSections extends StatefulWidget {
  final String categoryId;
  const VideoSections({required this.categoryId, super.key});

  @override
  State<VideoSections> createState() => _VideoSectionsState();
}

class _VideoSectionsState extends State<VideoSections> {
  SharedPre sharePref = SharedPre();
  late VideoProvider videoProvider;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
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
    videoProvider.clearProvider();
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
                  _buildVideoBanner(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Utils.showBannerAd(context),
                  ),
                  _buildNews(),
                ],
              ),
            ),
          ),
          Utils.showBannerAd(context),
        ],
      ),
    );
  }

  Widget _buildVideoBanner() {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        if (videoProvider.loadingBanner) {
          return ShimmerUtils.bannerMobile(context);
        } else {
          if (videoProvider.bannerModel.status == 200 &&
              videoProvider.bannerModel.result != null) {
            if ((videoProvider.bannerModel.result?.length ?? 0) > 0) {
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: Dimens.homeBanner,
                    child: CarouselSlider.builder(
                      itemCount:
                          (videoProvider.bannerModel.result?.length ?? 0),
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
                          await videoProvider.setCurrentBanner(val);
                        },
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int pageViewIndex) {
                        return _buildBannerItem(index: index);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<VideoProvider>(
                    builder: (context, videoProvider, child) {
                      return AnimatedSmoothIndicator(
                        count: (videoProvider.bannerModel.result?.length ?? 0),
                        activeIndex: videoProvider.cBannerIndex ?? 0,
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
                videoProvider.bannerModel.result?[index].id.toString() ?? "",
                videoProvider.bannerModel.result?[index].categoryId
                        .toString() ??
                    "");
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      MyNetworkImage(
                        imagePath: videoProvider
                                .bannerModel.result?[index].bannerImage ??
                            "",
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                      Container(
                        decoration:
                            Utils.setBGWithBorder(transparent, white, 30, 2.0),
                        padding: const EdgeInsets.all(8),
                        child: MyImage(
                          height: 20,
                          width: 20,
                          imagePath: "ic_play2.png",
                          fit: BoxFit.cover,
                          color: white,
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: Utils.setBackground(
                              (videoProvider.bannerModel.result?[index]
                                          .isBookmark ==
                                      1)
                                  ? white
                                  : otherColor,
                              50),
                          child: InkWell(
                            onTap: () async {
                              if (Utils.checkLoginUser(context)) {
                                await videoProvider.addBookmark(
                                    context,
                                    "banner",
                                    index,
                                    videoProvider.bannerModel.result?[index].id
                                            .toString() ??
                                        "");
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              child: MyImage(
                                fit: BoxFit.contain,
                                imagePath: (videoProvider.bannerModel
                                            .result?[index].isBookmark ==
                                        1)
                                    ? "ic_bookmarkfill.png"
                                    : "ic_bookmark.png",
                                color: (videoProvider.bannerModel.result?[index]
                                            .isBookmark ==
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
                  text: videoProvider.bannerModel.result?[index].name
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
                        text: videoProvider
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
                      text: (videoProvider.bannerModel.result?[index].createdAt
                                      .toString() ??
                                  "")
                              .isNotEmpty
                          ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                              videoProvider.bannerModel.result?[index].createdAt
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            MyNetworkImage(
              height: Dimens.heightGridView,
              width: MediaQuery.of(context).size.width,
              imagePath: thumbnailImg,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: Utils.setBGWithBorder(transparent, white, 30, 2.0),
              padding: const EdgeInsets.all(8),
              child: MyImage(
                height: 20,
                width: 20,
                imagePath: "ic_play2.png",
                fit: BoxFit.cover,
                color: white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNews() {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        if (videoProvider.loadingSection) {
          return ShimmerUtils.buildGridShimmer(context, 3);
        } else {
          if (videoProvider.newsModel.status == 200 &&
              videoProvider.newsModel.result != null) {
            if ((videoProvider.newsModel.result?.length ?? 0) > 0) {
              return AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: videoProvider.newsModel.result?.length ?? 0,
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
                              videoProvider.newsModel.result?[position].id
                                      .toString() ??
                                  "",
                              videoProvider
                                      .newsModel.result?[position].categoryId
                                      .toString() ??
                                  "");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildGridImage(
                              thumbnailImg: videoProvider
                                      .newsModel.result?[position].image
                                      .toString() ??
                                  "",
                            ),
                            _buildNewsDetails(index: position),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const NoData(title: '', subTitle: '');
            }
          } else {
            return const NoData(title: '', subTitle: '');
          }
        }
      },
    );
  }

  Widget _buildNewsDetails({required int index}) {
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
                    text: videoProvider.newsModel.result?[index].categoryName
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
                        await videoProvider.addBookmark(
                            context,
                            "videonews",
                            index,
                            videoProvider.newsModel.result?[index].id
                                    .toString() ??
                                "");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: MyImage(
                        fit: BoxFit.contain,
                        imagePath: (videoProvider
                                    .newsModel.result?[index].isBookmark ==
                                1)
                            ? "ic_bookmarkfill.png"
                            : "ic_bookmark.png",
                        color: (videoProvider
                                    .newsModel.result?[index].isBookmark ==
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
                text: videoProvider.newsModel.result?[index].name.toString() ??
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
              text: (videoProvider.newsModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      videoProvider.newsModel.result?[index].createdAt
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
