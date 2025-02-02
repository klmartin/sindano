import 'package:Sindano/provider/bookmarkprovider.dart';
import 'package:Sindano/shimmer/shimmerutils.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/dimens.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mynetworkimg.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:Sindano/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({Key? key}) : super(key: key);

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  late BookMarkProvider bookMarkProvider;

  @override
  void initState() {
    super.initState();
    bookMarkProvider = Provider.of<BookMarkProvider>(context, listen: false);
    _getData();
  }

  _getData() async {
    await bookMarkProvider.getBookmarkList();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 15, bottom: 20),
                child: Consumer<BookMarkProvider>(
                  builder: (context, bookMarkProvider, child) {
                    return _buildNews();
                  },
                ),
              ),
            ),
            Utils.showBannerAd(context),
          ],
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

  Widget _buildNews() {
    if (bookMarkProvider.loading) {
      return ShimmerUtils.buildGridShimmer(context, 8);
    } else {
      if (bookMarkProvider.newsModel.status == 200 &&
          bookMarkProvider.newsModel.result != null) {
        if ((bookMarkProvider.newsModel.result?.length ?? 0) > 0) {
          return AlignedGridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookMarkProvider.newsModel.result?.length ?? 0,
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
                          bookMarkProvider.newsModel.result?[position].id
                                  .toString() ??
                              "",
                          bookMarkProvider
                                  .newsModel.result?[position].categoryId
                                  .toString() ??
                              "");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildGridImage(
                          thumbnailImg: bookMarkProvider
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
                    text: bookMarkProvider.newsModel.result?[index].categoryName
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
                        await bookMarkProvider.addBookmark(context, index);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: MyImage(
                        fit: BoxFit.contain,
                        imagePath: "ic_bookmark_remove.png",
                        color: otherIcons,
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
                    bookMarkProvider.newsModel.result?[index].name.toString() ??
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
              text: (bookMarkProvider.newsModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      bookMarkProvider.newsModel.result?[index].createdAt
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
    );
  }
}
