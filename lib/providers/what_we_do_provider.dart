import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/what_we_do_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../modals/what_wedo_res.dart';

class WhatWeDoProvider extends ChangeNotifier with AuthProviderBase {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;

  Status _statusData = Status.ideal;
  Status get statusData => _statusData;

  bool get isLoading => _status == Status.loading;
  bool get isLoadingData => _statusData == Status.loading;

  String? get error => _error ?? Const.errSomethingWrong;
  int selectedIndex = 0;
  // TermsPolicyRes? _data;
  // TermsPolicyRes? get data => _data;
//

  List<WhatWeDoTabDataRes>? _data;
  List<WhatWeDoTabDataRes>? get data => _data;

  WhatWeDoRes? _res;
  WhatWeDoRes? get res => _res;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void onTapChange(index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
      getWhatWeDOData(slug: _data?[index].slug, showProgress: true);
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
        showProgress: true,
      );

      if (response.status) {
        _data = whatWeDoTabResFromJson(jsonEncode(response.data)).list;
        getWhatWeDOData(slug: _data?[0].slug);
      } else {
        _data = null;
        _error = response.message;
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;

      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getWhatWeDOData({showProgress = true, String? slug}) async {
    _statusData = Status.loading;
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
        _res = whatWeDoResFromJson(jsonEncode(response.data));
      } else {
        _res = null;
        _error = response.message;
      }

      _statusData = Status.loaded;
      notifyListeners();
      return ApiResponse(status: response.status);
    } catch (e) {
      _res = null;
      _error = Const.errSomethingWrong;

      log(e.toString());
      _statusData = Status.loaded;
      notifyListeners();
    }
  }
}
