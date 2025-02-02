
import 'package:Sindano/provider/newsdetailsprovider.dart';
import 'package:Sindano/pages/viewall.dart';
import 'package:Sindano/shimmer/shimmerutils.dart';
import 'package:Sindano/utils/adhelper.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/dimens.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mynetworkimg.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:Sindano/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsDetails extends StatefulWidget {
  final String itemId, categoryId;
  const NewsDetails({
    required this.itemId,
    required this.categoryId,
    Key? key,
  }) : super(key: key);

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  late NewsDetailsProvider newsDetailsProvider;

  @override
  void initState() {
    super.initState();
    debugPrint("itemId ======> ${widget.itemId}");
    debugPrint("categoryId ==> ${widget.categoryId}");
    newsDetailsProvider =
        Provider.of<NewsDetailsProvider>(context, listen: false);
    _getData();
  }

  _getData() async {
    await newsDetailsProvider.getArticleDetails(widget.itemId);
    await newsDetailsProvider.getRelatedNews(widget.categoryId);

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
    if (Constant.userID != null) {
      newsDetailsProvider.addArticleView(widget.itemId);
    }
  }

  openDetailPage(String itemId, String categoryId) async {
    debugPrint("itemId ========> $itemId");
    debugPrint("categoryId ====> $categoryId");
    AdHelper.showFullscreenAd(context, Constant.rewardAdType, () async {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NewsDetails(
              itemId: itemId,
              categoryId: categoryId,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    newsDetailsProvider.clearProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Consumer<NewsDetailsProvider>(
          builder: (context, newsDetailsProvider, child) {
            if (newsDetailsProvider.loading) {
              return ShimmerUtils.buildDetailMobileShimmer(context);
            } else {
              if (newsDetailsProvider.newsDetailsModel.status == 200 &&
                  newsDetailsProvider.newsDetailsModel.result != null) {
                return _buildPage();
              } else {
                return const NoData(title: '', subTitle: '');
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Stack(
      children: [
        _buildAppBarWithDetails(),
        Positioned(
          bottom: 0,
          left: 25,
          right: 25,
          child: _buildBottomBar(),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Card(
      elevation: 5,
      shadowColor: black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIcons(
              iconName: "ic_back",
              isSelected: true,
              isBookmark: false,
              onClick: () {
                Navigator.pop(context);
              },
            ),
            _buildIcons(
              iconName: "ic_share2",
              isSelected: false,
              isBookmark: false,
              onClick: () async {
                Utils.shareData(
                    context,
                    newsDetailsProvider.newsDetailsModel.result?[0].name
                            .toString() ??
                        "");
              },
            ),
            Consumer<NewsDetailsProvider>(
              builder: (context, newsDetailsProvider, child) {
                return _buildIcons(
                  iconName: (newsDetailsProvider
                              .newsDetailsModel.result?[0].isBookmark ==
                          1)
                      ? "ic_bookmarkfill"
                      : "ic_bookmark",
                  isSelected: false,
                  isBookmark: (newsDetailsProvider
                          .newsDetailsModel.result?[0].isBookmark ==
                      1),
                  onClick: () async {
                    await newsDetailsProvider.addBookmark(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcons({
    required String iconName,
    required bool isSelected,
    required bool isBookmark,
    required Function() onClick,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onClick,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isBookmark
              ? colorAccent
              : (isSelected ? colorPrimary : transparent),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(10),
        child: MyImage(
          fit: BoxFit.contain,
          imagePath: "$iconName.png",
          color: ((isSelected || isBookmark) ? white : grayDark),
        ),
      ),
    );
  }

  Widget _buildAppBarWithDetails() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              automaticallyImplyLeading: false,
              backgroundColor: appBgColor,
              toolbarHeight: 0,
              titleSpacing: 0,
              floating: false,
              pinned: true,
              collapsedHeight: 0.1,
              elevation: 0,
              flexibleSpace: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Dimens.detailPoster,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MyNetworkImage(
                      imagePath: newsDetailsProvider
                              .newsDetailsModel.result?[0].bannerImage ??
                          "",
                      fit: BoxFit.cover,
                    ),
                    if ((newsDetailsProvider
                                .newsDetailsModel.result?[0].articleType ??
                            0) ==
                        2)
                      Container(
                        height: 45,
                        width: 45,
                        decoration:
                            Utils.setBGWithBorder(colorAccent, white, 45, 2),
                        child: InkWell(
                          onTap: () {
                            _openPlayer();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(12),
                            child: MyImage(
                              imagePath: "ic_play2.png",
                              color: white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              expandedHeight: Dimens.detailPoster,
              forceElevated: innerBoxIsScrolled,
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Title */
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyText(
                text: newsDetailsProvider.newsDetailsModel.result?[0].name
                        .toString() ??
                    "",
                color: lightBlack,
                fontsizeNormal: 17,
                fontsizeWeb: 17,
                fontweight: FontWeight.w600,
                maxline: 5,
                multilanguage: false,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /* Category & Date */
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 28,
                    constraints: const BoxConstraints(minWidth: 0),
                    decoration: Utils.setBGWithBorder(
                        colorPrimaryDark, colorAccent, 8, 1),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: MyText(
                      text: newsDetailsProvider
                              .newsDetailsModel.result?[0].categoryName
                              .toString() ??
                          "",
                      color: white,
                      fontsizeNormal: 12,
                      fontsizeWeb: 12,
                      fontweight: FontWeight.w700,
                      maxline: 1,
                      multilanguage: false,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  MyText(
                    text: (newsDetailsProvider
                                    .newsDetailsModel.result?[0].createdAt
                                    .toString() ??
                                "")
                            .isNotEmpty
                        ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                            newsDetailsProvider
                                    .newsDetailsModel.result?[0].createdAt
                                    .toString() ??
                                "")))
                        : "-",
                    color: otherColor,
                    fontsizeNormal: 13,
                    fontsizeWeb: 13,
                    fontweight: FontWeight.w500,
                    maxline: 1,
                    multilanguage: false,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildLine(),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Utils.showBannerAd(context),
            ),

            /* Details */
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Utils.htmlNewsDesc(
                  newsDetailsProvider.newsDetailsModel.result?[0].description ??
                      ""),
            ),
            const SizedBox(height: 20),

            /* Related News */
            _buildRelatedNews(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      height: 0.2,
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
      decoration: Utils.setBackground(otherColor, 2),
    );
  }

  /* Related News START */
  Widget _buildTitleViewAll({
    required String title,
    required bool isMultiLang,
    required bool isViewAll,
    required Function() onViewAll,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
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
          if (isViewAll)
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

  Widget _buildRelatedNews() {
    if (newsDetailsProvider.loadingRelated) {
      return ShimmerUtils.buildGridShimmer(context, 5);
    } else {
      if (newsDetailsProvider.relatedNewsModel.status == 200 &&
          newsDetailsProvider.relatedNewsModel.result != null) {
        if ((newsDetailsProvider.relatedNewsModel.result?.length ?? 0) > 0) {
          return Column(
            children: [
              /* title */
              _buildTitleViewAll(
                title: "relatednews",
                isMultiLang: true,
                isViewAll:
                    (newsDetailsProvider.relatedNewsModel.result?.length ?? 0) >
                        4,
                onViewAll: () {
                  AdHelper.showFullscreenAd(context, Constant.rewardAdType,
                      () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAll(
                          catId: widget.categoryId,
                          appBarTitle: 'relatednews',
                          dataType: 'relatednews',
                        ),
                      ),
                    );
                    _getData();
                  });
                },
              ),
              /* Data */
              AlignedGridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 10,
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (newsDetailsProvider
                                .relatedNewsModel.result?.length ??
                            0) >=
                        5
                    ? 5
                    : newsDetailsProvider.relatedNewsModel.result?.length ?? 0,
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
                              newsDetailsProvider
                                      .relatedNewsModel.result?[position].id
                                      .toString() ??
                                  "",
                              newsDetailsProvider.relatedNewsModel
                                      .result?[position].categoryId
                                      .toString() ??
                                  "");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildGridImage(
                              thumbnailImg: newsDetailsProvider
                                      .relatedNewsModel.result?[position].image
                                      .toString() ??
                                  "",
                            ),
                            _buildRelatedNewsDetails(index: position),
                          ],
                        ),
                      ),
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

  Widget _buildRelatedNewsDetails({required int index}) {
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
              children: [
                MyText(
                  text: newsDetailsProvider
                          .relatedNewsModel.result?[index].categoryName
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
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyText(
                text: newsDetailsProvider.relatedNewsModel.result?[index].name
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
              text: (newsDetailsProvider
                              .relatedNewsModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      newsDetailsProvider
                              .relatedNewsModel.result?[index].createdAt
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
  /* Related News END */

  /* Open Player START */
  _openPlayer() {
    if (Utils.checkLoginUser(context)) {
      if (newsDetailsProvider.newsDetailsModel.result?[0].isPaid.toString() ==
              "1" &&
          newsDetailsProvider.newsDetailsModel.result?[0].isBuy.toString() ==
              "0") {
        Utils.openSubscription(context: context);
      } else {
        AdHelper.showFullscreenAd(context, Constant.rewardAdType, () async {
          if (!mounted) return;
          Utils.openPlayer(
            context: context,
            videoId:
                newsDetailsProvider.newsDetailsModel.result?[0].id.toString() ??
                    "",
            videoUrl: newsDetailsProvider.newsDetailsModel.result?[0].url
                    .toString() ??
                "",
            vUploadType: newsDetailsProvider
                    .newsDetailsModel.result?[0].videoType
                    .toString() ??
                "",
            videoThumb: newsDetailsProvider.newsDetailsModel.result?[0].image
                    .toString() ??
                "",
          );
        });
      }
    }
  }
  /* Open Player END */
}
