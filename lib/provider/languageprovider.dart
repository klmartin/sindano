import 'package:Sindano/model/languagemodel.dart';
import 'package:Sindano/webservices/apiservices.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageModel languageModel = LanguageModel();

  bool loading = false;
  int selectedIndex = 0;
  String currentPage = "";

  getLanguage() async {
    loading = true;
    languageModel = await ApiService().getAllLanguages();
    debugPrint("getLanguage status ======> ${languageModel.status}");
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
    languageModel = LanguageModel();
    loading = false;
    selectedIndex = 0;
    currentPage = "";
  }
}
