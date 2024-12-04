import 'package:SindanoShow/model/bannermodel.dart';
import 'package:SindanoShow/model/newsmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class HomeSectionProvider extends ChangeNotifier {
  BannerModel bannerModel = BannerModel();
  NewsModel topNewsModel = NewsModel();
  NewsModel recentNewsModel = NewsModel();
  NewsModel videoNewsModel = NewsModel();
  NewsModel lastWeekNewsModel = NewsModel();
  SuccessModel successModel = SuccessModel();

  int selectedIndex = 0;
  String currentPage = "";

  bool loadingBanner = false, loadingSection = false;
  int? cBannerIndex = 0, lastTabPosition;

  getBanner(categoryId) async {
    debugPrint("getBanner categoryId =====> $categoryId");
    loadingBanner = true;
    bannerModel = await ApiService().bannerList(categoryId, "");
    debugPrint("getBanner status =========> ${bannerModel.status}");
    loadingBanner = false;
    notifyListeners();
  }

  getTopNews(categoryId) async {
    debugPrint("getTopNews categoryId ===========> $categoryId");
    loadingSection = true;
    topNewsModel = await ApiService().getTopsNews(categoryId);
    loadingSection = false;
    notifyListeners();
  }

  getRecentNews(categoryId) async {
    debugPrint("getRecentNews categoryId ===========> $categoryId");
    loadingSection = true;
    recentNewsModel = await ApiService().recentNews(categoryId);
    loadingSection = false;
    notifyListeners();
  }

  getVideoNews(categoryId) async {
    debugPrint("getVideoNews categoryId ===========> $categoryId");
    loadingSection = true;
    videoNewsModel = await ApiService().videoNews(categoryId);
    loadingSection = false;
    notifyListeners();
  }

  getLastWeekNews(categoryId) async {
    debugPrint("getLastWeekNews categoryId ===========> $categoryId");
    loadingSection = true;
    lastWeekNewsModel = await ApiService().lastWeekNews(categoryId);
    loadingSection = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loadingBanner = isLoading;
    loadingSection = isLoading;
    notifyListeners();
  }

  setTabPosition(position) {
    lastTabPosition = position;
    notifyListeners();
  }

  setCurrentBanner(position) {
    cBannerIndex = position;
    notifyListeners();
  }

  addBookmark(BuildContext context, dataType, int position, articleID) async {
    debugPrint("addBookmark dataType ========> $dataType");
    debugPrint("addBookmark articleID =======> $articleID");
    if (dataType == "topnews") {
      if ((topNewsModel.result?[position].isBookmark ?? 0) == 0) {
        topNewsModel.result?[position].isBookmark = 1;
        Utils.showSnackbar(context, "success", "add_bookmark", true);
      } else {
        topNewsModel.result?[position].isBookmark = 0;
        Utils.showSnackbar(context, "success", "remove_bookmark", true);
      }
      for (var i = 0; i < (recentNewsModel.result?.length ?? 0); i++) {
        if (articleID == (recentNewsModel.result?[i].id.toString())) {
          debugPrint(
              "recentNewsModel articleID =======> ${recentNewsModel.result?[i].id}");
          if ((recentNewsModel.result?[position].isBookmark ?? 0) == 0) {
            recentNewsModel.result?[position].isBookmark = 1;
          } else {
            recentNewsModel.result?[position].isBookmark = 0;
          }
        }
      }
      for (var i = 0; i < (bannerModel.result?.length ?? 0); i++) {
        if (articleID == (bannerModel.result?[i].id.toString())) {
          debugPrint(
              "bannerModel articleID =======> ${bannerModel.result?[i].id}");
          if ((bannerModel.result?[position].isBookmark ?? 0) == 0) {
            bannerModel.result?[position].isBookmark = 1;
          } else {
            bannerModel.result?[position].isBookmark = 0;
          }
        }
      }
    } else if (dataType == "recentnews") {
      if ((recentNewsModel.result?[position].isBookmark ?? 0) == 0) {
        recentNewsModel.result?[position].isBookmark = 1;
        Utils.showSnackbar(context, "success", "add_bookmark", true);
      } else {
        recentNewsModel.result?[position].isBookmark = 0;
        Utils.showSnackbar(context, "success", "remove_bookmark", true);
      }
      for (var i = 0; i < (topNewsModel.result?.length ?? 0); i++) {
        if (articleID == (topNewsModel.result?[i].id.toString())) {
          debugPrint(
              "topNewsModel articleID =======> ${topNewsModel.result?[i].id}");
          if ((topNewsModel.result?[position].isBookmark ?? 0) == 0) {
            topNewsModel.result?[position].isBookmark = 1;
          } else {
            topNewsModel.result?[position].isBookmark = 0;
          }
        }
      }
      for (var i = 0; i < (bannerModel.result?.length ?? 0); i++) {
        if (articleID == (bannerModel.result?[i].id.toString())) {
          debugPrint(
              "bannerModel articleID =======> ${bannerModel.result?[i].id}");
          if ((bannerModel.result?[position].isBookmark ?? 0) == 0) {
            bannerModel.result?[position].isBookmark = 1;
          } else {
            bannerModel.result?[position].isBookmark = 0;
          }
        }
      }
    } else if (dataType == "banner") {
      if ((bannerModel.result?[position].isBookmark ?? 0) == 0) {
        bannerModel.result?[position].isBookmark = 1;
        Utils.showSnackbar(context, "success", "add_bookmark", true);
      } else {
        bannerModel.result?[position].isBookmark = 0;
        Utils.showSnackbar(context, "success", "remove_bookmark", true);
      }
      for (var i = 0; i < (topNewsModel.result?.length ?? 0); i++) {
        if (articleID == (topNewsModel.result?[i].id.toString())) {
          debugPrint(
              "topNewsModel articleID =======> ${topNewsModel.result?[i].id}");
          if ((topNewsModel.result?[position].isBookmark ?? 0) == 0) {
            topNewsModel.result?[position].isBookmark = 1;
          } else {
            topNewsModel.result?[position].isBookmark = 0;
          }
        }
      }
      for (var i = 0; i < (recentNewsModel.result?.length ?? 0); i++) {
        if (articleID == (recentNewsModel.result?[i].id.toString())) {
          debugPrint(
              "recentNewsModel articleID =======> ${recentNewsModel.result?[i].id}");
          if ((recentNewsModel.result?[position].isBookmark ?? 0) == 0) {
            recentNewsModel.result?[position].isBookmark = 1;
          } else {
            recentNewsModel.result?[position].isBookmark = 0;
          }
        }
      }
    }
    notifyListeners();
    addRemoveBookmark(articleID);
  }

  addRemoveBookmark(articleID) async {
    debugPrint("addToBookmark articleID =======> $articleID");
    successModel = await ApiService().addArticleBookmark(articleID);
    debugPrint("addToBookmark Status ==========> ${successModel.status}");
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    loadingBanner = false;
    loadingSection = false;
    bannerModel = BannerModel();
    topNewsModel = NewsModel();
    recentNewsModel = NewsModel();
    videoNewsModel = NewsModel();
    lastWeekNewsModel = NewsModel();
    successModel = SuccessModel();
    cBannerIndex = 0;
    lastTabPosition = 0;
  }
}
