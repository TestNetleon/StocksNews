import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/watchlist_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

class WatchlistProvider extends ChangeNotifier with AuthProviderBase {
  WatchlistRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  Status get status => _status;
  List<WatchlistData>? get data => _data?.data;
  bool get isLoading => _status == Status.loading;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  final AudioPlayer _player = AudioPlayer();

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future onRefresh() async {
    getData();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
  }) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      _data = null;
      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: Apis.watchlist,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = WatchlistRes.fromJson(response.data);
          if (_data!.data.isEmpty) {
            _error = "Your watchlist is currently empty.";
          }
        } else {
          _data?.data.addAll(WatchlistRes.fromJson(response.data).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;

      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future deleteItem(id, String symbol) async {
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "id": "$id"
      };

      ApiResponse response = await apiRequest(
        url: Apis.deleteWatchlist,
        request: request,
        showProgress: true,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _data?.data.removeWhere((element) => element.id == id);
        if (_data?.data == null || _data?.data.isEmpty == true) {
          _error = "Your watchlist is currently empty.";
        }

        String? symbl = navigatorKey.currentContext!
            .read<StockDetailProvider>()
            .data
            ?.keyStats
            ?.symbol;
        if (symbl == symbol) {
          navigatorKey.currentContext!
              .read<StockDetailProvider>()
              .changeWatchList(0);
        }
        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
        // showErrorMessage(message: response.message, type: SnackbarType.info);
      } else {
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future addItem(id) async {
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "id": "$id"
      };

      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
        // showErrorMessage(message: response.message);
      } else {
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
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
