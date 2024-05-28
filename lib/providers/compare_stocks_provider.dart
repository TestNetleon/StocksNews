import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/providers/search_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

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
      "default_compare_add": "1",
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
        if (_company.isEmpty) {
          wholeListEmpty = true;
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

  Future addStockItem({required int index, required String symbol}) async {
    setStatus(Status.loading);
    SearchProvider provider =
        navigatorKey.currentContext!.read<SearchProvider>();
    provider.clearSearch();
    Navigator.pop(navigatorKey.currentContext!);
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse res = await apiRequest(
        url: Apis.addCompare,
        request: request,
        showProgress: true,
        onRefresh: onRefresh,
      );
      if (res.status) {
        if (!_company.any((company) => company.symbol == symbol)) {
          _company = compareStockResFromJson(jsonEncode(res.data));
          wholeListEmpty = false;
//           _company.add(CompareStockRes(
//             symbol: symbol,
//             image: res.data["image"],
//             name: res.data["name"],
//           ));
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
}
