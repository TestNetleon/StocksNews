import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TrendingProvider extends ChangeNotifier with AuthProviderBase {
  TrendingRes? _mostBullish;
  TrendingRes? get mostBullish => _mostBullish;

  TrendingRes? _mostBearish;
  TrendingRes? get mostBearish => _mostBearish;
//
  TrendingRes? _trendingStories;
  TrendingRes? get trendingStories => _trendingStories;

  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _statusBullish = Status.ideal;
  Status get statusBullish => _statusBullish;

  Status _statusBearish = Status.ideal;
  Status get statusBearish => _statusBearish;

  Status _statusStories = Status.ideal;
  Status get statusStories => _statusStories;

  bool get isLoadingBullish => _statusBullish == Status.loading;
  bool get isLoadingBearish => _statusBearish == Status.loading;
  bool get isLoadingStories => _statusStories == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  final AudioPlayer _player = AudioPlayer();

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  int selectedIndex = 0;

  List<String> tabs = [
    'Most Bullish',
    'Most Bearish',
    'Trending Sectors',
    'Trending Stories',
    "Trending Industries"
  ];

  // bool selectedOne = false;
  // bool selectedTwo = false;

  // void selectType({int index = 0}) {
  //   if (index == 0) {
  //     selectedOne = !selectedOne;
  //   } else if (index == 1) {
  //     selectedTwo = !selectedTwo;
  //   }
  //   notifyListeners();
  // }

  // void clear() {
  //   selectedOne = false;
  //   selectedTwo = false;
  //   notifyListeners();
  // }

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required bool up,
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
      );
      if (response.status) {
        if (up) {
          //

          _mostBullish?.mostBullish?[index].isAlertAdded = 1;
        } else {
          //
          _mostBearish?.mostBearish?[index].isAlertAdded = 1;
        }
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

      // showErrorMessage(
      //     message: response.message,
      //     type: response.status ? SnackbarType.info : SnackbarType.error);
      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);

      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList(
      {required String symbol, required bool up, required int index}) async {
    setStatus(Status.loading);

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
      );
      if (response.status) {
        if (up) {
          //

          _mostBullish?.mostBullish?[index].isWatchlistAdded = 1;
        } else {
          //
          _mostBearish?.mostBearish?[index].isWatchlistAdded = 1;
        }

        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      // showErrorMessage(
      //     message: response.message,
      //     type: response.status ? SnackbarType.info : SnackbarType.error);

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future refreshData() async {
    getMostBullish(showProgress: true);
    // getTrendingStories();
  }

  Future refreshWithCheck() async {
    if (_mostBullish == null || _mostBullish?.mostBullish?.isEmpty == true) {
      getMostBullish();
    }
    if (_mostBearish == null || _mostBearish?.mostBearish?.isEmpty == true) {
      getMostBearish();
    }
    if (_trendingStories == null ||
        _trendingStories?.generalNews?.isEmpty == true) {
      getTrendingStories();
    }
  }

  Future getMostBullish({showProgress = false}) async {
    // _data = null;
    _statusBullish = Status.loading;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.trendingBullish,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _mostBullish = TrendingRes.fromJson(response.data);
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        // if (_mostBullish?.trendingSymbolList == null ||
        //     _mostBullish?.trendingSymbolList?.isEmpty == true) {
        //   Utils().showLog("---------bullish trending symbol list not found----------");
        // } else {
        //   getMostBearish();
        // }
        // getMostBearish();
      } else {
        _mostBullish = null;
      }
      _statusBullish = Status.loaded;
      notifyListeners();
    } catch (e) {
      _mostBullish = null;

      Utils().showLog(e.toString());
      _statusBullish = Status.loaded;
      notifyListeners();
    }
  }

  Future getMostBearish() async {
    // _data = null;
    _statusBearish = Status.loading;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        'symbols_list': _mostBullish?.trendingSymbolList ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.trendingBearish,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _mostBearish = TrendingRes.fromJson(response.data);
      } else {
        _mostBearish = null;
      }
      _statusBearish = Status.loaded;
      notifyListeners();
    } catch (e) {
      _mostBearish = null;

      Utils().showLog(e.toString());
      _statusBearish = Status.loaded;
      notifyListeners();
    }
  }

  Future getTrendingStories() async {
    // _data = null;
    _statusStories = Status.loading;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.trendingNews,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _trendingStories = TrendingRes.fromJson(response.data);
      } else {
        _trendingStories = null;
      }
      _statusStories = Status.loaded;
      notifyListeners();
    } catch (e) {
      _trendingStories = null;

      Utils().showLog(e.toString());
      _statusStories = Status.loaded;
      notifyListeners();
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
