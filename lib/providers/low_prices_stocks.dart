import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/modals/news_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import '../modals/news_tab_category_res.dart';

class LowPriceStocksProvider extends ChangeNotifier {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  Status _tabStatus = Status.ideal;
  int selectedIndex = 0;

  List<LowPriceStocksTabRes>? _tabs;

  List<LowPriceStocksTabRes>? get tabs => _tabs;

  List<NewsData>? get data => _data?.data;
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  bool get tabLoading => _tabStatus == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  void tabChange(index) {
    log("Before--> selected index $selectedIndex, index $index ");
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
      getLowPriceData(showProgress: true);
    }
  }

  Future getTabsData({showProgress = false}) async {
    _tabs == null;
    setTabStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.lowPricesTab,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _tabs = lowPriceStocksTabResFromJson(jsonEncode(response.data));
        // if (_tabs != null) {
        //   getLowPriceData(id: _tabs?[selectedIndex].id);
        // }
      } else {
        _error = response.message;
        _tabs = null;
        // showErrorMessage(message: response.message);
      }
      setTabStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      _tabs = null;

      log(e.toString());
      setTabStatus(Status.loaded);
    }
  }

  void onRefresh() {
    getLowPriceData(
      showProgress: true,
    );
  }

  void onLoadMore() {
    getLowPriceData(loadMore: true);
  }

  Future getLowPriceData({
    showProgress = false,
    loadMore = false,
  }) async {
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "slug": _tabs?[selectedIndex].key,
      };

      ApiResponse response = await apiRequest(
        url: Apis.latestNews,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        _data = newsResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      log(e.toString());

      setStatus(Status.loaded);
    }
  }
}
