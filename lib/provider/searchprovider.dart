import 'package:SindanoShow/model/searchmodel.dart';
import 'package:SindanoShow/model/successmodel.dart';
import 'package:SindanoShow/utils/utils.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  SearchModel searchModel = SearchModel();
  SuccessModel successModel = SuccessModel();

  bool loading = false;

  Future<void> getSearchResult(searchText) async {
    debugPrint("getSearchResult searchText :==> $searchText");
    loading = true;
    searchModel = await ApiService().searchArticle(searchText);
    debugPrint("getSearchResult status :==> ${searchModel.status}");
    debugPrint("getSearchResult message :==> ${searchModel.message}");
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    debugPrint("setDataVisibility isLoading :==> $isLoading");
    loading = isLoading;
    notifyListeners();
  }

  notifyProvider() {
    notifyListeners();
  }

  addBookmark(BuildContext context, int position) async {
    debugPrint(
        "addBookmark articleID =======> ${searchModel.result?[position].id}");
    if ((searchModel.result?[position].isBookmark ?? 0) == 0) {
      searchModel.result?[position].isBookmark = 1;
      Utils.showSnackbar(context, "success", "add_bookmark", true);
    } else {
      searchModel.result?[position].isBookmark = 0;
      Utils.showSnackbar(context, "success", "remove_bookmark", true);
    }
    notifyListeners();
    addRemoveBookmark(searchModel.result?[position].id ?? 0);
  }

  addRemoveBookmark(articleID) async {
    debugPrint("addToBookmark articleID =======> $articleID");
    successModel = await ApiService().addArticleBookmark(articleID);
    debugPrint("addToBookmark Status ==========> ${successModel.status}");
  }

  clearProvider() {
    debugPrint("============ clearSearchProvider ============");
    searchModel = SearchModel();
    loading = false;
    successModel = SuccessModel();
  }
}
