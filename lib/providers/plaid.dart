// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

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

  List<PlaidDataRes>? _data;
  List<PlaidDataRes>? get data => _data;

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

  Extra? _extra;
  Extra? get extra => _extra;

  int selectedTab = 0;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusG(status) {
    _statusG = status;
    notifyListeners();
  }

  // void setStatusT(status) {
  //   _statusT = status;
  //   notifyListeners();
  // }

  // void tabChange(index, String? name) {
  //   if (selectedTab != index) {
  //     selectedTab = index;
  //     notifyListeners();
  //     log("----Name $name-----");
  //     if (name == null) return;
  //     if (_tabsData[name]?.data != null || _tabsData[name]?.error != null) {
  //       log("--returned");
  //       return;
  //     }
  //     getPlaidPortfolioData(name: name);
  //   }
  // }

  // Future getTabData() async {
  //   fromDrawer = false;
  //   _tabs = [];
  //   selectedTab = 0;
  //   setStatusT(Status.loading);
  //   try {
  //     FormData request = FormData.fromMap({
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //     });
  //     ApiResponse response = await apiRequest(
  //       url: Apis.plaidPortfolio,
  //       formData: request,
  //       showProgress: false,
  //     );
  //     if (response.status) {
  //       _tabs = homePortfolioTabResFromJson(jsonEncode(response.data));
  //       _extra = (response.extra is Extra ? response.extra as Extra : null);

  //       if (_tabs.isNotEmpty) {
  //         getPlaidPortfolioData(name: _tabs[selectedTab]);
  //       }
  //     } else {
  //       _errorT = response.message;
  //     }
  //     setStatusT(Status.loaded);
  //   } catch (e) {
  //     Utils().showLog(e.toString());
  //     setStatusT(Status.loaded);
  //   }
  // }

  // Future onRefresh() async {
  //   await getPlaidPortfolioData(name: _tabs[selectedTab], refreshing: true);
  // }

  Future onRefresh() async {
    await getPlaidPortfolioDataNew();
  }

  // Future getPlaidPortfolioData({
  //   refreshing = false,
  //   required String name,
  // }) async {
  //   Utils().showLog("=====NAME $name======");
  //   // setStatusG(Status.loading);
  //   if (_tabsData[name]?.data == null || refreshing) {
  //     _tabsData[name] = PlaidTabHolder(
  //       data: null,
  //       error: null,
  //       loading: true,
  //     );
  //   }
  //   try {
  //     FormData request = FormData.fromMap({
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //       "type": name,
  //     });
  //     ApiResponse response = await apiRequest(
  //       url: Apis.plaidPortfolio,
  //       formData: request,
  //       showProgress: false,
  //     );
  //     if (response.status) {
  //       // _data = plaidDataResFromJson(jsonEncode(response.data));
  //       _tabsData[name] = PlaidTabHolder(
  //         data: plaidDataResFromJson(jsonEncode(response.data)),
  //         error: null,
  //         loading: false,
  //       );
  //       _extra = (response.extra is Extra ? response.extra as Extra : null);
  //     } else {
  //       // _data = null;
  //       _errorG = response.message;
  //       _tabsData[name] = PlaidTabHolder(
  //         data: null,
  //         error: response.message,
  //         loading: false,
  //       );
  //     }
  //     // setStatusG(Status.loaded);
  //   } catch (e) {
  //     // _data = null;
  //     // _errorG = Const.errSomethingWrong;
  //     Utils().showLog(e.toString());
  //     // setStatusG(Status.loaded);
  //   }
  // }

  Future sendPlaidPortfolio({
    showProgress = true,
    // List<dynamic>? data,
    // List<dynamic>? dataAccounts,
    // List<dynamic>? holdings,
    required String? accessToken,
  }) async {
    Utils().showLog('-----FROM DRAWER API $fromDrawer------------');
    // List<dynamic>? jsonArray = data;
    // List<dynamic>? jsonArrayAccounts = dataAccounts;
    // List<dynamic>? jsonArrayHoldings = holdings;

    setStatus(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        // "securities": jsonArray ?? [],
        // "accounts": jsonArrayAccounts ?? [],
        // "holdings": jsonArrayHoldings,
        "access_token": accessToken ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.savePlaidPortfolio,
        formData: request,
        showProgress: showProgress,
      );
      if (response.status) {
        // getPlaidPortfolioData();

        if (!fromDrawer) {
          navigatorKey.currentContext!.read<HomeProvider>().getHomePortfolio();

          Navigator.pushNamed(
              navigatorKey.currentContext!, HomePlaidAdded.path);
        } else {
          // getTabData();
          getPlaidPortfolioDataNew();
        }
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

  Future disconnectPlaidAccount() async {
    _data = null;
    HomeProvider provider = navigatorKey.currentContext!.read<HomeProvider>();
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.disconnectPlaid,
        formData: request,
        showProgress: true,
      );
      if (response.status) {
        //
        popUpAlert(
          showOk: false,
          message: response.message ?? "",
          title: "Account Disconnected",
          icon: Images.alertPopGIF,
          canPop: false,
        );
        ApiResponse res = await provider.getHomePortfolio();
        if (res.status) {
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pop(navigatorKey.currentContext!);
        }
      } else {
        //
      }
    } catch (e) {
      _data = null;
      _errorG = Const.errSomethingWrong;
      Utils().showLog(e.toString());
    }
  }

  Future getPlaidPortfolioDataNew() async {
    setStatusG(Status.loading);

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
        _data = plaidDataResFromJson(jsonEncode(response.data));

        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _errorG = response.message;
        _extra = null;
      }
      setStatusG(Status.loaded);
    } catch (e) {
      _data = null;
      _extra = null;

      _errorG = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusG(Status.loaded);
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
