import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/congress_member_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

class CongressionalDetailProvider extends ChangeNotifier {
  CongressMemberRes? _data;
  CongressMemberRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;
  int _openIndex = -1;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  int get openIndex => _openIndex;

  String? title;
  String? subTitle;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  final AudioPlayer _player = AudioPlayer();

  Future createAlertSend({
    required String alertName,
    required String symbol,
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

      data?.tradeLists[index].isAlertAdded = 1;

      notifyListeners();

      _extra = (response.extra is Extra ? response.extra as Extra : null);
      await _player.play(AssetSource(AudioFiles.alertWeathlist));

      navigatorKey.currentContext!
          .read<HomeProvider>()
          .setTotalsAlerts(response.data['total_alerts']);
      notifyListeners();

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
        data?.tradeLists[index].isWatchlistAdded = 1;
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

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void reset() {
    _openIndex = -1;
    _data = null;
    _error = null;
    _extra = null;
    notifyListeners();
  }

  Future onRefresh({slug}) async {
    getData(slug: slug);
  }

  Future getData({
    showProgress = false,
    loadMore = false,
    required slug,
  }) async {
    _openIndex = -1;
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
        "page": "$_page",
        "slug": slug,
      };

      ApiResponse response = await apiRequest(
        url: Apis.congressMember,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _error = null;
        // canLoadMore = _page < (response.extra.totalPages ?? 1);
        _data = congressMemberResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        // if (_page == 1) {
        //   title = response.extra?.title;
        //   subTitle = response.extra?.subTitle;
        //   _data = congressMemberResFromJson(jsonEncode(response.data));
        //   _extra = (response.extra is Extra ? response.extra as Extra : null);
        // } else {
        //   List<CongressionalRes> parsedData = List<CongressionalRes>.from(
        //     (response.data as List).map((x) => CongressionalRes.fromJson(x)),
        //   );
        //   _data?.addAll(parsedData);
        // }
      } else {
        // if (_page == 1) {
        _error = response.message;
        _data = null;
        // }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
