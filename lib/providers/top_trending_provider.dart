import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import 'home_provider.dart';

class TopTrendingProvider extends ChangeNotifier {
  TopTrendingRes? _res;
  TopTrendingRes? get res => _res;

  List<TopTrendingDataRes>? get data => _res?.data;
//
  List<TopTrendingDataRes>? _capData;
  List<TopTrendingDataRes>? get capData => _capData;

  List<TopTrendingDataRes>? get megaCap =>
      _capData?.where((data) => data.cap == "mega").toList();

  List<TopTrendingDataRes>? get largeCap =>
      _capData?.where((data) => data.cap == "large").toList();

  List<TopTrendingDataRes>? get mediumCap =>
      _capData?.where((data) => data.cap == "medium").toList();

  List<TopTrendingDataRes>? get smallCap =>
      _capData?.where((data) => data.cap == "small").toList();

  List<TopTrendingDataRes>? get microCap =>
      _capData?.where((data) => data.cap == "micro").toList();

  List<TopTrendingDataRes>? get nanoCap =>
      _capData?.where((data) => data.cap == "nano").toList();

  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
  int _openIndex = -1;

  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get canLoadMore => _page < (_res?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  int get openIndex => _openIndex;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Status _addLoading = Status.ideal;
  bool get addLoading => _addLoading == Status.loading;

  final AudioPlayer _player = AudioPlayer();

  TextRes? _textTop;
  TextRes? get textTop => _textTop;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setAdd(status) {
    _addLoading = status;
    notifyListeners();
  }

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
  }) async {
    setAdd(Status.loading);
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
        if (_selectedIndex == 0 || _selectedIndex == 1) {
          data?[index].isAlertAdded = 1;
        } else if (_selectedIndex == 2) {
          _capData
              ?.where((element) =>
                  element.symbol == symbol && element.isAlertAdded == 0)
              .forEach((element) {
            element.isAlertAdded = 1;
          });
        }
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
      setAdd(Status.loaded);

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      setAdd(Status.loaded);
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList({
    required String symbol,
    required int index,
  }) async {
    setAdd(Status.loading);
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
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        if (_selectedIndex == 0 || _selectedIndex == 1) {
          data?[index].isWatchlistAdded = 1;
        } else if (_selectedIndex == 2) {
          _capData
              ?.where((element) =>
                  element.symbol == symbol && element.isWatchlistAdded == 0)
              .forEach((element) {
            element.isWatchlistAdded = 1;
          });
        }
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);

        notifyListeners();
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);
      setAdd(Status.loaded);
      closeGlobalProgressDialog();

      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      setAdd(Status.loaded);
      closeGlobalProgressDialog();

      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  void onTabChanged({
    required int index,
    bool loadMore = false,
    bool showProgress = false,
  }) {
    if (_selectedIndex != index) {
      _selectedIndex = index;

      notifyListeners();
      if (index == 2) {
        getCapData(showProgress: showProgress);
      } else {
        getNowRecentlyData(
          type: index == 0
              ? "now"
              : index == 1
                  ? "recently"
                  : "cap",
          loadMore: loadMore,
          showProgress: showProgress,
        );
      }
    }
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future getNowRecentlyData({
    showProgress = false,
    loadMore = false,
    reset = false,
    required String type,
  }) async {
    if (reset) {
      _selectedIndex = 0;
      _page = 1;
    }

    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;

      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": type,
        "page": "$_page",
      };

      ApiResponse response = await apiRequest(
        url: Apis.socialTrending,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _res = topTrendingResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _res?.data?.addAll(TopTrendingRes.fromJson(response.data).data ?? []);
        }
        if (type == "now") {
          if (response.extra is! List) {
            _textTop = response.extra?.text;
          }
        }
      } else {
        if (_page == 1) {
          _error = response.message;
          _res = null;
        }
        if (type == "now") {
          if (response.extra is! List) {
            _textTop = response.extra?.text;
          }
        }
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      _res = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
      return ApiResponse(status: false);
    }
  }

  Future getCapData({showProgress = false, fromAddTo = false}) async {
    if (!fromAddTo) {
      setStatus(Status.loading);
    } else {
      setAdd(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": "cap",
      };

      ApiResponse response = await apiRequest(
        url: Apis.socialTrending,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _capData = topTrendingResFromJson(jsonEncode(response.data)).data;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _capData = null;
        _error = response.message;
        // showErrorMessage(message: response.message);
      }
      if (!fromAddTo) {
        setStatus(Status.loaded);
      } else {
        setAdd(Status.loaded);
      }

      return ApiResponse(status: response.status);
    } catch (e) {
      _capData = null;
      _error = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      if (!fromAddTo) {
        setStatus(Status.loaded);
      } else {
        setAdd(Status.loaded);
      }
      return ApiResponse(status: false);
    }
  }
}
