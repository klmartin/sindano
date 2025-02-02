import 'package:Sindano/model/categorymodel.dart';
import 'package:Sindano/provider/homeprovider.dart';
import 'package:Sindano/provider/videoprovider.dart';
import 'package:Sindano/pages/videosections.dart';
import 'package:Sindano/shimmer/shimmerutils.dart';
import 'package:Sindano/utils/adhelper.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/constant.dart';
import 'package:Sindano/utils/dimens.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/mytext.dart';
import 'package:Sindano/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  final tabScrollController = ScrollController();
  late ListObserverController observerController;
  late HomeProvider homeProvider;
  late VideoProvider videoProvider;

  @override
  void initState() {
    observerController =
        ListObserverController(controller: tabScrollController);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  _getData() async {
    if (homeProvider.categoryModel.result == null) {
      await homeProvider.setLoading(true);
      await homeProvider.getCategory();
    }

    if (!homeProvider.loading) {
      if (homeProvider.categoryModel.status == 200 &&
          homeProvider.categoryModel.result != null) {
        if ((homeProvider.categoryModel.result?.length ?? 0) > 0) {
          if ((videoProvider.newsModel.result?.length ?? 0) == 0) {
            getTabData(0, homeProvider.categoryModel.result);
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
    debugPrint("setSelectedTab tabPos ====> $tabPos");
    if (!mounted) return;
    await homeProvider.setSelectedTab(tabPos);
    debugPrint(
        "setSelectedTab selectedIndex ====> ${homeProvider.selectedIndex}");
    debugPrint(
        "setSelectedTab lastTabPosition ====> ${videoProvider.lastTabPosition}");
    if (videoProvider.lastTabPosition == tabPos) {
      return;
    } else {
      videoProvider.setTabPosition(tabPos);
    }
  }

  Future<void> getTabData(int position, List<Result>? sectionTypeList) async {
    debugPrint("getTabData position ====> $position");
    await setSelectedTab(position);
    await videoProvider.setLoading(true);
    await videoProvider.getBanner(
        position == 0 ? "0" : (sectionTypeList?[position - 1].id.toString()));
    await videoProvider.getVideoNews(
        position == 0 ? "0" : (sectionTypeList?[position - 1].id.toString()));
  }

  @override
  void dispose() {
    videoProvider.clearProvider();
    super.dispose();
  }

  _scrollToCurrent() {
    debugPrint(
        "selectedIndex ======> ${homeProvider.selectedIndex.toDouble()}");
    observerController.animateTo(
      index: homeProvider.selectedIndex,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return homeProvider.loading
            ? ShimmerUtils.buildHomeMobileShimmer(context)
            : (homeProvider.categoryModel.status == 200)
                ? (homeProvider.categoryModel.result != null ||
                        (homeProvider.categoryModel.result?.length ?? 0) > 0)
                    ? Stack(
                        children: [
                          VideoSections(
                              categoryId: homeProvider.categoryModel
                                      .result?[homeProvider.selectedIndex].id
                                      .toString() ??
                                  "0"),
                          Container(
                            height: Dimens.homeTabHeight,
                            width: MediaQuery.of(context).size.width,
                            color: white.withOpacity(0.9),
                            child: tabTitle(homeProvider.categoryModel.result),
                          ),
                        ],
                      )
                    : const NoData(title: '', subTitle: '')
                : const NoData(title: '', subTitle: '');
      },
    );
  }

  Widget tabTitle(List<Result>? sectionTypeList) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tabScrollController.hasClients) {
        _scrollToCurrent();
      }
    });
    return ListViewObserver(
      controller: observerController,
      child: ListView.separated(
        itemCount: (sectionTypeList?.length ?? 0) + 1,
        shrinkWrap: true,
        controller: tabScrollController,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (BuildContext context, int index) {
          return Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              return InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () async {
                  debugPrint("index ===========> $index");
                  AdHelper.showFullscreenAd(context, Constant.interstialAdType,
                      () async {
                    await getTabData(index, sectionTypeList);
                  });
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
                              ? colorPrimaryDark
                              : otherColor,
                          multilanguage: false,
                          text: index == 0
                              ? "All"
                              : index > 0
                                  ? (sectionTypeList?[index - 1]
                                          .name
                                          .toString() ??
                                      "")
                                  : "",
                          fontsizeNormal: 14,
                          fontweight: homeProvider.selectedIndex == index
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
                          homeProvider.selectedIndex == index
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
      ),
    );
  }
}
