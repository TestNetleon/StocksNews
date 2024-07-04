import 'dart:developer';

import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  static final CustomNavigatorObserver _instance =
      CustomNavigatorObserver._internal();
  final List<Route<dynamic>> _stack = [];

  CustomNavigatorObserver._internal();

  factory CustomNavigatorObserver() {
    return _instance;
  }

  int get stackCount => _stack.length;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _stack.add(route);
    debugPrint('Stack count: $stackCount');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _stack.remove(route);
    debugPrint('Stack count: $stackCount');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _stack.remove(route);
    debugPrint('Stack count: $stackCount');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      _stack.remove(oldRoute);
    }
    if (newRoute != null) {
      _stack.add(newRoute);
    }
    debugPrint('Stack count: $stackCount');
  }
}
