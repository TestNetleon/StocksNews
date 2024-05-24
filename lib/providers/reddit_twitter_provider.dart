import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/reddit_twitter_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

class RedditTwitterProvider extends ChangeNotifier with AuthProviderBase {
  String? _error;
  Status _status = Status.ideal;
  SocialSentimentsRes? _socialSentimentRes;
  SocialSentimentsRes? get socialSentimentRes => _socialSentimentRes;
//
  int buttonIndex = 0;
  int lastDayIndex = 0;
  String selectedDays = "1";
  String selectedMedia = "FinnHub";
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  bool get isSearching => _status == Status.searching;

  bool get daysLoading => _status == Status.loading;

  // bool searching = false;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  List<RtButtons> buttons = [
    RtButtons(name: "X, Reddit", value: "FinnHub"),
    RtButtons(name: "StockTwits", value: "Historical"),
    RtButtons(name: "Both", value: "both"),
  ];

  List<RtShowTheLast> showTheLast = [
    RtShowTheLast(name: "1 DAY", value: "1"),
    RtShowTheLast(name: "3 DAYS", value: "3"),
    RtShowTheLast(name: "5 DAYS", value: "5"),
    RtShowTheLast(name: "7 DAYS", value: "7"),
    RtShowTheLast(name: "14 DAYS", value: "14"),
  ];

  void onButtonTap({
    required int index,
    required String media,
  }) {
    buttonIndex = index;
    selectedMedia = media;
    notifyListeners();
    getRedditTwitterData();
  }

  void onDaysTap({
    required int index,
    required String days,
  }) {
    lastDayIndex = index;
    selectedDays = days;
    notifyListeners();
    getRedditTwitterData();
  }

  void clearSearch() {
    _status = Status.ideal;
    _socialSentimentRes = null;
    notifyListeners();
  }

  Future getRedditTwitterData({
    String search = "",
    reset = false,
    isSearching = false,
    String allData = "1",
    showProgress = false,
  }) async {
    if (reset) {
      buttonIndex = 0;
      lastDayIndex = 0;
      selectedDays = "1";
      selectedMedia = "FinnHub";
    }
    // if (isSearching) searching = true;
    if (search != "") {
      setStatus(Status.searching);
    } else {
      setStatus(Status.loading);
    }

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "media": selectedMedia,
      "days": selectedDays,
      "search": search,
      "all_data": allData,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.redditTwitter,
        request: request,
        // showProgress: !isSearching,
        showProgress: showProgress,
      );
      if (response.status) {
        _socialSentimentRes =
            socialSentimentsResFromJson(jsonEncode(response.data));
        if (_socialSentimentRes?.data == null ||
            _socialSentimentRes?.data.isEmpty == true) {
          _error = "Social Sentiment is unavailable at this moment.";

          notifyListeners();
        }
        // if (isSearching) searching = false;

        setStatus(Status.loaded);
      } else {
        // _socialSentimentRes = null;
        _error = response.message;
        // if (isSearching) searching = false;

        setStatus(Status.loaded);

        // showErrorMessage(message: response.message, duration: 1);
      }
    } catch (e) {
      log(e.toString());
      // if (isSearching) searching = false;
      setStatus(Status.loaded);
      _socialSentimentRes = null;

      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        // showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(
        //   message: res.message,
        // );
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }
}

class RtButtons {
  String name;
  String value;
  RtButtons({
    required this.name,
    required this.value,
  });
}

class RtShowTheLast {
  String name;
  String value;

  RtShowTheLast({
    required this.name,
    required this.value,
  });
}
