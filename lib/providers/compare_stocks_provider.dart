import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../widgets/custom/alert_popup.dart';
import 'user_provider.dart';

//
class CompareStocksProvider extends ChangeNotifier {
  List<CompareStockRes> _company = [];
  List<CompareStockRes> get company => _company;

  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  TextRes? _textRes;
  TextRes? get textRes => _textRes;

  bool wholeListEmpty = false;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  // void addToCompare({required String symbol}) {
  //   closeKeyboard();

  //   // if (!_company.any((company) => company.symbol == symbol)) {
  //   //   _company.add(CompareCompany(symbol: symbol));
  //   //   navigatorKey.currentContext!.read<SearchProvider>().clearSearch();
  //   //   Navigator.pop(navigatorKey.currentContext!);
  //   // } else {
  //   //   showErrorMessage(message: "Symbol $symbol is already added.");
  //   // }
  //   notifyListeners();
  // }

  // void removeItem({required int index}) {
  //   _company.removeAt(index);
  //   notifyListeners();
  // }

  List<SearchRes> _compareData = [];
  List<SearchRes> get compareData => _compareData;

  void addInCompare({required SearchRes data}) {
    bool symbolExists =
        _compareData.any((element) => element.symbol == data.symbol);
    if (symbolExists) {
      log("exist");
      // Show a Snackbar if the symbol already exists
      popUpAlert(
          message: "Stock already added for comparison.",
          title: "Alert",
          icon: Images.alertPopGIF);
    } else {
      _compareData.add(data);

      notifyListeners();
    }
  }

  removeFromCompare({required int index}) {
    _compareData.removeAt(index);
    notifyListeners();
  }

  Future onRefresh() async {
    getCompareStock();
  }

  Future getCompareStock({showProgress = true}) async {
    _company = [];
    wholeListEmpty = false;
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "default_compare_add": "0",
    };
    try {
      ApiResponse res = await apiRequest(
        url: Apis.compare,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (res.status) {
        _company = compareStockResFromJson(jsonEncode(res.data));
        for (var i = 0; i < company.length; i++) {
          compareData.add(SearchRes(
            symbol: company[i].symbol,
            name: company[i].name,
            image: company[i].image,
          ));
        }
      } else {
        _company = [];
        wholeListEmpty = true;

        // showErrorMessage(message: res.message);
      }
      if (res.extra is List) {
        _textRes = res.extra?.text;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _company = [];
      wholeListEmpty = true;
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }

  Future removeStockItem({required int index}) async {
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": _company[index].symbol,
    };
    try {
      ApiResponse res = await apiRequest(
        url: Apis.deleteCompare,
        request: request,
        showProgress: true,
        onRefresh: onRefresh,
      );
      if (res.status) {
        _company.removeAt(index);
        _compareData.removeAt(index);
        if (_company.isEmpty) {
          wholeListEmpty = true;
          compareData.clear();
          notifyListeners();
        }
      } else {
        // showErrorMessage(message: res.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }

  Future addStockItem({
    required String symbol,
    bool fromNewAdd = false,
    bool fromMain = false,
    String? name,
    String? image,
  }) async {
    log("From Main => $fromMain");
    setStatus(Status.loading);
    SearchProvider provider =
        navigatorKey.currentContext!.read<SearchProvider>();
    provider.clearSearch();
    if (!fromNewAdd) {
      Navigator.pop(navigatorKey.currentContext!);
    }

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse res = await apiRequest(
        url: Apis.addCompare,
        request: request,
        showProgress: _company.isNotEmpty,
        onRefresh: onRefresh,
      );
      if (res.status) {
        if (!_company.any((company) => company.symbol == symbol)) {
          _company = compareStockResFromJson(jsonEncode(res.data));
          if (fromMain) {
            _compareData.add(SearchRes(
              symbol: symbol,
              name: name ?? "",
              image: image,
            ));
          }
          wholeListEmpty = false;

          notifyListeners();
        } else {
          // showErrorMessage(message: "Symbol $symbol is already added.");
        }
      } else {
        // showErrorMessage(message: res.message);
        popUpAlert(
            message: res.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF);
      }
      setStatus(Status.loaded);
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }

  //================================================NEW COMPARE =========================================

  List<CompareStockRes>? _companyNEW = [];
  List<CompareStockRes>? get companyNEW => _companyNEW;

  List<String> tabs = [
    "Overview",
    "Stock Analysis",
    "Earnings",
    "Dividends",
    "Financials"
  ];

  clearStockNew() {
    _companyNEW?.clear();
    notifyListeners();
  }

  deleteItemNew(index) {
    _companyNEW?.removeAt(index);
    notifyListeners();
  }

  void addSTockNew() {
    Utils().showLog("Before${_companyNEW?.length}");
    _companyNEW?.add(CompareStockRes(
      symbol: "AAPL",
      name: "'Apple'",
      image: "",
      price: "123",
      changes: 1,
      changesPercentage: 1,
      dayLow: "dayLow",
      dayHigh: 'dayHigh',
      yearLow: "yearLow",
      yearHigh: "yearHigh",
      mktCap: "mktCap",
      priceAvg50: "priceAvg50",
      priceAvg200: "priceAvg200",
      exchange: "exchange",
      volume: "volume",
      avgVolume: "avgVolume",
      open: 'open',
      previousClose: "previousClose",
      eps: 1,
      pe: 1,
      earningsAnnouncement: "earningsAnnouncement",
      sharesOutstanding: 'sharesOutstanding',
      analystRankingPercent: 1,
      fundamentalPercent: 1,
      longTermPercent: 1,
      overallPercent: 2,
      setimentPercent: 3,
      shortTermPercent: 4,
      valuationPercent: 5,
    ));
    Utils().showLog("After${_companyNEW?.length}");
    notifyListeners();
  }
}

// class CompareNewAddRes {
//   final String symbol;
//   final String image;
//   final String name;
//   CompareNewAddRes({
//     required this.symbol,
//     required this.image,
//     required this.name,
//   });
// }
