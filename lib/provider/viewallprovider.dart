import 'package:SindanoShow/model/newsmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class ViewAllProvider extends ChangeNotifier {
  NewsModel newsModel = NewsModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  getTopNews(categoryId) async {
    debugPrint("getTopNews categoryId ===========> $categoryId");
    loading = true;
    newsModel = await ApiService().getTopsNews(categoryId);
    loading = false;
    notifyListeners();
  }

  getRecentNews(categoryId) async {
    debugPrint("getRecentNews categoryId ===========> $categoryId");
    loading = true;
    newsModel = await ApiService().recentNews(categoryId);
    loading = false;
    notifyListeners();
  }

  getNewsByLanguage(categoryId, languageId) async {
    debugPrint("getNewsByLanguage categoryId ===========> $categoryId");
    debugPrint("getNewsByLanguage languageId ===========> $languageId");
    loading = true;
    newsModel = await ApiService().getNewsByLanguageId(categoryId, languageId);
    loading = false;
    notifyListeners();
  }

  getVideoNews(categoryId) async {
    debugPrint("getVideoNews categoryId ===========> $categoryId");
    loading = true;
    newsModel = await ApiService().videoNews(categoryId);
    loading = false;
    notifyListeners();
  }

  getLastWeekNews(categoryId) async {
    debugPrint("getLastWeekNews categoryId ===========> $categoryId");
    loading = true;
    newsModel = await ApiService().lastWeekNews(categoryId);
    loading = false;
    notifyListeners();
  }

  getRelatedNews(categoryId) async {
    debugPrint("getRelatedNews categoryId ===========> $categoryId");
    loading = true;
    newsModel = await ApiService().relatedNews(categoryId);
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  addBookmark(BuildContext context, int position) async {
    debugPrint(
        "addBookmark articleID =======> ${newsModel.result?[position].id}");
    if ((newsModel.result?[position].isBookmark ?? 0) == 0) {
      newsModel.result?[position].isBookmark = 1;
      Utils.showSnackbar(context, "success", "add_bookmark", true);
    } else {
      newsModel.result?[position].isBookmark = 0;
      Utils.showSnackbar(context, "success", "remove_bookmark", true);
    }
    notifyListeners();
    addRemoveBookmark(newsModel.result?[position].id ?? 0);
  }

  addRemoveBookmark(articleID) async {
    debugPrint("addToBookmark articleID =======> $articleID");
    successModel = await ApiService().addArticleBookmark(articleID);
    debugPrint("addToBookmark Status ==========> ${successModel.status}");
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    loading = false;
    newsModel = NewsModel();
    successModel = SuccessModel();
  }
}
