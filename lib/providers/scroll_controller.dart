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
      // User is scrolling up
      if (isVisible) {
        isVisible = false;
        notifyListeners(); // Notify listeners when visibility changes
      }
    } else {
      // User is scrolling down
      if (!isVisible) {
        isVisible = true;
        notifyListeners(); // Notify listeners when visibility changes
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }
}
