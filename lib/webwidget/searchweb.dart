import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/widget/nodata.dart';
import 'package:flutter/material.dart';

import 'package:Sindano/provider/searchprovider.dart';
import 'package:Sindano/utils/color.dart';
import 'package:Sindano/utils/dimens.dart';
import 'package:Sindano/widget/mynetworkimg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class SearchWeb extends StatefulWidget {
  final String? searchText;
  const SearchWeb({Key? key, required this.searchText}) : super(key: key);

  @override
  State<SearchWeb> createState() => _SearchWebState();
}

class _SearchWebState extends State<SearchWeb> {
  late SearchProvider searchProvider;

  @override
  void initState() {
    searchProvider = Provider.of<SearchProvider>(context, listen: false);
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    searchProvider.clearProvider();
    super.dispose();
  }

  _getData() async {
    if ((widget.searchText ?? "").isNotEmpty) {
      final searchProvider =
          Provider.of<SearchProvider>(context, listen: false);
      await searchProvider.getSearchResult(widget.searchText ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: appBgColor,
          child: Column(
            children: [
              /* Searched Data */
              Expanded(
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) {
                    return _buildSearchPage();
                  },
                ),
              ),
              const SizedBox(height: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchPage() {
    if (searchProvider.loading) {
      return _shimmerSearch();
    } else {
      if (searchProvider.searchModel.status == 200) {
        if (searchProvider.searchModel.result != null) {
          return Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ResponsiveGridList(
              minItemWidth: Dimens.widthLand,
              minItemsPerRow: 2,
              maxItemsPerRow: 7,
              verticalGridSpacing: 8,
              horizontalGridSpacing: 8,
              children: List.generate(
                (searchProvider.searchModel.result?.length ?? 0),
                (position) {
                  return Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      focusColor: white,
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        debugPrint("Clicked on position ==> $position");
                        // Utils.openDetails(
                        //   context: context,
                        //   videoId: searchProvider
                        //           .searchModel.result?[position].id ??
                        //       0,
                        //   upcomingType: 0,
                        //   videoType: searchProvider
                        //           .searchModel.result?[position].videoType ??
                        //       0,
                        //   typeId: searchProvider
                        //           .searchModel.result?[position].typeId ??
                        //       0,
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: Dimens.heightLand,
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: MyNetworkImage(
                              imagePath: searchProvider
                                      .searchModel.result?[position].image
                                      .toString() ??
                                  "",
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return const NoData(title: "", subTitle: "");
        }
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  Widget _shimmerSearch() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Utils.pageLoader(),
      // child: ShimmerUtils.responsiveGrid(context, Dimens.heightLand,
      //     Dimens.widthLand, 2, (kIsWeb || Constant.isTV) ? 40 : 20),
    );
  }
}
