import 'package:Sindano/model/bannermodel.dart';
import 'package:Sindano/model/newsmodel.dart';
import 'package:Sindano/model/successmodel.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class VideoProvider extends ChangeNotifier {
  BannerModel bannerModel = BannerModel();
  NewsModel newsModel = NewsModel();
  SuccessModel successModel = SuccessModel();

  int selectedIndex = 0;
  String currentPage = "";

  bool loadingBanner = false, loadingSection = false;
  int? cBannerIndex = 0, lastTabPosition;

  getBanner(categoryId) async {
    debugPrint("getBanner categoryId =====> $categoryId");
    loadingBanner = true;
    bannerModel = await ApiService().bannerList(categoryId, "2");
    debugPrint("getBanner status =========> ${bannerModel.status}");
    loadingBanner = false;
    notifyListeners();
  }

  getVideoNews(categoryId) async {
    debugPrint("getVideoNews categoryId =====> $categoryId");
    loadingSection = true;
    newsModel = await ApiService().videoNews(categoryId);
    debugPrint("getVideoNews status =========> ${newsModel.status}");
    loadingSection = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
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
    if (dataType == "videonews") {
      if ((newsModel.result?[position].isBookmark ?? 0) == 0) {
        newsModel.result?[position].isBookmark = 1;
        Utils.showSnackbar(context, "success", "add_bookmark", true);
      } else {
        newsModel.result?[position].isBookmark = 0;
        Utils.showSnackbar(context, "success", "remove_bookmark", true);
      }
      for (var i = 0; i < (bannerModel.result?.length ?? 0); i++) {
        if (articleID == (bannerModel.result?[i].id.toString())) {
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
      for (var i = 0; i < (newsModel.result?.length ?? 0); i++) {
        if (articleID == (newsModel.result?[i].id.toString())) {
          if ((newsModel.result?[position].isBookmark ?? 0) == 0) {
            newsModel.result?[position].isBookmark = 1;
          } else {
            newsModel.result?[position].isBookmark = 0;
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
    loadingSection = false;
    lastTabPosition = 0;
    loadingBanner = false;
    cBannerIndex = 0;
    newsModel = NewsModel();
    bannerModel = BannerModel();
    successModel = SuccessModel();
  }
}
