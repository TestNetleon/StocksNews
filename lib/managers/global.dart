import 'package:flutter/material.dart';

class GlobalManager extends ChangeNotifier{
  int _openIndex = 0;
  int get openIndex => _openIndex;

  void change(int index) {
    _openIndex = index;
    notifyListeners();
  }
}