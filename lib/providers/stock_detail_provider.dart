import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/analysis_res.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
import 'package:stocks_news_new/modals/technical_analysis_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class StockDetailProvider with ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  AnalysisRes? _analysisRes;
  AnalysisRes? get analysisRes => _analysisRes;

  TechnicalAnalysisRes? _technicalAnalysisRes;
  TechnicalAnalysisRes? get technicalAnalysisRes => _technicalAnalysisRes;

  StocksOtherDetailsRes? _otherData;
  StocksOtherDetailsRes? get otherData => _otherData;

  bool analysisLoading = false;
  bool mentionLoading = false;
  bool tALoading = false;
  bool tabLoading = false;
  StockDetailsRes? _data;
  StockDetailsRes? get data => _data;
  StockDetailMentionRes? _dataMentions;
  StockDetailMentionRes? get dataMentions => _dataMentions;

  bool get otherLoading => _status == Status.loading;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

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

  void onTabChanged({
    required int index,
    required String symbol,
    String interval = "5min",
  }) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
      technicalAnalysisData(symbol: symbol, interval: interval, fromTab: true);
    }
  }

  void changeAlert(value) {
    _data?.isAlertAdded = value;
    notifyListeners();
  }

  void changeWatchList(value) {
    _data?.isWatchlistAdded = value;
    notifyListeners();
  }

  // void clear() {
  //   selectedOne = false;
  //   selectedTwo = false;
  //   notifyListeners();
  // }

  Future getStockDetails({required String symbol, loadOther = true}) async {
    _selectedIndex = 0;
    _data = null;
    if (loadOther) setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };
      ApiResponse response = await apiRequest(
        url: Apis.stockDetails,
        request: request,
      );
      if (response.status) {
        _data = stockDetailsResFromJson(jsonEncode(response.data));

        // // Assign random colors to mentions
        // math.Random random = math.Random();
        // _data?.mentions?.forEach((mention) {
        //   // Generate a random color
        //   Color randomColor = Color.fromRGBO(
        //     random.nextInt(256),
        //     random.nextInt(256),
        //     random.nextInt(256),
        //     1,
        //   );
        //   mention.color = randomColor;
        // });
        if (loadOther) {
          getStockDetailsMentions(
            symbol: symbol,
            sectorSlug: _data?.companyInfo?.sectorSlug ?? '',
            price: _data?.keyStats?.priceWithoutCur,
          );
        }
      } else {
        _data = null;
        showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getStockOtherDetails(
      {required String symbol, loadOther = true}) async {
    _otherData = null;

    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };
      ApiResponse response = await apiRequest(
        url: Apis.getOtherData,
        request: request,
      );
      if (response.status) {
        _otherData = stocksOtherDetailsFromJson(jsonEncode(response.data));
      } else {
        _otherData = null;
        showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _otherData = null;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future analysisData({required String symbol}) async {
    _analysisRes = null;
    analysisLoading = true;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.stockAnalysis,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _analysisRes = analysisResFromJson(jsonEncode(response.data));
      } else {
        _analysisRes = null;
      }
      analysisLoading = false;
      notifyListeners();
    } catch (e) {
      _analysisRes = null;
      log(e.toString());
      _error = Const.errSomethingWrong;

      analysisLoading = false;
      notifyListeners();
    }
  }

  Future technicalAnalysisData({
    required String symbol,
    String interval = "5min",
    fromTab = false,
  }) async {
    _technicalAnalysisRes = null;
    if (!fromTab) {
      tALoading = true;
    } else {
      tabLoading = true;
    }

    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        "interval": interval,
      };
      ApiResponse response = await apiRequest(
          url: Apis.technicalAnalysis, request: request, showProgress: false);
      if (response.status) {
        _technicalAnalysisRes =
            technicalAnalysisResFromJson(jsonEncode(response.data));
      } else {
        _technicalAnalysisRes = null;
      }
      if (!fromTab) {
        tALoading = false;
      } else {
        tabLoading = false;
      }
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;

      _technicalAnalysisRes = null;
      log(e.toString());
      if (!fromTab) {
        tALoading = false;
      } else {
        tabLoading = false;
      }
      notifyListeners();
    }
  }

  Future getStockDetailsMentions({
    required String symbol,
    required String sectorSlug,
    required price,
  }) async {
    mentionLoading = true;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
        "sector_slug": sectorSlug,
        "price": "$price"
      };
      ApiResponse response = await apiRequest(
        url: Apis.stockDetailMention,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _dataMentions =
            stockDetailMentionResFromJson(jsonEncode(response.data));
        log("-- Mention log showing in stock provider -> ${_dataMentions?.mentions?.length}");
        // // Assign random colors to mentions
        math.Random random = math.Random();
        _dataMentions?.mentions?.forEach((mention) {
          // Generate a random color
          Color randomColor = Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          );

          mention.color = randomColor;
        });
      } else {
        _data = null;
        showErrorMessage(message: response.message);
      }
      mentionLoading = false;
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;

      _data = null;
      log(e.toString());
      mentionLoading = true;
      notifyListeners();
    }
  }

  Future createAlertSend({
    required String alertName,
    bool selectedOne = false,
    bool selectedTwo = false,
  }) async {
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _data?.keyStats?.symbol ?? "",
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response =
          await apiRequest(url: Apis.createAlert, request: request);
      if (response.status) {
        data?.isAlertAdded = 1;

        // notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);

      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);
      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);

      showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList() async {
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _data?.keyStats?.symbol ?? "",
    };
    try {
      ApiResponse response =
          await apiRequest(url: Apis.addWatchlist, request: request);
      if (response.status) {
        data?.isWatchlistAdded = 1;
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);

      showErrorMessage(message: Const.errSomethingWrong);
    }
  }
}
