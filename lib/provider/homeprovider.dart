import 'package:SindanoShow/model/categorymodel.dart';
import 'package:SindanoShow/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  CategoryModel categoryModel = CategoryModel();

  bool loading = false;
  int selectedIndex = 0;
  String currentPage = "";

  getCategory() async {
    loading = true;
    categoryModel = await ApiService().categoryList();
    debugPrint("getCategory status ======> ${categoryModel.status}");
    loading = false;
    notifyListeners();
  }

  setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  setSelectedTab(position) {
    selectedIndex = position;
    notifyListeners();
  }

  setCurrentPage(String pageName) {
    currentPage = pageName;
    notifyListeners();
  }

  homeNotifyProvider() {
    notifyListeners();
  }

  clearProvider() {
    debugPrint("<================ clearProvider ================>");
    categoryModel = CategoryModel();
    loading = false;
    selectedIndex = 0;
    currentPage = "";
  }
}
