import 'package:SindanoShow/provider/viewallprovider.dart';
import 'package:SindanoShow/shimmer/shimmerutils.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/mynetworkimg.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/widget/nodata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class TvViewAll extends StatefulWidget {
  final String dataType, appBarTitle, languageId, catId;
  const TvViewAll(
      {required this.dataType,
      required this.appBarTitle,
      required this.languageId,
      required this.catId,
      Key? key})
      : super(key: key);

  @override
  State<TvViewAll> createState() => _TvViewAllState();
}

class _TvViewAllState extends State<TvViewAll> {
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
    } else if (widget.dataType == "videonews") {
      await viewAllProvider.getVideoNews(widget.catId);
    } else if (widget.dataType == "lastweeknews") {
      await viewAllProvider.getLastWeekNews(widget.catId);
    } else if (widget.dataType == "languagenews") {
      await viewAllProvider.getNewsByLanguage(widget.catId, widget.languageId);
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
      backgroundColor: appBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
              25,
              (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
              25),
          child: _buildPage(),
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (viewAllProvider.loading) {
      return ShimmerUtils.responsiveGrid(
          context, true, (MediaQuery.of(context).size.width * 0.5), 12);
    } else {
      if (viewAllProvider.newsModel.status == 200 &&
          viewAllProvider.newsModel.result != null) {
        if ((viewAllProvider.newsModel.result?.length ?? 0) > 0) {
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
                      text: widget.appBarTitle,
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
                _buildNews(),
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
                      text: widget.appBarTitle,
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
                _buildNews(),
              ],
            );
          }
        } else {
          return const NoData(title: '', subTitle: '');
        }
      } else {
        return const NoData(title: '', subTitle: '');
      }
    }
  }

  Widget _buildNews() {
    return ResponsiveGridList(
      minItemWidth: (MediaQuery.of(context).size.width * 0.5),
      verticalGridSpacing: 30,
      horizontalGridSpacing: 30,
      minItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 2 : 1,
      maxItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 2 : 1,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        (viewAllProvider.newsModel.result?.length ?? 0),
        (position) {
          return _buildNewsItem(position: position);
        },
      ),
    );
  }

  Widget _buildNewsItem({required int position}) {
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
            viewAllProvider.newsModel.result?[position].id.toString() ?? "",
            viewAllProvider.newsModel.result?[position].categoryId.toString() ??
                "",
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: MyNetworkImage(
                imagePath:
                    viewAllProvider.newsModel.result?[position].bannerImage ??
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
                    text: viewAllProvider
                            .newsModel.result?[position].categoryName ??
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
                    text:
                        viewAllProvider.newsModel.result?[position].name ?? "",
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
                    text: viewAllProvider
                            .newsModel.result?[position].description ??
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
  }
}
