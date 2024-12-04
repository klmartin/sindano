import 'package:SindanoShow/provider/notificationprovider.dart';
import 'package:SindanoShow/shimmer/shimmerutils.dart';
import 'package:SindanoShow/utils/color.dart';
import 'package:SindanoShow/utils/dimens.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/widget/mynetworkimg.dart';
import 'package:SindanoShow/widget/mytext.dart';
import 'package:SindanoShow/widget/nodata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    super.initState();
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    _getData();
  }

  _getData() async {
    await notificationProvider.getAllNotification();

    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  openDetailPage(String itemId) async {
    debugPrint("itemId ========> $itemId");
    if (!mounted) return;
    Utils.openDetails(
      context: context,
      itemId: itemId,
      categoryId: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.myAppBarWithBack(context, "notifications", true),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: Consumer<NotificationProvider>(
                    builder: (context, notificationProvider, child) {
                      return _buildPage();
                    },
                  ),
                ),
              ),
              Utils.showBannerAd(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    if (notificationProvider.loading) {
      return ShimmerUtils.buildNotificationShimmer(context, 8);
    } else {
      if (notificationProvider.notificationModel.status == 200 &&
          notificationProvider.notificationModel.result != null) {
        if ((notificationProvider.notificationModel.result?.length ?? 0) > 0) {
          return AlignedGridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                notificationProvider.notificationModel.result?.length ?? 0,
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
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () async {
                      int? itemType = notificationProvider
                              .notificationModel.result?[position].type ??
                          0;
                      debugPrint("Click itemType =======> $itemType");
                      await notificationProvider.readNotification(position);
                      if ((itemType == 1) || (itemType == 2)) {
                        openDetailPage(notificationProvider
                                .notificationModel.result?[position].articleId
                                .toString() ??
                            "");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGridImage(
                          thumbnailImg: notificationProvider
                                  .notificationModel.result?[position].image
                                  .toString() ??
                              "",
                        ),
                        _buildDetails(index: position),
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

  Widget _buildGridImage({required String thumbnailImg}) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: Dimens.heightNotification,
      width: Dimens.widthNotification,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MyNetworkImage(
          imagePath: thumbnailImg,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDetails({required int index}) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          minHeight: Dimens.heightNotification,
        ),
        padding: const EdgeInsets.fromLTRB(2, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyText(
                text: notificationProvider
                        .notificationModel.result?[index].title
                        .toString() ??
                    "",
                color: white,
                fontsizeNormal: 15,
                fontsizeWeb: 15,
                fontweight: FontWeight.w700,
                maxline: 2,
                multilanguage: false,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyText(
                text: notificationProvider
                        .notificationModel.result?[index].message
                        .toString() ??
                    "",
                color: whiteLight,
                fontsizeNormal: 13,
                fontsizeWeb: 13,
                fontweight: FontWeight.w500,
                maxline: 5,
                multilanguage: false,
                textalign: TextAlign.start,
                fontstyle: FontStyle.normal,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            MyText(
              text: (notificationProvider
                              .notificationModel.result?[index].createdAt
                              .toString() ??
                          "")
                      .isNotEmpty
                  ? (DateFormat("dd MMMM, yyyy").format(DateTime.parse(
                      notificationProvider
                              .notificationModel.result?[index].createdAt
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
