import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/terms_policy_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

class WhatWeDoProvider extends ChangeNotifier with AuthProviderBase {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  int selectedIndex = 0;
  TermsPolicyRes? _data;
  TermsPolicyRes? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void onTapChange(index) {
    selectedIndex = index;
    notifyListeners();
    getWhatWeDO(type: "disclaimer");
  }

  List<WeDoClass> tabs = [
    WeDoClass(name: "Stock Analysis"),
    WeDoClass(name: "Portfolio Tracker"),
    WeDoClass(name: "Compare Stocks"),
    WeDoClass(name: "Social Sentiments"),
    WeDoClass(name: "Trading Stocks"),
    WeDoClass(name: "Stock News"),
    WeDoClass(name: "Daily Trade Ideas"),
  ];

  Future getWhatWeDO({required String type, final bool reset = false}) async {
    if (reset) {
      selectedIndex = 0;
      _data = null;
    }
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "slug": "disclaimer",
    };
    try {
      ApiResponse response =
          await apiRequest(url: Apis.infoPage, request: request);

      if (response.status) {
        _data = termsPolicyResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;

      log(e.toString());
      setStatus(Status.loaded);
    }
  }
}

class WeDoClass {
  final String? image;
  final String name;
  WeDoClass(
      {this.image =
          "https://img.freepik.com/free-photo/golden-frame-blue-background_53876-92990.jpg?w=740&t=st=1713791024~exp=1713791624~hmac=352e8d5a9a78dc5de2d2d0acfd3296aa4a05597ff34d9efe6fc7968a1f9e54e9",
      required this.name});
}
