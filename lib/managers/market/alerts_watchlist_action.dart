import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class AlertsWatchlistAction {
  final AudioPlayer _player = AudioPlayer();

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required String companyName,
    required int index,
    required Function() onSuccess,
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
        BrazeService.eventADAlert(symbol: symbol);
        // _data?.mostBullish?[index].isAlertAdded = 1;
        onSuccess();
        await _player.play(
          AssetSource(AudioFiles.alertWeathlist),
        );
        // navigatorKey.currentContext!
        //     .read<HomeProvider>()
        //     .setTotalsAlerts(response.data['total_alerts']);
        // notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
      );
    } catch (e) {
      Utils().showLog(e.toString());
    }
  }

  Future addToWishList({
    required String symbol,
    required String companyName,
    // required bool up,
    required int index,
    required Function() onSuccess,
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
        // _data?.mostBullish?[index].isWatchlistAdded = 1;
        onSuccess();
        await _player.play(AssetSource(AudioFiles.alertWeathlist));
        // navigatorKey.currentContext!
        //     .read<HomeProvider>()
        //     .setTotalsWatchList(response.data['total_watchlist']);
      }
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
      );
    } catch (e) {
      Utils().showLog(e.toString());
    } finally {
      closeGlobalProgressDialog();
    }
  }
}
