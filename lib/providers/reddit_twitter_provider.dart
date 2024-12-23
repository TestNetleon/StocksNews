import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/reddit_twitter_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../service/braze/service.dart';

class RedditTwitterProvider extends ChangeNotifier {
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
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isSearching => _status == Status.searching;

  bool get daysLoading => _status == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  final AudioPlayer _player = AudioPlayer();

  // bool searching = false;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future createAlertSend({
    String type = "",
    required String alertName,
    required String symbol,
    required String companyName,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
  }) async {
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol,
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        // AmplitudeService.logAlertUpdateEvent(
        //   added: true,
        //   symbol: symbol,
        //   companyName: companyName,
        // );
        BrazeService.eventADAlert(symbol: symbol);

        if (type == "ShowTheLast") {
          _socialSentimentRes?.data[index].isAlertAdded = 1;
        }
        if (type == "Recent") {
          _socialSentimentRes?.recentMentions?[index].isAlertAdded = 1;
        }

        notifyListeners();

        _extra = (response.extra is Extra ? response.extra as Extra : null);
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsAlerts(response.data['total_alerts']);
        notifyListeners();
      }

      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);

      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList({
    String type = "",
    required String symbol,
    required String companyName,
    required bool up,
    required int index,
  }) async {
    showGlobalProgressDialog();

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        // AmplitudeService.logWatchlistUpdateEvent(
        //   added: true,
        //   symbol: symbol,
        //   companyName: companyName,
        // );
        BrazeService.eventADWatchlist(symbol: symbol);

        //
        if (type == "ShowTheLast") {
          _socialSentimentRes?.data[index].isWatchlistAdded = 1;
          notifyListeners();
        }
        if (type == "Recent") {
          _socialSentimentRes?.recentMentions?[index].isWatchlistAdded = 1;
          notifyListeners();
        }

        // _homeTrendingRes?.trending[index].isWatchlistAdded = 1;

        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      closeGlobalProgressDialog();
      return ApiResponse(status: response.status);
    } catch (e) {
      closeGlobalProgressDialog();

      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  List<RtButtons> buttons = [
    RtButtons(name: "X and REDDIT", value: "FinnHub"),
    // RtButtons(name: "StockTwits", value: "Historical"),
    // RtButtons(name: "Both", value: "both"),
  ];

  List<RtShowTheLast> showTheLast = [
    RtShowTheLast(name: "1 DAY", value: "1"),
    RtShowTheLast(name: "3 DAYS", value: "3"),
    RtShowTheLast(name: "5 DAYS", value: "5"),
    // RtShowTheLast(name: "7 DAYS", value: "7"),
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

  Future onRefresh() async {
    clearSearch();
    getRedditTwitterData();
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
        showProgress: showProgress,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _socialSentimentRes =
            socialSentimentsResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
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
      Utils().showLog(e.toString());
      // if (isSearching) searching = false;
      setStatus(Status.loaded);
      _socialSentimentRes = null;

      // showErrorMessage(message: Const.errSomethingWrong);
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
