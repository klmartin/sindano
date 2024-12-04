import 'package:SindanoShow/model/newsdetailsmodel.dart';
import 'package:SindanoShow/model/newsmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class NewsDetailsProvider extends ChangeNotifier {
  NewsDetailsModel newsDetailsModel = NewsDetailsModel();
  NewsModel relatedNewsModel = NewsModel();
  NewsModel videoNewsModel = NewsModel();
  NewsModel lastWeekNewsModel = NewsModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false, loadingRelated = false;

  getArticleDetails(articleId) async {
    loading = true;
    newsDetailsModel = await ApiService().articleDetails(articleId);
    debugPrint("getArticleDetails status ======> ${newsDetailsModel.status}");
    loading = false;
    notifyListeners();
  }

  addArticleView(articleId) async {
    successModel = await ApiService().addView(articleId);
    debugPrint("addArticleView status ======> ${successModel.status}");
  }

  updatePurchase() {
    if (newsDetailsModel.result != null) {
      newsDetailsModel.result?[0].isBuy == 1;
    }
    notifyListeners();
  }

  getRelatedNews(categoryId) async {
    loadingRelated = true;
    relatedNewsModel = await ApiService().relatedNews(categoryId);
    debugPrint("getRelatedNews status ======> ${relatedNewsModel.status}");
    loadingRelated = false;
    notifyListeners();
  }

  getVideoNews(categoryId) async {
    debugPrint("getVideoNews categoryId ===========> $categoryId");
    loadingRelated = true;
    videoNewsModel = await ApiService().videoNews(categoryId);
    loadingRelated = false;
    notifyListeners();
  }

  getLastWeekNews(categoryId) async {
    debugPrint("getLastWeekNews categoryId ===========> $categoryId");
    loadingRelated = true;
    lastWeekNewsModel = await ApiService().lastWeekNews(categoryId);
    loadingRelated = false;
    notifyListeners();
  }

  addBookmark(BuildContext context) async {
    debugPrint(
        "addBookmark articleID =======> ${newsDetailsModel.result?[0].id}");
    if ((newsDetailsModel.result?[0].isBookmark ?? 0) == 0) {
      newsDetailsModel.result?[0].isBookmark = 1;
      Utils.showSnackbar(context, "success", "add_bookmark", true);
    } else {
      newsDetailsModel.result?[0].isBookmark = 0;
      Utils.showSnackbar(context, "success", "remove_bookmark", true);
    }
    notifyListeners();
    addRemoveBookmark(newsDetailsModel.result?[0].id ?? 0);
  }

  addRemoveBookmark(articleID) async {
    debugPrint("addToBookmark articleID =======> $articleID");
    successModel = await ApiService().addArticleBookmark(articleID);
    debugPrint("addToBookmark Status ==========> ${successModel.status}");
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    newsDetailsModel = NewsDetailsModel();
    relatedNewsModel = NewsModel();
    videoNewsModel = NewsModel();
    lastWeekNewsModel = NewsModel();
    successModel = SuccessModel();
    loading = false;
    loadingRelated = false;
  }
}
