import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/constant.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/shimmer/shimmerwidget.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ShimmerUtils {
  static Widget buildHomeMobileShimmer(context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          constraints: const BoxConstraints.expand(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                EdgeInsets.only(top: (Dimens.homeTabHeight + 10), bottom: 20),
            child: Column(
              children: [
                ((kIsWeb || Constant.isTV) &&
                        MediaQuery.of(context).size.width > 720)
                    ? bannerWeb(context)
                    : bannerMobile(context),
                ListView.builder(
                  itemCount: ((kIsWeb || Constant.isTV) &&
                          MediaQuery.of(context).size.width > 720)
                      ? 2
                      : 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return setHomeMobileSections(context);
                  },
                ),
              ],
            ),
          ),
        ),
        setTabShimmer(context),
      ],
    );
  }

  static Widget buildHomeWebShimmer(context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
            25,
            (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
            25),
        child: Column(
          children: [
            /* Banner */
            ((kIsWeb || Constant.isTV) &&
                    MediaQuery.of(context).size.width > 720)
                ? bannerWeb(context)
                : bannerMobile(context),

            /* ******** Other Sections ******** */
            ((kIsWeb || Constant.isTV) &&
                    MediaQuery.of(context).size.width > 720)
                ? setHomeWebSections(context)
                : setHomeMobileSections(context),
          ],
        ),
      ),
    );
  }

  static Widget buildHomeWebWithTabShimmer(context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: Dimens.homeTabWebHeight,
          padding: const EdgeInsets.fromLTRB(180, 5, 180, 5),
          color: appBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 25),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: ShimmerWidget.roundrectborder(
                  width: 20,
                  height: 20,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),

              /* App Icon */
              Container(
                padding: const EdgeInsets.all(5.0),
                child: ShimmerWidget.roundrectborder(
                  width: Dimens.homeTabFullHeight,
                  height: Dimens.homeTabFullHeight,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              const SizedBox(width: 20),

              /* Categories */
              (MediaQuery.of(context).size.width >= 800)
                  ? Expanded(
                      child: setTabShimmer(context),
                    )
                  : const Expanded(child: SizedBox.shrink()),
              const SizedBox(width: 10),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
                  25,
                  (MediaQuery.of(context).size.width > 1200) ? 180 : 50,
                  25),
              child: Column(
                children: [
                  /* Banner */
                  ((kIsWeb || Constant.isTV) &&
                          MediaQuery.of(context).size.width > 720)
                      ? bannerWeb(context)
                      : bannerMobile(context),

                  /* ******** Other Sections ******** */
                  ((kIsWeb || Constant.isTV) &&
                          MediaQuery.of(context).size.width > 720)
                      ? setHomeWebSections(context)
                      : setHomeMobileSections(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget setTabShimmer(context) {
    return Container(
      height:
          ((kIsWeb || Constant.isTV) && MediaQuery.of(context).size.width > 720)
              ? Dimens.homeTabWebHeight
              : Dimens.homeTabHeight,
      width: MediaQuery.of(context).size.width,
      color: white.withOpacity(0.9),
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics:
            const PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerWidget.roundrectborder(
                  height: 20,
                  width: 80,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 8),
                ShimmerWidget.roundrectborder(
                  height: 4,
                  width: 50,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget bannerMobile(context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: Dimens.homeBanner,
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 5,
            shadowColor: black.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
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
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ShimmerWidget.roundcorner(
                            height: MediaQuery.of(context).size.height,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                        ),
                        Positioned(
                          right: 15,
                          top: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: ShimmerWidget.roundcorner(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: ShimmerWidget.roundcorner(
                    width: MediaQuery.of(context).size.width,
                    height: 15,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                  child: ShimmerWidget.roundcorner(
                    width: MediaQuery.of(context).size.width,
                    height: 15,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.roundcorner(
                        width: 120,
                        height: 18,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      ShimmerWidget.roundcorner(
                        width: 100,
                        height: 15,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        CarouselIndicator(
          count: 3,
          index: 1,
          space: 8,
          height: 8,
          width: 8,
          cornerRadius: 4,
          color: dotsDefaultColor,
          activeColor: dotsActiveColor,
        ),
      ],
    );
  }

  static Widget bannerWeb(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: Dimens.homeWebBanner,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          color: shimmerItemColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: Dimens.homeWebBanner,
            child: ShimmerWidget.roundcorner(
              height: Dimens.homeWebBanner,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
            ),
          ),
        ),
      ),
    );
  }

  static Widget setHomeMobileSections(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ShimmerWidget.roundrectborder(
            height: 15,
            width: 100,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        buildGridShimmer(context, 3),
      ],
    );
  }

  static Widget setHomeWebSections(context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        /* Recent & Top News */
        ((kIsWeb || Constant.isTV) && MediaQuery.of(context).size.width > 1200)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRecentWebShimmer(context),
                  const SizedBox(width: 30),
                  Expanded(
                    child: buildTopWebShimmer(context),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRecentWebShimmer(context),
                  const SizedBox(height: 30),
                  buildTopWebShimmer(context),
                ],
              ),
      ],
    );
  }

  static Widget buildRecentWebShimmer(context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 1200)
          ? (MediaQuery.of(context).size.width * 0.25)
          : (MediaQuery.of(context).size.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShimmerWidget.roundrectborder(
            height: 40,
            width: 200,
            shimmerBgColor: shimmerItemColor,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: Utils.setBGWithBorder(
                transparent, shimmerItemColor.withOpacity(0.3), 0, 2.0),
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
                (5),
                (position) {
                  return Material(
                    type: MaterialType.transparency,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ShimmerWidget.roundrectborder(
                          height: 20,
                          width: 120,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 20),
                        ShimmerWidget.roundrectborder(
                          height: 25,
                          width: MediaQuery.of(context).size.width,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 8),
                        ShimmerWidget.roundrectborder(
                          height: 25,
                          width: 150,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 15),
                        ShimmerWidget.roundrectborder(
                          height: 18,
                          width: MediaQuery.of(context).size.width,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 8),
                        ShimmerWidget.roundrectborder(
                          height: 18,
                          width: MediaQuery.of(context).size.width,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 8),
                        ShimmerWidget.roundrectborder(
                          height: 18,
                          width: MediaQuery.of(context).size.width,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 20),
                        ShimmerWidget.roundrectborder(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTopWebShimmer(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ShimmerWidget.roundrectborder(
          height: 40,
          width: 200,
          shimmerBgColor: shimmerItemColor,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
            (6),
            (position) {
              return Container(
                decoration: Utils.setBGWithBorder(
                    transparent, otherColor.withOpacity(0.3), 0, 2.0),
                child: Column(
                  children: [
                    ShimmerWidget.roundrectborder(
                      height: 280,
                      width: MediaQuery.of(context).size.width,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ShimmerWidget.roundrectborder(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          const SizedBox(height: 8),
                          ShimmerWidget.roundrectborder(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 18,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                              const SizedBox(width: 10),
                              ShimmerWidget.roundrectborder(
                                height: 15,
                                width: 120,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ShimmerWidget.roundrectborder(
                                  height: 15,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /* Language News START */
  static Widget buildLanguageWiseShimmer(context) {
    if ((kIsWeb || Constant.isTV) && MediaQuery.of(context).size.width > 1200) {
      return Container(
        decoration: Utils.setBGWithBorder(
            transparent, otherColor.withOpacity(0.3), 0, 2.0),
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          axisDirection: AxisDirection.right,
          children: List.generate(
            (4),
            (position) {
              if (position == 0) {
                return StaggeredGridTile.count(
                  crossAxisCellCount: 3,
                  mainAxisCellCount: 3,
                  child: buildLanguageNews1Shimmer(context),
                );
              } else {
                return StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 3,
                  child: buildLanguageNews3Shimmer(context, position: position),
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
          crossAxisCount: 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          axisDirection: AxisDirection.down,
          children: List.generate(
            (4),
            (position) {
              if (position == 0) {
                return StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 4,
                  child: buildLanguageNews1Shimmer(context),
                );
              } else {
                return StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 1,
                  child: buildLanguageNews3Shimmer(context, position: position),
                );
              }
            },
          ),
        ),
      );
    }
  }

  static Widget buildLanguageNews1Shimmer(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ShimmerWidget.roundrectborder(
            height: 140,
            shimmerBgColor: shimmerItemColor,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
        ),
        const SizedBox(height: 20),
        ShimmerWidget.roundrectborder(
          height: 18,
          width: MediaQuery.of(context).size.width,
          shimmerBgColor: shimmerItemColor,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        const SizedBox(height: 5),
        ShimmerWidget.roundrectborder(
          height: 18,
          width: MediaQuery.of(context).size.width,
          shimmerBgColor: shimmerItemColor,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        const SizedBox(height: 20),
        ShimmerWidget.roundrectborder(
          height: 15,
          width: MediaQuery.of(context).size.width,
          shimmerBgColor: shimmerItemColor,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        const SizedBox(height: 5),
        ShimmerWidget.roundrectborder(
          height: 15,
          width: MediaQuery.of(context).size.width,
          shimmerBgColor: shimmerItemColor,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShimmerWidget.roundrectborder(
              height: 15,
              width: 100,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShimmerWidget.roundrectborder(
                    height: 15,
                    width: 120,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 15),
                  ShimmerWidget.roundrectborder(
                    height: 40,
                    width: 40,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 10),
                  ShimmerWidget.roundrectborder(
                    height: 40,
                    width: 40,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildLanguageNews3Shimmer(context, {required int position}) {
    return Column(
      children: [
        Row(
          children: [
            ShimmerWidget.roundrectborder(
              height: 140,
              width: 140,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
            ),
            const SizedBox(width: 15),
            ShimmerWidget.roundrectborder(
              height: 140,
              width: 1,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
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
                      ShimmerWidget.roundrectborder(
                        height: 18,
                        width: 18,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(width: 10),
                      ShimmerWidget.roundrectborder(
                        height: 15,
                        width: 100,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ShimmerWidget.roundrectborder(
                    height: 18,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 5),
                  ShimmerWidget.roundrectborder(
                    height: 18,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 15),
                  ShimmerWidget.roundrectborder(
                    height: 15,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 5),
                  ShimmerWidget.roundrectborder(
                    height: 15,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ShimmerWidget.roundrectborder(
          height: 0.5,
          shimmerBgColor: shimmerItemColor,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
      ],
    );
  }
  /* Language News END */

  static Widget responsiveGrid(
      context, bool isTitle, double itemMinWidth, int itemCount) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTitle)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ShimmerWidget.roundrectborder(
                height: 50,
                width: 180,
                shimmerBgColor: shimmerItemColor,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          if (isTitle) const SizedBox(height: 30),
          ResponsiveGridList(
            minItemWidth: itemMinWidth,
            verticalGridSpacing: 30,
            horizontalGridSpacing: 30,
            minItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 2 : 1,
            maxItemsPerRow: (MediaQuery.of(context).size.width > 1200) ? 2 : 1,
            listViewBuilderOptions: ListViewBuilderOptions(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            children: List.generate(
              itemCount,
              (position) {
                return Container(
                  decoration: Utils.setBGWithBorder(
                      transparent, shimmerItemColor.withOpacity(0.3), 0, 2.0),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ShimmerWidget.roundrectborder(
                        height: 140,
                        width: 140,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      const SizedBox(width: 15),
                      ShimmerWidget.roundrectborder(
                        height: 140,
                        width: 1,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
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
                                ShimmerWidget.roundrectborder(
                                  height: 18,
                                  width: 18,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                const SizedBox(width: 10),
                                ShimmerWidget.roundrectborder(
                                  height: 15,
                                  width: 100,
                                  shimmerBgColor: shimmerItemColor,
                                  shapeBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ShimmerWidget.roundrectborder(
                              height: 18,
                              width: MediaQuery.of(context).size.width,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 5),
                            ShimmerWidget.roundrectborder(
                              height: 18,
                              width: MediaQuery.of(context).size.width,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 15),
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: MediaQuery.of(context).size.width,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(height: 5),
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: MediaQuery.of(context).size.width,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildDetailMobileShimmer(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /* Poster */
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: ShimmerWidget.roundcorner(
              width: MediaQuery.of(context).size.width,
              height: Dimens.detailPoster,
              shimmerBgColor: shimmerItemColor,
              shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
          ),
          /* Details */
          Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Title */
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ShimmerWidget.roundrectborder(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ShimmerWidget.roundrectborder(
                    height: 20,
                    width: 120,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                /* Category & Date */
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ShimmerWidget.roundrectborder(
                          height: 28,
                          width: 100,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ShimmerWidget.roundrectborder(
                          height: 15,
                          width: 150,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ShimmerWidget.roundrectborder(
                      height: 0.2,
                      width: MediaQuery.of(context).size.width,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                /* Details */
                buildLines(context: context, height: 15, itemCount: 20),
                const SizedBox(height: 20),

                /* Related News */
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 32,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: ShimmerWidget.roundrectborder(
                            height: 18,
                            width: 120,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ShimmerWidget.roundrectborder(
                          height: 18,
                          width: 100,
                          shimmerBgColor: shimmerItemColor,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                buildGridShimmer(context, 5),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildLines({
    required BuildContext context,
    required double height,
    required int itemCount,
  }) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 3,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      itemBuilder: (BuildContext context, int position) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: ShimmerWidget.roundrectborder(
            height: height,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: shimmerItemColor,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      },
    );
  }

  static Widget buildDetailWebShimmer(context) {
    if ((kIsWeb || Constant.isTV) && MediaQuery.of(context).size.width > 1200) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ShimmerWidget.roundrectborder(
                    height: 25,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ShimmerWidget.roundrectborder(
                    height: 25,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ShimmerWidget.roundrectborder(
                    height: 25,
                    width: 120,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ShimmerWidget.roundrectborder(
                        height: 18,
                        width: 18,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: ShimmerWidget.roundrectborder(
                        height: 20,
                        width: 120,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 20,
                        width: 120,
                        alignment: Alignment.centerRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ShimmerWidget.roundrectborder(
                            height: 20,
                            width: 120,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: ShimmerWidget.roundrectborder(
                    height: 520,
                    width: MediaQuery.of(context).size.width,
                    shimmerBgColor: shimmerItemColor,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                /* Details */
                buildLines(context: context, height: 18, itemCount: 50),
              ],
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 1,
            child: buildRecentWebShimmer(context),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Details & Recent News */
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 25,
                  width: 120,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ShimmerWidget.roundrectborder(
                      height: 18,
                      width: 18,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ShimmerWidget.roundrectborder(
                      height: 15,
                      width: 120,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: ShimmerWidget.roundrectborder(
                        height: 15,
                        width: 120,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 520,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              /* Details */
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 18,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 18,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 18,
                  width: MediaQuery.of(context).size.width,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ShimmerWidget.roundrectborder(
                  height: 18,
                  width: 120,
                  shimmerBgColor: shimmerItemColor,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          buildRecentWebShimmer(context),
        ],
      );
    }
  }

  static Widget buildViewAllWebShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: Dimens.heightGridView,
                    maxWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ShimmerWidget.roundcorner(
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.heightGridView,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                Flexible(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.roundcorner(
                              width: 120,
                              height: 15,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ShimmerWidget.roundcorner(
                                height: 20,
                                width: 20,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 15,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 3),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 15,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 10),
                        ShimmerWidget.roundcorner(
                          width: 120,
                          height: 18,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
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
    );
  }

  static Widget buildGridShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: Dimens.heightGridView,
                    maxWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ShimmerWidget.roundcorner(
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.heightGridView,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                Flexible(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.roundcorner(
                              width: 120,
                              height: 15,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ShimmerWidget.roundcorner(
                                height: 20,
                                width: 20,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 15,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 3),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 15,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 10),
                        ShimmerWidget.roundcorner(
                          width: 120,
                          height: 18,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
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
    );
  }

  static Widget buildNotificationShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          constraints: BoxConstraints(
            minHeight: Dimens.heightNotification,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: colorPrimaryDark,
            shadowColor: white.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: Dimens.heightNotification,
                  width: Dimens.widthNotification,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ShimmerWidget.roundcorner(
                      width: MediaQuery.of(context).size.width,
                      height: Dimens.heightNotification,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: Dimens.heightNotification,
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 15,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 8),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 12,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 3),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 12,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 3),
                        ShimmerWidget.roundcorner(
                          width: MediaQuery.of(context).size.width,
                          height: 12,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(height: 10),
                        ShimmerWidget.roundcorner(
                          width: 120,
                          height: 18,
                          shapeBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
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
    );
  }

  static Widget buildSubscribeShimmer(context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: ShimmerWidget.roundrectborder(
            height: 20,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: black,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 30, right: 30),
          alignment: Alignment.center,
          child: ShimmerWidget.roundrectborder(
            height: 20,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: black,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        /* Remaining Data */
        Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            color: black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  constraints: const BoxConstraints(minHeight: 55),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget.roundrectborder(
                        height: 18,
                        width: 120,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      ShimmerWidget.roundrectborder(
                        height: 16,
                        width: 80,
                        shimmerBgColor: shimmerItemColor,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0.5,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: shimmerItemColor,
                ),
                AlignedGridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: 7,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int position) {
                    return Container(
                      constraints: const BoxConstraints(minHeight: 30),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: const Row(
                        children: [
                          Expanded(
                            child: ShimmerWidget.roundrectborder(
                              height: 18,
                              width: 100,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ),
                          SizedBox(width: 20),
                          ShimmerWidget.circular(
                            height: 30,
                            width: 30,
                            shimmerBgColor: shimmerItemColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                /* Choose Plan */
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ShimmerWidget.roundrectborder(
                      height: 52,
                      width: MediaQuery.of(context).size.width * 0.5,
                      shimmerBgColor: shimmerItemColor,
                      shapeBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  static Widget buildSubscribeWebShimmer(context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: ShimmerWidget.roundrectborder(
            height: 20,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: black,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 30, right: 30),
          alignment: Alignment.center,
          child: ShimmerWidget.roundrectborder(
            height: 20,
            width: MediaQuery.of(context).size.width,
            shimmerBgColor: black,
            shapeBorder: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
        const SizedBox(height: 12),
        /* Remaining Data */
        Container(
          height: 350,
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  color: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        constraints: const BoxConstraints(minHeight: 55),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 18,
                              width: 120,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            ShimmerWidget.roundrectborder(
                              height: 16,
                              width: 80,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.5,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: shimmerItemColor,
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /* Choose Plan */
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ShimmerWidget.roundrectborder(
                            height: 52,
                            width: MediaQuery.of(context).size.width * 0.5,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  color: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        constraints: const BoxConstraints(minHeight: 55),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 18,
                              width: 120,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            ShimmerWidget.roundrectborder(
                              height: 16,
                              width: 80,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.5,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: shimmerItemColor,
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /* Choose Plan */
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ShimmerWidget.roundrectborder(
                            height: 52,
                            width: MediaQuery.of(context).size.width * 0.5,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  color: black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        constraints: const BoxConstraints(minHeight: 55),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 18,
                              width: 120,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            ShimmerWidget.roundrectborder(
                              height: 16,
                              width: 80,
                              shimmerBgColor: shimmerItemColor,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 0.5,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: shimmerItemColor,
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const Row(
                          children: [
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 100,
                                shimmerBgColor: shimmerItemColor,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                            SizedBox(width: 20),
                            ShimmerWidget.circular(
                              height: 30,
                              width: 30,
                              shimmerBgColor: shimmerItemColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      /* Choose Plan */
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ShimmerWidget.roundrectborder(
                            height: 52,
                            width: MediaQuery.of(context).size.width * 0.5,
                            shimmerBgColor: shimmerItemColor,
                            shapeBorder: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  static Widget buildAvatarGrid(context, double itemHeight, double itemWidth,
      int crossAxisCount, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: itemWidth,
          height: itemHeight,
          alignment: Alignment.center,
          child: ShimmerWidget.circular(
            height: itemHeight,
            shimmerBgColor: shimmerItemColor,
          ),
        );
      },
    );
  }

  static Widget buildHistoryShimmer(context, int itemCount) {
    return AlignedGridView.count(
      shrinkWrap: true,
      crossAxisCount: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 12,
      padding: const EdgeInsets.only(left: 15, right: 15),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kIsWeb ? (itemCount + 10) : itemCount,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(minHeight: Dimens.heightHistory),
          decoration: Utils.setBackground(lightBlack, 5),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /* Title */
                      const ShimmerWidget.roundrectborder(
                        height: 20,
                        width: 120,
                        shimmerBgColor: black,
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),

                      /* Price */
                      Container(
                        constraints: const BoxConstraints(minHeight: 0),
                        margin: const EdgeInsets.only(top: 5),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 80,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 3,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 120,
                                shimmerBgColor: black,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /* Expire On */
                      Container(
                        constraints: const BoxConstraints(minHeight: 0),
                        margin: const EdgeInsets.only(top: 5),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 80,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            ShimmerWidget.roundrectborder(
                              height: 15,
                              width: 3,
                              shimmerBgColor: black,
                              shapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: ShimmerWidget.roundrectborder(
                                height: 18,
                                width: 120,
                                shimmerBgColor: black,
                                shapeBorder: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 30,
                constraints: const BoxConstraints(minWidth: 0),
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                alignment: Alignment.center,
                child: const ShimmerWidget.roundrectborder(
                  height: 20,
                  width: 100,
                  shimmerBgColor: black,
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
