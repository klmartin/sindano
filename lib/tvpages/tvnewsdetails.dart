import 'package:Sindano/provider/newsdetailsprovider.dart';
import 'package:Sindano/shimmer/shimmerutils.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/dimens.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/webwidget/footerweb.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mynetworkimg.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class TvNewsDetails extends StatefulWidget {
  final String itemId, categoryId;
  const TvNewsDetails(
      {required this.itemId, required this.categoryId, super.key});

  @override
  State<TvNewsDetails> createState() => _TvNewsDetailsState();
}

class _TvNewsDetailsState extends State<TvNewsDetails> {
  late NewsDetailsProvider newsDetailsProvider;
  final ScrollController _mainScrollController = ScrollController();

  void _scrollUp() {
    _mainScrollController.animateTo(
      _mainScrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _scrollDown() {
    _mainScrollController.animateTo(
      _mainScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  _scrollListener() {
    if (_mainScrollController.offset >=
            _mainScrollController.position.maxScrollExtent &&
        !_mainScrollController.position.outOfRange) {
      setState(() {});
    }
    if (_mainScrollController.offset <=
            _mainScrollController.position.minScrollExtent &&
        !_mainScrollController.position.outOfRange) {
      setState(() {});
    }
  }

  openDetailPage(String itemId, String categoryId) async {
    debugPrint("itemId ==========> $itemId");
    debugPrint("categoryId ======> $categoryId");
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TvNewsDetails(itemId: itemId, categoryId: categoryId),
      ),
    );
  }

  @override
  void initState() {
    _mainScrollController.addListener(_scrollListener);
    super.initState();
    newsDetailsProvider =
        Provider.of<NewsDetailsProvider>(context, listen: false);
    _getData();
  }

  _getData() async {
    await newsDetailsProvider.getArticleDetails(widget.itemId);
    await newsDetailsProvider.getRelatedNews(widget.categoryId);
    await newsDetailsProvider.getVideoNews(widget.categoryId);
    await newsDetailsProvider.getLastWeekNews(widget.categoryId);

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
    if (Constant.userID != null) {
      newsDetailsProvider.addArticleView(widget.itemId);
    }
  }

  @override
  void dispose() {
    newsDetailsProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: colorAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onPressed: () {
          debugPrint("Offset =========> ${_mainScrollController.offset}");
          if (_mainScrollController.offset <=
                  _mainScrollController.position.minScrollExtent &&
              !_mainScrollController.position.outOfRange) {
            _scrollDown();
          } else {
            _scrollUp();
          }
        },
        child: (_mainScrollController.hasClients &&
                (_mainScrollController.offset >=
                        _mainScrollController.position.maxScrollExtent &&
                    !_mainScrollController.position.outOfRange))
            ? (const Icon(Icons.arrow_upward_rounded))
            : (const Icon(Icons.arrow_downward_rounded)),
      ),
      body: SingleChildScrollView(
        controller: _mainScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
                  25,
                  (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
                  25),
              child: _buildRespPage(),
            ),

            /* Web Footer */
            const SizedBox(height: 20),
            kIsWeb ? const FooterWeb() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildRespPage() {
    if (newsDetailsProvider.loading) {
      return ShimmerUtils.buildDetailWebShimmer(context);
    } else {
      if ((kIsWeb || Constant.isTV) &&
          MediaQuery.of(context).size.width > 1200) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Details & Recent News */
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildDetails(),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: 1,
                  child: _buildRecents(),
                ),
              ],
            ),
            const SizedBox(height: 60),

            /* Last Week & Latest Video News */
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildLastWeekNews(),
                ),
                const SizedBox(width: 30),
                Expanded(
                  flex: 1,
                  child: _buildVideoNews(),
                ),
              ],
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Details & Recent News */
            _buildDetails(),
            const SizedBox(height: 30),
            _buildRecents(),
            const SizedBox(height: 60),

            /* Last Week & Latest Video News */
            _buildLastWeekNews(),
            const SizedBox(height: 30),
            _buildVideoNews(),
          ],
        );
      }
    }
  }

  Widget _buildDetails() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: MyText(
            color: black,
            text: newsDetailsProvider.newsDetailsModel.result?[0].name ?? "",
            fontsizeNormal: 26,
            fontsizeWeb: 26,
            fontstyle: FontStyle.normal,
            fontweight: FontWeight.w600,
            letterSpacing: 0.1,
            maxline: 3,
            multilanguage: false,
            textalign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImage(
              height: 18,
              width: 18,
              imagePath: "ic_calendar.png",
              color: grayDark,
            ),
            const SizedBox(width: 10),
            MyText(
              color: grayDark,
              text: (newsDetailsProvider.newsDetailsModel.result?[0].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      newsDetailsProvider.newsDetailsModel.result?[0].createdAt
                              .toString() ??
                          "")))
                  : "-",
              textalign: TextAlign.start,
              fontsizeNormal: 13,
              fontsizeWeb: 13,
              fontweight: FontWeight.w400,
              multilanguage: false,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              fontstyle: FontStyle.normal,
            ),
            Expanded(
              child: MyText(
                color: colorAccent,
                text: newsDetailsProvider
                        .newsDetailsModel.result?[0].categoryName ??
                    "",
                textalign: TextAlign.end,
                fontsizeNormal: 13,
                fontsizeWeb: 13,
                fontweight: FontWeight.w400,
                multilanguage: false,
                maxline: 1,
                overflow: TextOverflow.ellipsis,
                fontstyle: FontStyle.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 520,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: MyNetworkImage(
                    imagePath: newsDetailsProvider
                            .newsDetailsModel.result?[0].bannerImage ??
                        "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if ((newsDetailsProvider
                          .newsDetailsModel.result?[0].articleType ??
                      0) ==
                  2)
                Container(
                  height: 45,
                  width: 45,
                  decoration: Utils.setBGWithBorder(colorAccent, white, 45, 2),
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
        const SizedBox(height: 25),
        /* Details */
        MyText(
          color: edtBG,
          text:
              newsDetailsProvider.newsDetailsModel.result?[0].description ?? "",
          fontsizeNormal: 15,
          fontsizeWeb: 15,
          fontstyle: FontStyle.normal,
          fontweight: FontWeight.w400,
          letterSpacing: 0.1,
          maxline: 5000,
          multilanguage: false,
          textalign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRecents() {
    if (newsDetailsProvider.relatedNewsModel.status == 200 &&
        newsDetailsProvider.relatedNewsModel.result != null) {
      if ((newsDetailsProvider.relatedNewsModel.result?.length ?? 0) > 0) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width > 1200)
              ? (MediaQuery.of(context).size.width * 0.25)
              : (MediaQuery.of(context).size.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                child: Container(
                  height: 50,
                  decoration: Utils.setBackground(colorAccent, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: MyText(
                    color: white,
                    multilanguage: false,
                    text: "RELATED NEWS",
                    fontsizeNormal: 14,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 14,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: Utils.setBGWithBorder(
                    transparent, otherColor.withOpacity(0.3), 0, 2.0),
                padding: const EdgeInsets.all(20),
                child: ResponsiveGridList(
                  minItemWidth: (MediaQuery.of(context).size.width > 1200)
                      ? (MediaQuery.of(context).size.width * 0.3)
                      : (MediaQuery.of(context).size.width),
                  verticalGridSpacing: 20,
                  horizontalGridSpacing: 20,
                  minItemsPerRow: 1,
                  maxItemsPerRow: 1,
                  listViewBuilderOptions: ListViewBuilderOptions(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  children: List.generate(
                    ((newsDetailsProvider.relatedNewsModel.result?.length ??
                                0) >=
                            6
                        ? 6
                        : newsDetailsProvider.relatedNewsModel.result?.length ??
                            0),
                    (position) {
                      return Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          focusColor: white,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyText(
                                color: colorAccent,
                                text: newsDetailsProvider.relatedNewsModel
                                        .result?[position].categoryName ??
                                    "",
                                textalign: TextAlign.start,
                                fontsizeNormal: 15,
                                fontsizeWeb: 15,
                                fontweight: FontWeight.w600,
                                multilanguage: false,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                              const SizedBox(height: 20),
                              MyText(
                                color: black,
                                text: newsDetailsProvider.relatedNewsModel
                                        .result?[position].name ??
                                    "",
                                textalign: TextAlign.start,
                                fontsizeNormal: 15,
                                fontsizeWeb: 15,
                                fontweight: FontWeight.w600,
                                multilanguage: false,
                                maxline: 3,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                              const SizedBox(height: 15),
                              MyText(
                                color: edtBG,
                                text: newsDetailsProvider.relatedNewsModel
                                        .result?[position].description ??
                                    "",
                                textalign: TextAlign.start,
                                fontsizeNormal: 14,
                                fontsizeWeb: 14,
                                fontweight: FontWeight.w400,
                                multilanguage: false,
                                maxline: 2,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                              const SizedBox(height: 20),
                              Divider(
                                  height: 0.5,
                                  color: otherColor.withOpacity(0.3)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  /* Last Week News START */
  Widget _buildLastWeekNews() {
    if (newsDetailsProvider.lastWeekNewsModel.status == 200 &&
        newsDetailsProvider.lastWeekNewsModel.result != null) {
      if ((newsDetailsProvider.lastWeekNewsModel.result?.length ?? 0) > 0) {
        if ((kIsWeb || Constant.isTV) &&
            MediaQuery.of(context).size.width > 1200) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Container(
                  height: 50,
                  decoration: Utils.setBackground(colorAccent, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: MyText(
                    color: white,
                    multilanguage: false,
                    text: "LAST WEEK NEWS",
                    fontsizeNormal: 14,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 14,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildLastWeek(),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Container(
                  height: 50,
                  decoration: Utils.setBackground(colorAccent, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: MyText(
                    color: white,
                    multilanguage: false,
                    text: "LAST WEEK NEWS",
                    fontsizeNormal: 14,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 14,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildLastWeek(),
            ],
          );
        }
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildLastWeek() {
    return ResponsiveGridList(
      minItemWidth: (MediaQuery.of(context).size.width * 0.5),
      verticalGridSpacing: 30,
      horizontalGridSpacing: 30,
      minItemsPerRow: 1,
      maxItemsPerRow: 1,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        ((newsDetailsProvider.lastWeekNewsModel.result?.length ?? 0) >= 8
            ? 8
            : newsDetailsProvider.lastWeekNewsModel.result?.length ?? 0),
        (position) {
          return Container(
            decoration: Utils.setBGWithBorder(
                transparent, otherColor.withOpacity(0.3), 0, 2.0),
            padding: const EdgeInsets.all(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              focusColor: white,
              onTap: () {
                debugPrint("Clicked on position ==> $position");
                openDetailPage(
                    newsDetailsProvider.lastWeekNewsModel.result?[position].id
                            .toString() ??
                        "",
                    newsDetailsProvider
                            .lastWeekNewsModel.result?[position].categoryId
                            .toString() ??
                        "");
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: MyNetworkImage(
                      imagePath: newsDetailsProvider.lastWeekNewsModel
                              .result?[position].bannerImage ??
                          "",
                      fit: BoxFit.cover,
                      height: 140,
                      width: 140,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyText(
                          color: colorAccent,
                          text: newsDetailsProvider.lastWeekNewsModel
                                  .result?[position].categoryName ??
                              "",
                          textalign: TextAlign.start,
                          fontsizeNormal: 15,
                          fontsizeWeb: 15,
                          fontweight: FontWeight.w600,
                          multilanguage: false,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(height: 20),
                        MyText(
                          color: black,
                          text: newsDetailsProvider
                                  .lastWeekNewsModel.result?[position].name ??
                              "",
                          textalign: TextAlign.start,
                          fontsizeNormal: 15,
                          fontsizeWeb: 15,
                          fontweight: FontWeight.w600,
                          multilanguage: false,
                          maxline: 3,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                        const SizedBox(height: 15),
                        MyText(
                          color: edtBG,
                          text: newsDetailsProvider.lastWeekNewsModel
                                  .result?[position].description ??
                              "",
                          textalign: TextAlign.start,
                          fontsizeNormal: 14,
                          fontsizeWeb: 14,
                          fontweight: FontWeight.w400,
                          multilanguage: false,
                          maxline: 2,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  /* Last Week News END */

  /* Video News START */
  Widget _buildVideoNews() {
    if (newsDetailsProvider.videoNewsModel.status == 200 &&
        newsDetailsProvider.videoNewsModel.result != null) {
      if ((newsDetailsProvider.videoNewsModel.result?.length ?? 0) > 0) {
        if ((kIsWeb || Constant.isTV) &&
            MediaQuery.of(context).size.width > 1200) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Container(
                  height: 50,
                  decoration: Utils.setBackground(colorAccent, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: MyText(
                    color: white,
                    multilanguage: false,
                    text: "LATEST VIDEO",
                    fontsizeNormal: 14,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 14,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildVideos(),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Container(
                  height: 50,
                  decoration: Utils.setBackground(colorAccent, 0),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: MyText(
                    color: white,
                    multilanguage: false,
                    text: "LATEST VIDEO",
                    fontsizeNormal: 14,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 14,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.start,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildVideos(),
            ],
          );
        }
      } else {
        return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildVideos() {
    return ResponsiveGridList(
      minItemWidth: Dimens.heightVideoLand,
      verticalGridSpacing: 30,
      horizontalGridSpacing: 30,
      minItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 1 : 2,
      maxItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 1 : 2,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        ((newsDetailsProvider.videoNewsModel.result?.length ?? 0) >= 5
            ? 5
            : newsDetailsProvider.videoNewsModel.result?.length ?? 0),
        (position) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: InkWell(
              focusColor: white,
              borderRadius: BorderRadius.circular(0.5),
              onTap: () {
                debugPrint("Clicked on position ==> $position");
                openDetailPage(
                  newsDetailsProvider.videoNewsModel.result?[position].id
                          .toString() ??
                      "",
                  newsDetailsProvider
                          .videoNewsModel.result?[position].categoryId
                          .toString() ??
                      "",
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: Dimens.heightVideoLand,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(Constant.isTV ? 2 : 0),
                    child: MyNetworkImage(
                      imagePath: newsDetailsProvider
                              .videoNewsModel.result?[position].bannerImage ??
                          "",
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 15,
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: MyImage(
                        imagePath: "ic_play.png",
                        color: white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FittedBox(
                      child: Container(
                        decoration: Utils.setBackground(black, 0),
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(minHeight: 40),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: MyText(
                          color: white,
                          text: newsDetailsProvider.videoNewsModel
                                  .result?[position].categoryName ??
                              "",
                          textalign: TextAlign.center,
                          fontsizeNormal: 12,
                          fontweight: FontWeight.w500,
                          fontsizeWeb: 12,
                          multilanguage: false,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: MyText(
                      color: white,
                      text: newsDetailsProvider
                              .videoNewsModel.result?[position].name ??
                          "",
                      textalign: TextAlign.start,
                      fontsizeNormal: 16,
                      fontsizeWeb: 16,
                      fontweight: FontWeight.w600,
                      multilanguage: false,
                      maxline: 2,
                      overflow: TextOverflow.ellipsis,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  /* Video News END */

  /* Open Player START */
  _openPlayer() {
    if (Utils.checkLoginUser(context)) {
      if (newsDetailsProvider.newsDetailsModel.result?[0].isPaid.toString() ==
              "1" &&
          newsDetailsProvider.newsDetailsModel.result?[0].isBuy.toString() ==
              "0") {
        Utils.openSubscription(context: context);
      } else {
        if (!mounted) return;
        Utils.openPlayer(
          context: context,
          videoId:
              newsDetailsProvider.newsDetailsModel.result?[0].id.toString() ??
                  "",
          videoUrl:
              newsDetailsProvider.newsDetailsModel.result?[0].url.toString() ??
                  "",
          vUploadType: newsDetailsProvider.newsDetailsModel.result?[0].videoType
                  .toString() ??
              "",
          videoThumb: newsDetailsProvider.newsDetailsModel.result?[0].image
                  .toString() ??
              "",
        );
      }
    }
  }
  /* Open Player END */
}
