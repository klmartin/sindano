import 'package:Sindano/provider/searchprovider.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  final searchController = TextEditingController();
  late SearchProvider searchProvider = SearchProvider();

  @override
  void initState() {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchProvider.clearProvider();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  _getSearchedData(String? searchText) async {
    await searchProvider.getSearchResult(searchText ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: SafeArea(
          child: Column(
            children: [
              /* Search Box */
              _buildSearchBox(),
              const SizedBox(height: 20),
              /* Searched Data */
              Expanded(
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: AdSize.banner.height.toDouble()),
                      child: _buildNewsUI(),
                    );
                  },
                ),
              ),
              Utils.showBannerAd(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(12, 15, 12, 5),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: Utils.setBGWithBorder(transparent, white, 45, 0.7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: MyImage(
                width: 15,
                height: 15,
                imagePath: "ic_back.png",
                color: white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: TextFormField(
                controller: searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                obscureText: false,
                maxLines: 1,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 3),
                  hintText: "Search news...",
                  filled: true,
                  fillColor: transparent,
                  hintStyle: GoogleFonts.inter(
                    color: otherColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: white,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                onFieldSubmitted: (value) async {},
                onChanged: (value) async {
                  debugPrint("value ====> $value");
                  if (value.isNotEmpty) {
                    await searchProvider.clearProvider();
                    await searchProvider.setLoading(true);
                    _getSearchedData(value.toString());
                  } else {
                    await searchProvider.setLoading(false);
                    await searchProvider.clearProvider();
                    await searchProvider.notifyProvider();
                  }
                },
              ),
            ),
          ),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (searchController.text.toString().isNotEmpty) {
                return InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () async {
                    debugPrint("Click on Clear!");
                    searchController.clear();
                    await searchProvider.clearProvider();
                    if (!mounted) return;
                    setState(() {});
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(18),
                    alignment: Alignment.center,
                    child: MyImage(
                      imagePath: "ic_close.png",
                      color: white,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
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

  Widget _buildNewsUI() {
    if (searchProvider.loading) {
      return ShimmerUtils.buildGridShimmer(context, 8);
    } else {
      if (searchProvider.searchModel.status == 200 &&
          searchProvider.searchModel.result != null) {
        if ((searchProvider.searchModel.result?.length ?? 0) > 0) {
          return AlignedGridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchProvider.searchModel.result?.length ?? 0,
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
                  color: colorPrimaryDark,
                  shadowColor: white.withOpacity(0.2),
                  child: InkWell(
                    onTap: () {
                      Utils.openDetails(
                        context: context,
                        itemId: searchProvider.searchModel.result?[position].id
                                .toString() ??
                            "",
                        categoryId: searchProvider
                                .searchModel.result?[position].categoryId
                                .toString() ??
                            "",
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildGridImage(
                          thumbnailImg: searchProvider
                                  .searchModel.result?[position].image
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
        return const SizedBox.shrink();
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
                    text: searchProvider.searchModel.result?[index].categoryName
                            .toString() ??
                        "",
                    color: whiteLight,
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
                        await searchProvider.addBookmark(context, index);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: Consumer<SearchProvider>(
                        builder: (context, searchProvider, child) {
                          return MyImage(
                            fit: BoxFit.contain,
                            imagePath: (searchProvider.searchModel
                                        .result?[index].isBookmark ==
                                    1)
                                ? "ic_bookmarkfill.png"
                                : "ic_bookmark.png",
                            color: (searchProvider.searchModel.result?[index]
                                        .isBookmark ==
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
                    searchProvider.searchModel.result?[index].name.toString() ??
                        "",
                color: white,
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
              text: (searchProvider.searchModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      searchProvider.searchModel.result?[index].createdAt
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
