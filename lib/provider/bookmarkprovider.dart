import 'package:Sindano/model/newsmodel.dart';
import 'package:Sindano/model/successmodel.dart';
import 'package:Sindano/utils/utils.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class BookMarkProvider extends ChangeNotifier {
  NewsModel newsModel = NewsModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  getBookmarkList() async {
    loading = true;
    newsModel = await ApiService().getBookmarkArticle();
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  addBookmark(BuildContext context, int position) async {
    int? itemId = newsModel.result?[position].id;
    debugPrint("addBookmark itemId =======> $itemId");
    newsModel.result?.removeAt(position);
    Utils.showSnackbar(context, "success", "remove_bookmark", true);
    notifyListeners();
    addRemoveBookmark(itemId ?? 0);
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
