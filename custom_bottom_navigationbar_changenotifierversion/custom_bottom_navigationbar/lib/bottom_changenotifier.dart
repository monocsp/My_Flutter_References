import 'package:flutter/material.dart';

class BottomIndexChangeNotifier with ChangeNotifier {
  int _index = 0;
  int get index => _index;

  updateIndex(int updated) {
    // index = updated;
    notifyListeners();
  }
}
