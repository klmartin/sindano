import 'dart:async';
import 'package:Sindano/provider/userstatusprovider.dart';
import 'package:Sindano/subscription/subscription.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:Sindano/provider/generalprovider.dart';
import 'package:Sindano/provider/homesectionprovider.dart';
import 'package:Sindano/provider/languageprovider.dart';
import 'package:Sindano/provider/languagesectionprovider.dart';
import 'package:Sindano/shimmer/shimmerutils.dart';
import 'package:Sindano/tvpages/tvlanguagesection.dart';
import 'package:Sindano/tvpages/tvviewall.dart';
import 'package:Sindano/utils/sharedpre.dart';
import 'package:Sindano/model/categorymodel.dart' as type;
import 'package:Sindano/model/bannermodel.dart' as banner;
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/dimens.dart';
import 'package:Sindano/provider/homeprovider.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/webwidget/footerweb.dart';
import 'package:Sindano/widget/myimage.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/mynetworkimg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TVHome extends StatefulWidget {
  final String? pageName;
  const TVHome({Key? key, required this.pageName}) : super(key: key);

  @override
  State<TVHome> createState() => TVHomeState();
}

class TVHomeState extends State<TVHome> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPre sharedPref = SharedPre();
  late HomeProvider homeProvider;
  late HomeSectionProvider homeSectionProvider;
  CarouselController carouselController = CarouselController();
  String? currentPage;

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

  _onItemTapped(String page) async {
    debugPrint("_onItemTapped -----------------> $page");
    await homeProvider.setCurrentPage(page);
    if (page != "") {
      await setSelectedTab(-1);
    }
    setState(() {
      currentPage = page;
    });
  }

  @override
  void initState() {
    _mainScrollController.addListener(_scrollListener);
    currentPage = widget.pageName ?? "";
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    homeSectionProvider =
        Provider.of<HomeSectionProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);

    Constant.userID = await sharedPref.read("userid");
    debugPrint('userID =========> ${Constant.userID}');
    await homeProvider.setLoading(true);
    await homeProvider.getCategory();
    await languageProvider.getLanguage();

    if (!homeProvider.loading) {
      if (homeProvider.categoryModel.status == 200 &&
          homeProvider.categoryModel.result != null) {
        if ((homeProvider.categoryModel.result?.length ?? 0) > 0) {
          if ((homeSectionProvider.bannerModel.result?.length ?? 0) == 0 ||
              (homeSectionProvider.topNewsModel.result?.length ?? 0) == 0 ||
              (homeSectionProvider.recentNewsModel.result?.length ?? 0) == 0) {
            getTabData(0, homeProvider.categoryModel.result);
          }
        }
      }
    }

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
    if (!mounted) return;
    generalProvider.getGeneralsetting(context);
  }

  Future<void> setSelectedTab(int tabPos) async {
    if (!mounted) return;
    await homeProvider.setSelectedTab(tabPos);

    debugPrint("getTabData position ====> $tabPos");
    debugPrint(
        "getTabData lastTabPosition ====> ${homeSectionProvider.lastTabPosition}");
    if (homeSectionProvider.lastTabPosition == tabPos) {
      return;
    } else {
      homeSectionProvider.setTabPosition(tabPos);
    }
  }

  Future<void> getTabData(int position, List<type.Result>? categoryList) async {
    final languageSectionProvider =
        Provider.of<LanguageSectionProvider>(context, listen: false);
    languageSectionProvider.clearProvider();
    await setSelectedTab(position);
    await homeSectionProvider.setLoading(true);
    await homeSectionProvider.getBanner(
        position == 0 ? "0" : (categoryList?[position - 1].id.toString()));
    await homeSectionProvider.getTopNews(
        position == 0 ? "0" : (categoryList?[position - 1].id.toString()));
    await homeSectionProvider.getRecentNews(
        position == 0 ? "0" : (categoryList?[position - 1].id.toString()));
    await homeSectionProvider.getVideoNews(
        position == 0 ? "0" : (categoryList?[position - 1].id.toString()));
    await homeSectionProvider.getLastWeekNews(
        position == 0 ? "0" : (categoryList?[position - 1].id.toString()));
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
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
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
    if (homeProvider.selectedIndex > 0) {
      catId = homeProvider
              .categoryModel.result?[(homeProvider.selectedIndex) - 1].id
              .toString() ??
          "0";
    }
    debugPrint("dataType ============> $dataType");
    debugPrint("appBarTitle =========> $appBarTitle");
    debugPrint("languageId ==========> $languageId");
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
        return tabItem(homeProvider.categoryModel.result);
    }
  }

  @override
  Widget build(BuildContext context) {

 
    return Scaffold(
      backgroundColor: appBgColor,
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
      body: SafeArea(
        child: _tvAppBarWithDetails(),
      ),
    );
  }

  Widget _tvAppBarWithDetails() {
    if (homeProvider.loading) {
      return ShimmerUtils.buildHomeWebWithTabShimmer(context);
    } else {
      if (homeProvider.categoryModel.status == 200) {
        if (homeProvider.categoryModel.result != null ||
            (homeProvider.categoryModel.result?.length ?? 0) > 0) {
          return Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _clickToRedirect(pageName: currentPage ?? ""),
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

  Widget _buildAppBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimens.homeTabWebHeight,
      padding: EdgeInsets.fromLTRB(
          (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
          5,
          (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
          5),
      color: colorPrimaryDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Menu */
          (MediaQuery.of(context).size.width < 1200)
              ? Container(
                  constraints: const BoxConstraints(
                    minWidth: 25,
                  ),
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  margin: const EdgeInsets.only(right: 10),
                  child: Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isDense: true,
                          isExpanded: true,
                          customButton: MyImage(
                            height: 30,
                            imagePath: "ic_menu.png",
                            fit: BoxFit.contain,
                            color: lightGray,
                          ),
                          items: _buildWebDropDownItems(),
                          onChanged: (type.Result? value) async {
                            if (kIsWeb) {
                              _onItemTapped("");
                            }
                            debugPrint(
                                'value id ===============> ${value?.id.toString()}');
                            if (value?.id == 0) {
                              await getTabData(
                                  0, homeProvider.categoryModel.result);
                            } else {
                              for (var i = 0;
                                  i <
                                      (homeProvider
                                              .categoryModel.result?.length ??
                                          0);
                                  i++) {
                                if (value?.id ==
                                    homeProvider.categoryModel.result?[i].id) {
                                  await getTabData(
                                      i + 1, homeProvider.categoryModel.result);
                                  return;
                                }
                              }
                            }
                          },
                          dropdownStyleData: DropdownStyleData(
                            width: 180,
                            useSafeArea: true,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: Utils.setBackground(lightBlack, 5),
                            elevation: 8,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            overlayColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.focused)) {
                                  return white.withOpacity(0.5);
                                }
                                return transparentColor;
                              },
                            ),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: Utils.setBGWithBorder(
                                transparentColor, white, 20, 1),
                            overlayColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.focused)) {
                                  return white.withOpacity(0.5);
                                }
                                if (states.contains(MaterialState.hovered)) {
                                  return white.withOpacity(0.5);
                                }
                                return transparentColor;
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),

          /* App Icon */
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              focusColor: white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                if (Constant.isTV) _onItemTapped("");
                await getTabData(0, homeProvider.categoryModel.result);
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: MyImage(
                  width: Dimens.homeTabFullHeight,
                  height: Dimens.homeTabFullHeight,
                  imagePath: "logo5.png",
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          /* Categories */
          (MediaQuery.of(context).size.width >= 1200)
              ? Expanded(
                  child: tabTitle(homeProvider.categoryModel.result),
                )
              : const Expanded(child: SizedBox.shrink()),
          const SizedBox(width: 10),

          /* Subscription */
          InkWell(
            onTap: () {
              Utils.openSubscription(context: context);
            },
            borderRadius: BorderRadius.circular(8),
            focusColor: white.withOpacity(0.5),
            child: Container(
              height: 40,
              constraints: const BoxConstraints(minWidth: 50),
              decoration: Utils.setBackground(colorPrimary, 8),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.center,
              child: MyText(
                color: white,
                multilanguage: true,
                text: "subsciption",
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
          const SizedBox(width: 20),

          /* Login / Logout */
          Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              return InkWell(
                focusColor: white,
                onTap: () async {
                  if (Constant.userID != null) {
                    _buildLogoutDialog();
                  } else {
                    Utils.buildWebAlertDialog(context, "login", "")
                        .then((value) => _getData());
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyText(
                    color: white,
                    multilanguage: true,
                    text: (Constant.userID != null) ? "logout" : "login",
                    fontsizeNormal: 14,
                    fontweight: FontWeight.w600,
                    fontsizeWeb: 14,
                    maxline: 1,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget tabTitle(List<type.Result>? sectionTypeList) {
    return ListView.separated(
      itemCount: (sectionTypeList?.length ?? 0) + 1,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
      separatorBuilder: (context, index) => const SizedBox(width: 30),
      itemBuilder: (BuildContext context, int index) {
        return Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            return Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(2),
                focusColor: white.withOpacity(0.5),
                onTap: () async {
                  debugPrint("index ===========> $index");
                  _onItemTapped("");
                  await getTabData(index, homeProvider.categoryModel.result);
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
                          color: homeProvider.selectedIndex == index
                              ? white
                              : whiteLight,
                          multilanguage: false,
                          text: index == 0
                              ? "All"
                              : index > 0
                                  ? (sectionTypeList?[index - 1]
                                          .name
                                          .toString() ??
                                      "")
                                  : "",
                          fontsizeNormal: 15,
                          fontweight: homeProvider.selectedIndex == index
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontsizeWeb: 15,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 4,
                        width: 50,
                        decoration: Utils.setBackground(
                          homeProvider.selectedIndex == index
                              ? colorAccent
                              : transparentColor,
                          1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<type.Result>>? _buildWebDropDownItems() {
    List<type.Result>? typeDropDownList = [];
    for (var i = 0;
        i < (homeProvider.categoryModel.result?.length ?? 0) + 1;
        i++) {
      if (i == 0) {
        type.Result typeHomeResult = type.Result();
        typeHomeResult.id = 0;
        typeHomeResult.name = "Home";
        typeDropDownList.insert(i, typeHomeResult);
      } else {
        typeDropDownList.insert(
            i, (homeProvider.categoryModel.result?[(i - 1)] ?? type.Result()));
      }
    }
    return typeDropDownList
        .map<DropdownMenuItem<type.Result>>((type.Result value) {
      return DropdownMenuItem<type.Result>(
        value: value,
        alignment: Alignment.center,
        child: FittedBox(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 35, minWidth: 100),
            decoration: Utils.setBackground(
              homeProvider.selectedIndex != -1
                  ? ((typeDropDownList[homeProvider.selectedIndex].id ?? 0) ==
                          (value.id ?? 0)
                      ? white
                      : transparentColor)
                  : transparentColor,
              20,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: MyText(
              color: homeProvider.selectedIndex != -1
                  ? ((typeDropDownList[homeProvider.selectedIndex].id ?? 0) ==
                          (value.id ?? 0)
                      ? black
                      : white)
                  : white,
              multilanguage: false,
              text: (value.name.toString()),
              fontsizeNormal: 14,
              fontweight: FontWeight.w600,
              fontsizeWeb: 15,
              maxline: 1,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget tabItem(List<type.Result>? sectionTypeList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        controller: _mainScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Consumer<HomeSectionProvider>(
              builder: (context, homeSectionProvider, child) {
                if (homeSectionProvider.loadingBanner ||
                    homeSectionProvider.loadingSection) {
                  return ShimmerUtils.buildHomeWebShimmer(context);
                } else {
                  return Container(
                    padding: EdgeInsets.fromLTRB(
                        (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
                        25,
                        (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
                        25),
                    child: Column(
                      children: [
                        /* Banner */
                        _setBanner(),

                        /* ******** Other Sections ******** */
                        _setOtherSections(),
                      ],
                    ),
                  );
                }
              },
            ),

            /* Web Footer */
            const SizedBox(height: 20),
            kIsWeb ? const FooterWeb() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  /* Banner START */
  Widget _setBanner() {
    if (homeSectionProvider.loadingBanner) {
      if ((kIsWeb || Constant.isTV) &&
          MediaQuery.of(context).size.width > 720) {
        return ShimmerUtils.bannerWeb(context);
      } else {
        return ShimmerUtils.bannerMobile(context);
      }
    } else {
      if (homeSectionProvider.bannerModel.status == 200 &&
          homeSectionProvider.bannerModel.result != null) {
        if ((kIsWeb || Constant.isTV) &&
            MediaQuery.of(context).size.width > 720) {
          return _tvHomeBanner(homeSectionProvider.bannerModel.result);
        } else {
          return _mobileHomeBanner(homeSectionProvider.bannerModel.result);
        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _tvHomeBanner(List<banner.Result>? sectionBannerList) {
    if ((sectionBannerList?.length ?? 0) > 0) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: Dimens.homeWebBanner,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider.builder(
              itemCount: (sectionBannerList?.length ?? 0),
              carouselController: carouselController,
              options: CarouselOptions(
                initialPage: 0,
                height: Dimens.homeWebBanner,
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
                return InkWell(
                  focusColor: white,
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    debugPrint("Clicked on index ==> $index");
                    openDetailPage(
                        sectionBannerList?[index].id.toString() ?? "",
                        sectionBannerList?[index].categoryId.toString() ?? "");
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: Dimens.homeWebBanner,
                          child: MyNetworkImage(
                            imagePath:
                                sectionBannerList?[index].bannerImage ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width,
                          height: Dimens.homeWebBanner,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                blue.withOpacity(0.1),
                                blue.withOpacity(0.2),
                                blue.withOpacity(0.3),
                                blue.withOpacity(0.4),
                                blue.withOpacity(0.5),
                                blue.withOpacity(0.9),
                                blue,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: FittedBox(
                            child: Container(
                              decoration: Utils.setBackground(colorAccent, 0),
                              alignment: Alignment.center,
                              constraints: const BoxConstraints(minHeight: 35),
                              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                              child: MyText(
                                color: white,
                                text: sectionBannerList?[index].categoryName ??
                                    "",
                                textalign: TextAlign.center,
                                fontsizeNormal: 14,
                                fontweight: FontWeight.w500,
                                fontsizeWeb: 14,
                                multilanguage: false,
                                maxline: 1,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 100,
                          right: 100,
                          bottom: 40,
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText(
                                  color: white,
                                  text: sectionBannerList?[index].name ?? "",
                                  textalign: TextAlign.start,
                                  fontsizeNormal: 14,
                                  fontsizeWeb: 25,
                                  fontweight: FontWeight.w700,
                                  multilanguage: false,
                                  maxline: 4,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MyImage(
                                      height: 20,
                                      width: 20,
                                      imagePath: "ic_calendar.png",
                                      color: white,
                                    ),
                                    const SizedBox(width: 10),
                                    MyText(
                                      color: white,
                                      text: ((sectionBannerList?[index]
                                                      .createdAt ??
                                                  "")
                                              .isNotEmpty)
                                          ? (DateFormat("dd MMMM yyyy").format(
                                              DateTime.parse(
                                                  sectionBannerList?[index]
                                                          .createdAt ??
                                                      "")))
                                          : "-",
                                      textalign: TextAlign.start,
                                      fontsizeNormal: 14,
                                      fontsizeWeb: 14,
                                      fontweight: FontWeight.w400,
                                      multilanguage: false,
                                      maxline: 1,
                                      overflow: TextOverflow.ellipsis,
                                      fontstyle: FontStyle.normal,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildArrowBtns(
                    iconName: "ic_left",
                    onClick: () async {
                      await homeSectionProvider.setCurrentBanner(
                          ((homeSectionProvider.cBannerIndex ?? 0) - 1));
                      carouselController.previousPage(
                        duration:
                            Duration(milliseconds: Constant.animationDuration),
                        curve: Curves.linear,
                      );
                    },
                  ),
                  _buildArrowBtns(
                    iconName: "ic_right",
                    onClick: () async {
                      await homeSectionProvider.setCurrentBanner(
                          ((homeSectionProvider.cBannerIndex ?? 0) + 1));
                      carouselController.nextPage(
                        duration:
                            Duration(milliseconds: Constant.animationDuration),
                        curve: Curves.linear,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildArrowBtns(
      {required String iconName, required Function() onClick}) {
    return InkWell(
      borderRadius: BorderRadius.circular(1),
      onTap: onClick,
      child: Container(
        decoration: Utils.setBackground(whiteLight, 1),
        padding: const EdgeInsets.all(10),
        child: MyImage(
          height: 15,
          width: 15,
          imagePath: "$iconName.png",
          color: black,
        ),
      ),
    );
  }

  Widget _mobileHomeBanner(List<banner.Result>? sectionBannerList) {
    if ((sectionBannerList?.length ?? 0) > 0) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimens.homeBanner,
            child: CarouselSlider.builder(
              itemCount: (sectionBannerList?.length ?? 0),
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
                return InkWell(
                  focusColor: white,
                  borderRadius: BorderRadius.circular(0),
                  onTap: () {
                    debugPrint("Clicked on index ==> $index");
                    openDetailPage(
                        sectionBannerList?[index].id.toString() ?? "",
                        sectionBannerList?[index].categoryId.toString() ?? "");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: Dimens.homeBanner,
                          child: MyNetworkImage(
                            imagePath:
                                sectionBannerList?[index].bannerImage ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width,
                          height: Dimens.homeBanner,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: [
                                transparentColor,
                                transparentColor,
                                appBgColor,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Consumer<HomeSectionProvider>(
              builder: (context, homeSectionProvider, child) {
                return AnimatedSmoothIndicator(
                  count: (sectionBannerList?.length ?? 0),
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
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
  /* Banner END */

  Widget _buildTitleViewAll({
    required String title,
    required bool isMultiLang,
    required Function() onViewAll,
  }) {
    if (MediaQuery.of(context).size.width > 420) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            InkWell(
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
            ),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            child: Container(
              height: 50,
              decoration: Utils.setBackground(colorAccent, 0),
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              margin: const EdgeInsets.only(bottom: 10),
              alignment: Alignment.centerLeft,
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
          ),
          FittedBox(
            child: InkWell(
              borderRadius: BorderRadius.circular(2),
              onTap: onViewAll,
              child: Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.centerLeft,
                child: MyText(
                  color: colorAccent,
                  text: "viewall",
                  multilanguage: true,
                  textalign: TextAlign.start,
                  fontsizeNormal: 14,
                  fontweight: FontWeight.w500,
                  fontsizeWeb: 14,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  fontstyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  /* Set Other Sections */
  Widget _setOtherSections() {
    return Column(
      children: [
        const SizedBox(height: 25),
        /* Recent & Top News */
        _buildRecentTop(),

        /* Category Wise */
        const SizedBox(height: 50),
        TVLanguageSection(
          categoryId: homeProvider.selectedIndex > 0
              ? (homeProvider
                      .categoryModel.result?[homeProvider.selectedIndex - 1].id
                      .toString() ??
                  "0")
              : "0",
        ),

        /* Video News */
        const SizedBox(height: 50),
        _buildVideoNews(),
        const SizedBox(height: 50),

        /* Last Week News */
        _buildLastWeekNews(),
        const SizedBox(height: 25),
      ],
    );
  }

  /* Recent & Top News START */
  Widget _buildRecentTop() {
    if ((kIsWeb || Constant.isTV) && MediaQuery.of(context).size.width > 1200) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecents(),
          const SizedBox(width: 30),
          Expanded(
            child: _buildTop(),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecents(),
          const SizedBox(height: 30),
          _buildTop(),
        ],
      );
    }
  }

  Widget _buildRecents() {
    if (homeSectionProvider.recentNewsModel.status == 200 &&
        homeSectionProvider.recentNewsModel.result != null) {
      if ((homeSectionProvider.recentNewsModel.result?.length ?? 0) > 0) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width > 1200)
              ? (MediaQuery.of(context).size.width * 0.25)
              : (MediaQuery.of(context).size.width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTitleViewAll(
                title: "RECENT NEWS",
                isMultiLang: false,
                onViewAll: () {
                  openViewAll(
                    dataType: "recentnews",
                    appBarTitle: "RECENT NEWS",
                  );
                },
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
                    (((homeSectionProvider.recentNewsModel.result?.length ??
                                0) >=
                            4)
                        ? 4
                        : (homeSectionProvider.recentNewsModel.result?.length ??
                            0)),
                    (position) {
                      return Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(4),
                          focusColor: white,
                          onTap: () {
                            debugPrint("Clicked on position ==> $position");
                            openDetailPage(
                              homeSectionProvider
                                      .recentNewsModel.result?[position].id
                                      .toString() ??
                                  "",
                              homeSectionProvider.recentNewsModel
                                      .result?[position].categoryId
                                      .toString() ??
                                  "",
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyText(
                                color: colorAccent,
                                text: homeSectionProvider.recentNewsModel
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
                                text: homeSectionProvider.recentNewsModel
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
                                text: homeSectionProvider.recentNewsModel
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

  Widget _buildTop() {
    if (homeSectionProvider.topNewsModel.status == 200 &&
        homeSectionProvider.topNewsModel.result != null) {
      if ((homeSectionProvider.topNewsModel.result?.length ?? 0) > 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTitleViewAll(
              title: "TOP NEWS",
              isMultiLang: false,
              onViewAll: () {
                openViewAll(
                  dataType: "topnews",
                  appBarTitle: "TOP NEWS",
                );
              },
            ),
            const SizedBox(height: 30),
            ResponsiveGridList(
              minItemWidth: (MediaQuery.of(context).size.width > 1200)
                  ? (MediaQuery.of(context).size.width * 0.3)
                  : (MediaQuery.of(context).size.width),
              verticalGridSpacing: 30,
              horizontalGridSpacing: 30,
              minItemsPerRow: (MediaQuery.of(context).size.width > 800) ? 2 : 1,
              maxItemsPerRow: (MediaQuery.of(context).size.width > 800) ? 2 : 1,
              listViewBuilderOptions: ListViewBuilderOptions(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              children: List.generate(
                (((homeSectionProvider.topNewsModel.result?.length ?? 0) >= 4)
                    ? 4
                    : (homeSectionProvider.topNewsModel.result?.length ?? 0)),
                (position) {
                  return Container(
                    decoration: Utils.setBGWithBorder(
                        transparent, otherColor.withOpacity(0.3), 0, 2.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      focusColor: white,
                      onTap: () {
                        debugPrint("Clicked on position ==> $position");
                        openDetailPage(
                          homeSectionProvider.topNewsModel.result?[position].id
                                  .toString() ??
                              "",
                          homeSectionProvider
                                  .topNewsModel.result?[position].categoryId
                                  .toString() ??
                              "",
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: MyNetworkImage(
                              imagePath: homeSectionProvider.recentNewsModel
                                      .result?[position].bannerImage ??
                                  "",
                              fit: BoxFit.cover,
                              height: 280,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MyText(
                                  color: black,
                                  text: homeSectionProvider.recentNewsModel
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
                                      text: ((homeSectionProvider
                                                      .topNewsModel
                                                      .result?[position]
                                                      .createdAt
                                                      .toString() ??
                                                  "")
                                              .isNotEmpty)
                                          ? (DateFormat("dd MMMM, yyyy").format(
                                              DateTime.parse(homeSectionProvider
                                                      .topNewsModel
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
                                    Expanded(
                                      child: MyText(
                                        color: colorAccent,
                                        text: homeSectionProvider
                                                .recentNewsModel
                                                .result?[position]
                                                .categoryName ??
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
  /* Recent & Latest News END */

  /* Video News START */
  Widget _buildVideoNews() {
    if (homeSectionProvider.videoNewsModel.status == 200 &&
        homeSectionProvider.videoNewsModel.result != null) {
      if ((homeSectionProvider.videoNewsModel.result?.length ?? 0) > 0) {
        if ((kIsWeb || Constant.isTV) &&
            MediaQuery.of(context).size.width > 1200) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleViewAll(
                title: "LATEST VIDEO",
                isMultiLang: false,
                onViewAll: () {
                  openViewAll(
                    dataType: "videonews",
                    appBarTitle: "LATEST VIDEO",
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildVideos(),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleViewAll(
                title: "LATEST VIDEO",
                isMultiLang: false,
                onViewAll: () {
                  openViewAll(
                    dataType: "videonews",
                    appBarTitle: "LATEST VIDEO",
                  );
                },
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.heightVideoLand,
      child: ListView.separated(
        itemCount: (homeSectionProvider.videoNewsModel.result?.length ?? 0),
        shrinkWrap: true,
        physics:
            const PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 30),
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: Dimens.widthVideoLand,
            child: InkWell(
              focusColor: white,
              borderRadius: BorderRadius.circular(0.5),
              onTap: () {
                debugPrint("Clicked on index ==> $index");
                openDetailPage(
                  homeSectionProvider.videoNewsModel.result?[index].id
                          .toString() ??
                      "",
                  homeSectionProvider.videoNewsModel.result?[index].categoryId
                          .toString() ??
                      "",
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: Dimens.widthVideoLand,
                    height: Dimens.heightVideoLand,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(Constant.isTV ? 2 : 0),
                    child: MyNetworkImage(
                      imagePath: homeSectionProvider
                              .videoNewsModel.result?[index].bannerImage ??
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
                          text: homeSectionProvider
                                  .videoNewsModel.result?[index].categoryName ??
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
                      text: homeSectionProvider
                              .videoNewsModel.result?[index].name ??
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

  /* Last Week News START */
  Widget _buildLastWeekNews() {
    if (homeSectionProvider.lastWeekNewsModel.status == 200 &&
        homeSectionProvider.lastWeekNewsModel.result != null) {
      if ((homeSectionProvider.lastWeekNewsModel.result?.length ?? 0) > 0) {
        if ((kIsWeb || Constant.isTV) &&
            MediaQuery.of(context).size.width > 1200) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleViewAll(
                title: "LAST WEEK NEWS",
                isMultiLang: false,
                onViewAll: () {
                  openViewAll(
                    dataType: "lastweeknews",
                    appBarTitle: "LAST WEEK NEWS",
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildLastWeek(),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleViewAll(
                title: "LAST WEEK NEWS",
                isMultiLang: false,
                onViewAll: () {
                  openViewAll(
                    dataType: "lastweeknews",
                    appBarTitle: "LAST WEEK NEWS",
                  );
                },
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
      minItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 2 : 1,
      maxItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 2 : 1,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
      children: List.generate(
        (((homeSectionProvider.lastWeekNewsModel.result?.length ?? 0) >= 6)
            ? 6
            : (homeSectionProvider.lastWeekNewsModel.result?.length ?? 0)),
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
                  homeSectionProvider.lastWeekNewsModel.result?[position].id
                          .toString() ??
                      "",
                  homeSectionProvider
                          .lastWeekNewsModel.result?[position].categoryId
                          .toString() ??
                      "",
                );
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: MyNetworkImage(
                      imagePath: homeSectionProvider.lastWeekNewsModel
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
                          text: homeSectionProvider.lastWeekNewsModel
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
                          text: homeSectionProvider
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
                          text: homeSectionProvider.lastWeekNewsModel
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

  Future<void> _buildLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: const EdgeInsets.fromLTRB(100, 25, 100, 25),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          backgroundColor: lightBlack,
          child: Container(
            padding: const EdgeInsets.all(25),
            constraints: const BoxConstraints(
              minWidth: 250,
              maxWidth: 300,
              minHeight: 100,
              maxHeight: 150,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        color: white,
                        text: "confirmsognout",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsizeNormal: 16,
                        fontsizeWeb: 18,
                        fontweight: FontWeight.bold,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      MyText(
                        color: white,
                        text: "areyousurewanrtosignout",
                        multilanguage: true,
                        textalign: TextAlign.center,
                        fontsizeNormal: 13,
                        fontsizeWeb: 14,
                        fontweight: FontWeight.w500,
                        maxline: 2,
                        overflow: TextOverflow.ellipsis,
                        fontstyle: FontStyle.normal,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 75,
                          ),
                          height: 35,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: otherColor,
                              width: .5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MyText(
                            color: white,
                            text: "cancel",
                            multilanguage: true,
                            textalign: TextAlign.center,
                            fontsizeNormal: 16,
                            fontsizeWeb: 17,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontweight: FontWeight.w600,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () async {
                          final homeProvider =
                              Provider.of<HomeProvider>(context, listen: false);
                          // Firebase Signout
                          await auth.signOut();
                          await GoogleSignIn().signOut();
                          await Utils.setUserId(null);
                          await homeProvider.homeNotifyProvider();
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 75,
                          ),
                          height: 35,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: MyText(
                            color: black,
                            text: "logout",
                            textalign: TextAlign.center,
                            fontsizeNormal: 16,
                            fontsizeWeb: 17,
                            multilanguage: true,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            fontweight: FontWeight.w600,
                            fontstyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
