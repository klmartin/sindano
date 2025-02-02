import 'dart:async';
import 'package:Sindano/provider/homeprovider.dart';
import 'package:Sindano/provider/languageprovider.dart';
import 'package:Sindano/provider/languagesectionprovider.dart';
import 'package:Sindano/shimmer/shimmerutils.dart';
import 'package:Sindano/tvpages/tvviewall.dart';
import 'package:Sindano/utils/sharedpre.dart';

import 'package:Sindano/model/languagemodel.dart' as type;
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/mynetworkimg.dart';
import 'package:Sindano/widget/nodata.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TVLanguageSection extends StatefulWidget {
  final String? categoryId;
  const TVLanguageSection({Key? key, required this.categoryId})
      : super(key: key);

  @override
  State<TVLanguageSection> createState() => TVLanguageSectionState();
}

class TVLanguageSectionState extends State<TVLanguageSection> {
  SharedPre sharedPref = SharedPre();
  late LanguageProvider languageProvider;
  late LanguageSectionProvider languageSectionProvider;
  String? currentPage;

  @override
  void initState() {
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    languageSectionProvider =
        Provider.of<LanguageSectionProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() async {
    if (!languageProvider.loading) {
      if (languageProvider.languageModel.status == 200 &&
          languageProvider.languageModel.result != null) {
        if ((languageProvider.languageModel.result?.length ?? 0) > 0) {
          if ((languageSectionProvider.languageNewsModel.result?.length ?? 0) ==
              0) {
            languageSectionProvider.clearProvider();
            getTabData(0, languageProvider.languageModel.result);
          }
        }
      }
    }

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> setSelectedTab(int tabPos) async {
    if (!mounted) return;
    await languageProvider.setSelectedTab(tabPos);

    debugPrint("getTabData position ====> $tabPos");
    debugPrint(
        "getTabData lastTabPosition ====> ${languageSectionProvider.lastTabPosition}");
    if (languageSectionProvider.lastTabPosition == tabPos) {
      return;
    } else {
      languageSectionProvider.setTabPosition(tabPos);
    }
  }

  Future<void> getTabData(int position, List<type.Result>? languageList) async {
    await setSelectedTab(position);
    await languageSectionProvider.setLoading(true);
    await languageSectionProvider.getNewsByLanguage(
        widget.categoryId.toString(), languageList?[position].id.toString());
  }

  openDetailPage(String itemId, String categoryId) async {
    debugPrint("itemId ==========> $itemId");
    debugPrint("categoryId ======> $categoryId");
    if (!mounted) return;
    Utils.openDetails(context: context, itemId: itemId, categoryId: categoryId);
  }

  openViewAll({
    required String dataType,
    required String appBarTitle,
  }) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    String languageId = "0";
    String catId = "0";
    if (languageProvider.languageModel.status == 200 &&
        languageProvider.languageModel.result != null) {
      if ((languageProvider.languageModel.result?.length ?? 0) > 0) {
        languageId = languageProvider
                .languageModel.result?[languageProvider.selectedIndex].id
                .toString() ??
            "0";
      }
    }
    debugPrint("languageId ==========> $languageId");
    if (homeProvider.selectedIndex > 0) {
      catId = homeProvider
              .categoryModel.result?[(homeProvider.selectedIndex) - 1].id
              .toString() ??
          "0";
    }
    debugPrint("dataType ============> $dataType");
    debugPrint("appBarTitle =========> $appBarTitle");
    debugPrint("categoryId ==========> $catId");
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TvViewAll(
            dataType: dataType,
            appBarTitle: appBarTitle,
            languageId: languageId,
            catId: catId,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _clickToRedirect({required String pageName}) {
    switch (pageName) {
      default:
        return tabItem(languageProvider.languageModel.result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _tvAppBarWithDetails();
  }

  Widget _tvAppBarWithDetails() {
    if (languageProvider.loading) {
      return Utils.pageLoader();
    } else {
      if (languageProvider.languageModel.status == 200) {
        if (languageProvider.languageModel.result != null ||
            (languageProvider.languageModel.result?.length ?? 0) > 0) {
          return Column(
            children: [
              _buildAppBar(),
              _clickToRedirect(pageName: currentPage ?? ""),
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

  Widget _buildTitleViewAll({
    required String title,
    required bool isMultiLang,
    required Function() onViewAll,
  }) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 120),
            height: MediaQuery.of(context).size.height,
            decoration: Utils.setBackground(colorAccent, 0),
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            child: MyText(
              color: white,
              text: title,
              multilanguage: isMultiLang,
              fontsizeNormal: 14,
              fontweight: FontWeight.w600,
              fontsizeWeb: 14,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.start,
              fontstyle: FontStyle.normal,
            ),
          ),
          Consumer<LanguageSectionProvider>(
            builder: (context, languageSectionProvider, child) {
              if (languageSectionProvider.languageNewsModel.status == 200 &&
                  languageSectionProvider.languageNewsModel.result != null) {
                if ((languageSectionProvider.languageNewsModel.result?.length ??
                        0) >
                    0) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(2),
                    onTap: onViewAll,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: MyText(
                        color: colorAccent,
                        text: "viewall",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsizeNormal: 14,
                        fontweight: FontWeight.w500,
                        fontsizeWeb: 14,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: 75,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitleViewAll(
            title: "LANGUAGE",
            isMultiLang: false,
            onViewAll: () {
              openViewAll(
                dataType: "languagenews",
                appBarTitle: "LANGUAGE",
              );
            },
          ),
          const SizedBox(height: 25),

          /* Languages */
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: tabTitle(languageProvider.languageModel.result),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabTitle(List<type.Result>? sectionTypeList) {
    return ListView.separated(
      itemCount: (sectionTypeList?.length ?? 0),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemBuilder: (BuildContext context, int index) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () async {
                debugPrint("index ===========> $index");
                await getTabData(index, sectionTypeList);
              },
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(minHeight: 40),
                      alignment: Alignment.center,
                      child: MyText(
                        color: languageProvider.selectedIndex == index
                            ? colorPrimaryDark
                            : otherColor,
                        multilanguage: false,
                        text: (sectionTypeList?[index].name.toString() ?? ""),
                        fontsizeNormal: 14,
                        fontweight: languageProvider.selectedIndex == index
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontsizeWeb: 14,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                    Container(
                      height: 4,
                      width: 50,
                      decoration: Utils.setBackground(
                        languageProvider.selectedIndex == index
                            ? colorAccent
                            : transparentColor,
                        1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget tabItem(List<type.Result>? sectionTypeList) {
    return Consumer<LanguageSectionProvider>(
      builder: (context, languageSectionProvider, child) {
        if (languageSectionProvider.loadingSection) {
          return ShimmerUtils.buildLanguageWiseShimmer(context);
        } else {
          return _buildLanguageWise();
        }
      },
    );
  }

  /* Language News START */
  Widget _buildLanguageWise() {
    if ((languageSectionProvider.languageNewsModel.result?.length ?? 0) > 0) {
      if ((kIsWeb || Constant.isTV) &&
          MediaQuery.of(context).size.width > 1200) {
        return Container(
          decoration: Utils.setBGWithBorder(
              transparent, otherColor.withOpacity(0.3), 0, 2.0),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: StaggeredGrid.count(
            crossAxisCount:
                ((languageSectionProvider.languageNewsModel.result?.length ??
                            0) >
                        1)
                    ? 3
                    : 1,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            axisDirection: AxisDirection.right,
            children: List.generate(
              (languageSectionProvider.languageNewsModel.result?.length ?? 0) >
                      4
                  ? 4
                  : (languageSectionProvider.languageNewsModel.result?.length ??
                      0),
              (position) {
                if (position == 0) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: ((languageSectionProvider
                                    .languageNewsModel.result?.length ??
                                0) >
                            1)
                        ? 3
                        : 2,
                    mainAxisCellCount: ((languageSectionProvider
                                    .languageNewsModel.result?.length ??
                                0) >
                            1)
                        ? 3
                        : 2,
                    child: _buildLanguageNews1(),
                  );
                } else {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 3,
                    child: _buildLanguageNews3Grid(position: position),
                  );
                }
              },
            ),
          ),
        );
      } else {
        return Container(
          decoration: Utils.setBGWithBorder(
              transparent, otherColor.withOpacity(0.3), 0, 2.0),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: StaggeredGrid.count(
            crossAxisCount:
                ((languageSectionProvider.languageNewsModel.result?.length ??
                            0) >
                        1)
                    ? 4
                    : 1,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            axisDirection: AxisDirection.down,
            children: List.generate(
              (languageSectionProvider.languageNewsModel.result?.length ?? 0) >
                      4
                  ? 4
                  : (languageSectionProvider.languageNewsModel.result?.length ??
                      0),
              (position) {
                if (position == 0) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: ((languageSectionProvider
                                    .languageNewsModel.result?.length ??
                                0) >
                            1)
                        ? 4
                        : 1,
                    mainAxisCellCount: ((languageSectionProvider
                                    .languageNewsModel.result?.length ??
                                0) >
                            1)
                        ? 4
                        : 1,
                    child: _buildLanguageNews1(),
                  );
                } else {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 1,
                    child: _buildLanguageNews3Grid(position: position),
                  );
                }
              },
            ),
          ),
        );
      }
    } else {
      return const NoData(title: '', subTitle: '');
    }
  }

  Widget _buildLanguageNews1() {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      focusColor: white,
      onTap: () {
        openDetailPage("", "");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: MyNetworkImage(
                imagePath: languageSectionProvider
                        .languageNewsModel.result?[0].bannerImage ??
                    "",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          const SizedBox(height: 20),
          MyText(
            color: black,
            text:
                languageSectionProvider.languageNewsModel.result?[0].name ?? "",
            textalign: TextAlign.start,
            fontsizeNormal: 15,
            fontsizeWeb: 15,
            fontweight: FontWeight.w600,
            multilanguage: false,
            maxline: 3,
            overflow: TextOverflow.ellipsis,
            fontstyle: FontStyle.normal,
          ),
          const SizedBox(height: 20),
          MyText(
            color: edtBG,
            text: languageSectionProvider
                    .languageNewsModel.result?[0].description ??
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
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyText(
                color: colorAccent,
                text: languageSectionProvider
                        .languageNewsModel.result?[0].categoryName ??
                    "",
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
                child: Container(
                  alignment: Alignment.centerRight,
                  child: MyText(
                    color: grayDark,
                    text: ((languageSectionProvider
                                    .languageNewsModel.result?[0].createdAt
                                    .toString() ??
                                "")
                            .isNotEmpty)
                        ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                            languageSectionProvider
                                    .languageNewsModel.result?[0].createdAt
                                    .toString() ??
                                "")))
                        : "-",
                    textalign: TextAlign.center,
                    fontsizeNormal: 13,
                    fontsizeWeb: 13,
                    fontweight: FontWeight.w400,
                    multilanguage: false,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageNews3Grid({required int position}) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      focusColor: white,
      onTap: () {
        debugPrint("Clicked on position ==> $position");
        openDetailPage(
          languageSectionProvider.languageNewsModel.result?[position].id
                  .toString() ??
              "",
          languageSectionProvider.languageNewsModel.result?[position].categoryId
                  .toString() ??
              "",
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: MyNetworkImage(
                  imagePath: languageSectionProvider
                          .languageNewsModel.result?[position].bannerImage ??
                      "",
                  fit: BoxFit.cover,
                  height: 140,
                  width: 140,
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 1,
                height: 140,
                decoration: Utils.setBackground(colorAccent, 0),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                          text: ((languageSectionProvider.languageNewsModel
                                          .result?[position].createdAt
                                          .toString() ??
                                      "")
                                  .isNotEmpty)
                              ? (DateFormat("dd MMMM, yyyy").format(
                                  DateTime.parse(languageSectionProvider
                                          .languageNewsModel
                                          .result?[position]
                                          .createdAt
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
                      ],
                    ),
                    const SizedBox(height: 15),
                    MyText(
                      color: black,
                      text: languageSectionProvider
                              .languageNewsModel.result?[position].name ??
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
                      text: languageSectionProvider.languageNewsModel
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
          const SizedBox(height: 15),
          Divider(height: 0.5, color: otherColor.withOpacity(0.3)),
        ],
      ),
    );
  }
  /* Language News END */
}
