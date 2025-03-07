// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/what_we_do_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/what_wedo_res.dart';

class WhatWeDoProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;

  Status _statusData = Status.ideal;
  Status get statusData => _statusData;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isLoadingData => _statusData == Status.loading;

  String? get error => _error ?? Const.errSomethingWrong;
  int selectedIndex = 0;
  // TermsPolicyRes? _data;
  // TermsPolicyRes? get data => _data;

  List<WhatWeDoTabDataRes>? _data;
  List<WhatWeDoTabDataRes>? get data => _data;

  WhatWeDoRes? _res;
  WhatWeDoRes? get res => _res;

  Map<String, TabsWhatWeDoHolder?> _weDoData = {};
  Map<String, TabsWhatWeDoHolder?> get weDoData => _weDoData;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void onTapChange(index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
      if (_weDoData[data?[selectedIndex].slug]?.data != null ||
          _weDoData[data?[selectedIndex].slug]?.error != null) return;
      // getWhatWeDOData(slug: _data?[index].slug, showProgress: false);
      getWhatWeDODataNew(slug: _data?[index].slug, showProgress: false);
    }
  }

  // List<WeDoClass> tabs = [
  //   WeDoClass(name: "Stock Analysis"),
  //   WeDoClass(name: "Portfolio Tracker"),
  //   WeDoClass(name: "Compare Stocks"),
  //   WeDoClass(name: "Social Sentiments"),
  //   WeDoClass(name: "Trading Stocks"),
  //   WeDoClass(name: "Stock News"),
  //   WeDoClass(name: "Daily Trade Ideas"),
  // ];

  Future onRefresh() async {
    getWhatWeDO();
  }

  Future getWhatWeDO({final bool reset = false}) async {
    if (reset) {
      selectedIndex = 0;
      _data = null;
    }
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.menuWhatWeDo,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _data = whatWeDoTabResFromJson(jsonEncode(response.data)).list;
        // getWhatWeDOData(slug: _data?[0].slug);
        getWhatWeDODataNew(slug: _data?[0].slug);
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getWhatWeDODataNew({
    refreshing = false,
    showProgress = false,
    String? slug,
  }) async {
    _weDoData[slug ?? ""] = TabsWhatWeDoHolder(
      data: null,
      error: null,
      loading: true,
    );

    // _statusData = Status.loading;
    notifyListeners();

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "slug": slug,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.whatWeDo,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        // _res = whatWeDoResFromJson(jsonEncode(response.data));
        _weDoData[slug ?? ""] = TabsWhatWeDoHolder(
          data: whatWeDoResFromJson(jsonEncode(response.data)),
          error: null,
          loading: false,
        );
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        // _res = null;
        _weDoData[slug ?? ""] = TabsWhatWeDoHolder(
          data: null,
          error: response.message,
          loading: false,
        );
        // _error = response.message;
      }

      _statusData = Status.loaded;
      notifyListeners();
      return ApiResponse(status: response.status);
    } catch (e) {
      // _res = null;
      // _error = Const.errSomethingWrong;
      _weDoData[slug ?? ""] = TabsWhatWeDoHolder(
        data: null,
        error: Const.errSomethingWrong,
        loading: false,
      );
      Utils().showLog(e.toString());
      _statusData = Status.loaded;
      notifyListeners();
    }
  }

  // Future getWhatWeDOData({showProgress = true, String? slug}) async {
  //   _statusData = Status.loading;
  //   notifyListeners();
  //   Map request = {
  //     "token":
  //         navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //     "slug": slug,
  //   };
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.whatWeDo,
  //       request: request,
  //       showProgress: showProgress,
  //     );
  //     if (response.status) {
  //       _res = whatWeDoResFromJson(jsonEncode(response.data));
  //     } else {
  //       _res = null;
  //       _error = response.message;
  //     }
  //     _statusData = Status.loaded;
  //     notifyListeners();
  //     return ApiResponse(status: response.status);
  //   } catch (e) {
  //     _res = null;
  //     _error = Const.errSomethingWrong;
  //      Utils().showLog(e.toString());
  //     _statusData = Status.loaded;
  //     notifyListeners();
  //   }
  // }
}

class TabsWhatWeDoHolder {
  WhatWeDoRes? data;
  String? error;
  bool loading;

  TabsWhatWeDoHolder({
    this.data,
    this.loading = true,
    this.error,
  });
}
