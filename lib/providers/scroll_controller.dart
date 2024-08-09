import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollControllerProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;
  bool isVisible = true;

  ScrollControllerProvider() {
    _scrollController.addListener(_scrollListener);
  }
//
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      Timer(Duration(milliseconds: 500), () {
        if (isVisible) {
          isVisible = false;
          notifyListeners();
        }
      });
    } else {
      Timer(Duration(milliseconds: 500), () {
        if (!isVisible) {
          isVisible = true;
          notifyListeners();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }
}
