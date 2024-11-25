import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../modals/featured_ticeker_res.dart';
import '../modals/home_alert_res.dart';
import '../route/my_app.dart';
import '../utils/constants.dart';
import 'user_provider.dart';

class FeaturedTickerProvider extends ChangeNotifier {
  FeaturedTickerRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  List<HomeAlertsRes>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Extra? _extra;
  Extra? get extra => _extra;
  final AudioPlayer _player = AudioPlayer();

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getFeaturedTicker();
  }

  Future createAlertSend({
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
        _data?.data[index].isAlertAdded = 1;
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
        //
        _data?.data[index].isWatchlistAdded = 1;
        // AmplitudeService.logWatchlistUpdateEvent(
        //   added: true,
        //   symbol: symbol,
        //   companyName: companyName,
        // );
        notifyListeners();

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

  Future getFeaturedTicker({
    showProgress = false,
    loadMore = false,
  }) async {
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
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: Apis.featuredTicker,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = featuredTickerResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _data?.data.addAll(
              featuredTickerResFromJson(jsonEncode(response.data)).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
