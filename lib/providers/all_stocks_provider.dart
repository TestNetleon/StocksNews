import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/stocks_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
class AllStocksProvider extends ChangeNotifier {
  StocksRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
  int _openIndex = -1;
  int get openIndex => _openIndex;
  List<AllStocks>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  List<KeyValueElement>? _exchangeShortName;
  List<KeyValueElement>? get exchangeShortName => _exchangeShortName;

  List<KeyValueElement>? _priceRange;
  List<KeyValueElement>? get priceRange => _priceRange;

  Extra? _extra;
  Extra? get extra => _extra;

  String keyPrice = "";
  String keyExchange = "";
  String valuePrice = "";
  String valueExchange = "";
  String valueSearch = "";

  TextEditingController exchangeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final TextEditingController controller = TextEditingController();

  TextRes? _textRes;
  TextRes? get textRes => _textRes;

  // int? get page => _page;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isSearching => _status == Status.searching;

  final AudioPlayer _player = AudioPlayer();

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
        _data?.data?[index].isAlertAdded = 1;
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
        _data?.data?[index].isWatchlistAdded = 1;
        AmplitudeService.logWatchlistUpdateEvent(
          added: true,
          symbol: symbol,
          companyName: companyName,
        );
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void incrementCounter() {
    int currentValue = int.parse(
      controller.text.isEmpty ? "0" : controller.text,
    );

    controller.text = (currentValue + 1).toString();
    notifyListeners();
  }

  void decrementCounter() {
    int currentValue = int.parse(
      controller.text.isEmpty ? "0" : controller.text,
    );

    int lowerLimit = -999;

    if (currentValue > lowerLimit) {
      controller.text = (currentValue - 1).toString();
      notifyListeners();
    }
  }

  void _clearVariables() {
    keyPrice = "";
    keyExchange = "";
    valuePrice = "";
    valueExchange = "";
    valueSearch = "";
    controller.clear();
    exchangeController.clear();
    priceController.clear();
    notifyListeners();
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      controller.text = "";
    }
    notifyListeners();
  }

  void setStatus(status) {
    Utils().showLog("$_status");
    _status = status;
    notifyListeners();
  }

  void open(int index) {
    _openIndex = index;
    notifyListeners();
  }

  void onChangeExchange({KeyValueElement? selectedItem}) {
    keyExchange = selectedItem?.key ?? "";
    valueExchange = selectedItem?.value ?? "";
    Utils().showLog("Key Exchange=> $keyExchange");
    exchangeController.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  void onChangePrice({KeyValueElement? selectedItem}) {
    keyPrice = selectedItem?.key ?? "";
    valuePrice = selectedItem?.value ?? "";
    Utils().showLog("Key Price=> $keyPrice");
    priceController.text = selectedItem?.value ?? "";
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    _clearVariables();
    getData();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
    String? search,
    clear = true,
    inAppMsgId,
  }) async {
    // Utils().showLog("Can load more $canLoadMore");
    if (search != null) {
      valueSearch = search;
      _page = 1;
      setStatus(Status.searching);
    } else if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }

    if (clear) _clearVariables();

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page",
        "search": valueSearch,
        "exchange_short_name": keyExchange,
        "price_range": keyPrice,
        "change_percentage": controller.text,
      };

      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId!});
      }

      ApiResponse response = await apiRequest(
        url: Apis.stocks,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = stocksResFromJson(jsonEncode(response.data));
          if ((_data?.data?.isEmpty ?? false) && isSearching) {
            _error = Const.errNoRecord;
          }
        } else {
          _data?.data
              ?.addAll(stocksResFromJson(jsonEncode(response.data)).data ?? []);
        }

        _exchangeShortName = response.extra?.exchangeShortName;
        _priceRange = response.extra?.priceRange;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
      }
      if (response.extra is! List) {
        _textRes = response.extra?.text;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _data = null;

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  // Future logoutUser(request) async {
  //   try {
  //     ApiResponse res = await apiRequest(
  //       url: Apis.logout,
  //       request: request,
  //       showProgress: true,
  //     );
  //     if (res.status) {
  //       setStatus(Status.loaded);
  //       handleSessionOut();
  //       // showErrorMessage(message: res.message, type: SnackbarType.info);
  //     } else {
  //       setStatus(Status.loaded);
  //       // showErrorMessage(
  //       //   message: res.message,
  //       // );
  //     }
  //   } catch (e) {
  //     setStatus(Status.loaded);
  //     // showErrorMessage(
  //     //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
  //     // );
  //   }
  // }
}
