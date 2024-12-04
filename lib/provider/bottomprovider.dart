import 'package:flutter/cupertino.dart';

class BottomProvider extends ChangeNotifier {
  bool _isVisibility = true;

  bool get visibility => _isVisibility;

  void checkVisibility(bool value) {
    _isVisibility = value;
    notifyListeners();
  }
}
