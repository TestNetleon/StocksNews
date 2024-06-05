// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/home_portfolio.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import 'user_provider.dart';

class PlaidProvider extends ChangeNotifier {
//Send Plaid PortFolio
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;

  //Get Plaid PortFolio
  String? _errorG;
  String? get errorG => _errorG ?? Const.errSomethingWrong;
  Status _statusG = Status.ideal;
  Status get statusG => _statusG;
  bool get isLoadingG => _statusG == Status.loading;

  // List<PlaidDataRes>? _data;
  // List<PlaidDataRes>? get data => _data;

  //Get Tab PortFolio
  String? _errorT;
  String? get errorT => _errorT ?? Const.errSomethingWrong;
  Status _statusT = Status.ideal;
  Status get statusT => _statusT;
  bool get isLoadingT => _statusT == Status.loading;

  List<String> _tabs = [];
  List<String> get tabs => _tabs;

  Map<String, PlaidTabHolder?> _tabsData = {};
  Map<String, PlaidTabHolder?> get tabsData => _tabsData;

  int selectedTab = 0;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusG(status) {
    _statusG = status;
    notifyListeners();
  }

  void setStatusT(status) {
    _statusT = status;
    notifyListeners();
  }

  void tabChange(index, String? name) {
    if (selectedTab != index) {
      selectedTab = index;
      notifyListeners();
      log("----Name $name-----");
      if (name == null) return;
      if (_tabsData[name]?.data != null || _tabsData[name]?.error != null) {
        log("--returned");
        return;
      }
      getPlaidPortfolioData(name: name);
    }
  }

  Future getTabData() async {
    _tabs = [];
    selectedTab = 0;
    setStatusT(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.plaidPortfolio,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _tabs = homePortfolioTabResFromJson(jsonEncode(response.data));
        if (_tabs.isNotEmpty) {
          getPlaidPortfolioData(name: _tabs[selectedTab]);
        }
      } else {
        //
      }
      setStatusT(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatusT(Status.loaded);
    }
  }

  Future onRefresh() async {
    await getPlaidPortfolioData(name: _tabs[selectedTab], refreshing: true);
  }

  Future getPlaidPortfolioData({
    refreshing = false,
    required String name,
  }) async {
    Utils().showLog("=====NAME $name======");
    // setStatusG(Status.loading);
    if (_tabsData[name]?.data == null || refreshing) {
      _tabsData[name] = PlaidTabHolder(
        data: null,
        error: null,
        loading: true,
      );
    }
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": name,
      });
      ApiResponse response = await apiRequest(
        url: Apis.plaidPortfolio,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        // _data = plaidDataResFromJson(jsonEncode(response.data));
        _tabsData[name] = PlaidTabHolder(
          data: plaidDataResFromJson(jsonEncode(response.data)),
          error: null,
          loading: false,
        );
      } else {
        // _data = null;
        _errorG = response.message;
        _tabsData[name] = PlaidTabHolder(
          data: null,
          error: response.message,
          loading: false,
        );
      }
      setStatusG(Status.loaded);
    } catch (e) {
      // _data = null;
      // _errorG = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusG(Status.loaded);
    }
  }

  Future sendPlaidPortfolio(
      {showProgress = true,
      List<dynamic>? data,
      List<dynamic>? dataAccounts}) async {
    List<dynamic>? jsonArray = data;
    List<dynamic>? jsonArrayAccounts = dataAccounts;

    setStatus(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "securities": jsonArray ?? [],
        "accounts": jsonArrayAccounts ?? [],
      });
      ApiResponse response = await apiRequest(
        url: Apis.savePlaidPortfolio,
        formData: request,
        showProgress: showProgress,
      );
      if (response.status) {
        // getPlaidPortfolioData();
        navigatorKey.currentContext!.read<HomeProvider>().getHomePortfolio();

        // popUpAlert(
        //   message: response.message ?? "Data fetched successfully.",
        //   title: "Alert",
        //   icon: Images.alertPopGIF,
        // );
      } else {
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

class PlaidTabHolder {
  List<PlaidDataRes>? data;
  String? error;
  bool loading;

  PlaidTabHolder({
    this.data,
    this.loading = true,
    this.error,
  });
}
