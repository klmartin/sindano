import 'package:SindanoShow/provider/viewallprovider.dart';
import 'package:SindanoShow/shimmer/shimmerutils.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/myimage.dart';
import 'package:SindanoShow/widget/mynetworkimg.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewAll extends StatefulWidget {
  final String dataType, appBarTitle, catId;
  const ViewAll(
      {required this.dataType,
      required this.appBarTitle,
      required this.catId,
      Key? key})
      : super(key: key);

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  late ViewAllProvider viewAllProvider;

  @override
  void initState() {
    viewAllProvider = Provider.of<ViewAllProvider>(context, listen: false);
    super.initState();
    _getData();
  }

  _getData() async {
    if (widget.dataType == "topnews") {
      await viewAllProvider.getTopNews(widget.catId);
    } else if (widget.dataType == "recentnews") {
      await viewAllProvider.getRecentNews(widget.catId);
    } else if (widget.dataType == "relatednews") {
      await viewAllProvider.getRelatedNews(widget.catId);
    }
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
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
    viewAllProvider.clearProvider();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.myAppBarWithBack(context, widget.appBarTitle, true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _buildNews(),
            ),
          ),
          Utils.showBannerAd(context),
        ],
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

  Widget _buildNews() {
    if (viewAllProvider.loading) {
      return ShimmerUtils.buildGridShimmer(context, 8);
    } else {
      if (viewAllProvider.newsModel.status == 200 &&
          viewAllProvider.newsModel.result != null) {
        if ((viewAllProvider.newsModel.result?.length ?? 0) > 0) {
          return AlignedGridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewAllProvider.newsModel.result?.length ?? 0,
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
                      openDetailPage(
                          viewAllProvider.newsModel.result?[position].id
                                  .toString() ??
                              "",
                          viewAllProvider.newsModel.result?[position].categoryId
                                  .toString() ??
                              "");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildGridImage(
                          thumbnailImg: viewAllProvider
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
  }

  Widget _buildNewsDetails({required int index}) {
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
                    text: viewAllProvider.newsModel.result?[index].categoryName
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
                        await viewAllProvider.addBookmark(context, index);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: Consumer<ViewAllProvider>(
                        builder: (context, viewAllProvider, child) {
                          return MyImage(
                            fit: BoxFit.contain,
                            imagePath: (viewAllProvider
                                        .newsModel.result?[index].isBookmark ==
                                    1)
                                ? "ic_bookmarkfill.png"
                                : "ic_bookmark.png",
                            color: (viewAllProvider
                                        .newsModel.result?[index].isBookmark ==
                                    1)
                                ? colorAccent
                                : otherColor,
                          );
                        },
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
                text:
                    viewAllProvider.newsModel.result?[index].name.toString() ??
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
              text: (viewAllProvider.newsModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      viewAllProvider.newsModel.result?[index].createdAt
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
