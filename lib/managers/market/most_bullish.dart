import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/most_bullish.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MostBullishManager extends ChangeNotifier {
  MostBullishRes? _data;
  MostBullishRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  // Status _statusBullish = Status.ideal;
  // Status get statusBullish => _statusBullish;

  bool get isLoadingBullish => _status == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  final AudioPlayer _player = AudioPlayer();

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required String companyName,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
  }) async {
    setStatus(Status.loading);
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
        BrazeService.eventADAlert(symbol: symbol);
        _data?.mostBullish?[index].isAlertAdded = 1;
        await _player.play(
          AssetSource(AudioFiles.alertWeathlist),
        );
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
      setStatus(Status.loaded);
      // return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
    } finally {
      setStatus(Status.loaded);
    }
  }

  Future addToWishList({
    required String symbol,
    required String companyName,
    // required bool up,
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
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        BrazeService.eventADWatchlist(symbol: symbol);
        _data?.mostBullish?[index].isWatchlistAdded = 1;
        await _player.play(AssetSource(AudioFiles.alertWeathlist));
        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      // setStatus(Status.loaded);
      // closeGlobalProgressDialog();
      // return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    } finally {
      closeGlobalProgressDialog();
    }
  }

  Future refreshData() async {
    await getData(showProgress: true);
  }

  Future refreshWithCheck() async {
    if (_data == null || _data?.mostBullish?.isEmpty == true) {
      await getData();
    }
  }

  Future getData({showProgress = false}) async {
    try {
      _error = null;
      setStatus(Status.loading);
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.mostBullish,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _data = mostBullishResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      _data = null;
      _error = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
    // finally {
    //   setStatus(Status.loaded);
    // }
  }
}
