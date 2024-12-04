import 'package:SindanoShow/model/newsmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class LanguageSectionProvider extends ChangeNotifier {
  NewsModel languageNewsModel = NewsModel();
  SuccessModel successModel = SuccessModel();

  String currentPage = "";

  bool loadingSection = false;
  int? lastTabPosition;

  getNewsByLanguage(categoryId, languageId) async {
    debugPrint("getNewsByLanguage categoryId ===========> $categoryId");
    debugPrint("getNewsByLanguage languageId ===========> $languageId");
    loadingSection = true;
    languageNewsModel =
        await ApiService().getNewsByLanguageId(categoryId, languageId);
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

  addRemoveBookmark(articleID) async {
    debugPrint("addToBookmark articleID =======> $articleID");
    successModel = await ApiService().addArticleBookmark(articleID);
    debugPrint("addToBookmark Status ==========> ${successModel.status}");
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    loadingSection = false;
    languageNewsModel = NewsModel();
    successModel = SuccessModel();
    lastTabPosition = 0;
  }
}
