import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/check_alert_lock.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class AlertsWatchlistManager extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  CheckAlertLockRes? _checkAlertLock;
  CheckAlertLockRes? get checkAlertLock => _checkAlertLock;

  Future requestAddToAlert({
    required String symbol,
    required request,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        BrazeService.eventADAlert(symbol: symbol);
        await _player.play(
          AssetSource(AudioFiles.alertWeathlist),
        );
      }
      TopSnackbar.show(
        message: response.message ?? "",
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
      return response.status;
    } catch (e) {
      Utils().showLog(e.toString());
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      return false;
    }
  }

  Future requestAddToWishList({
    required String symbol,
    required request,
  }) async {
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );

      if (response.status) {
        BrazeService.eventADWatchlist(symbol: symbol);
        await _player.play(AssetSource(AudioFiles.alertWeathlist));
      }
      TopSnackbar.show(
        message: response.message ?? "",
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
      return response.status;
    } catch (e) {
      Utils().showLog(e.toString());
      return false;
    }
  }

  // Future addToWishList({
  //   required String symbol,
  //   required String companyName,
  //   // required bool up,
  //   required int index,
  //   required Function() onSuccess,
  // }) async {
  //   showGlobalProgressDialog();

  //   Map request = {
  //     "token":
  //         navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //     "symbol": symbol
  //   };

  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.addWatchlist,
  //       request: request,
  //       showProgress: false,
  //       removeForceLogin: true,
  //     );

  //     if (response.status) {
  //       BrazeService.eventADWatchlist(symbol: symbol);
  //       // _data?.mostBullish?[index].isWatchlistAdded = 1;
  //       onSuccess();
  //       await _player.play(AssetSource(AudioFiles.alertWeathlist));
  //       // navigatorKey.currentContext!
  //       //     .read<HomeProvider>()
  //       //     .setTotalsWatchList(response.data['total_watchlist']);
  //     }
  //     showErrorMessage(
  //       message: response.message,
  //       type: response.status ? SnackbarType.info : SnackbarType.error,
  //     );
  //   } catch (e) {
  //     Utils().showLog(e.toString());
  //   } finally {
  //     closeGlobalProgressDialog();
  //   }
  // }

  Future requestAlertLock({required String symbol}) async {
    Map request = {"symbol": symbol};
    try {
      ApiResponse response = await apiRequest(
        url: Apis.checkAlertLock,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        _checkAlertLock = checkAlertLockResFromJson(jsonEncode(response.data));
      } else {
        _checkAlertLock = null;
      }
      notifyListeners();
    } catch (e) {
      _checkAlertLock = null;
      Utils().showLog(e.toString());
    }
  }
}
