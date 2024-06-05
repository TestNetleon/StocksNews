import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/indices_res.dart';
import 'package:stocks_news_new/modals/low_price_stocks_tab.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class IndicesProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status _tabStatus = Status.ideal;
  int selectedIndex = 0;

  List<LowPriceStocksTabRes>? _tabs;

  List<LowPriceStocksTabRes>? get tabs => _tabs;

  List<IndicesRes>? _data;
  List<IndicesRes>? get data => _data;

  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading;
  bool get tabLoading => _tabStatus == Status.loading;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  int _page = 1;
  Extra? _extraUp;
  Extra? get extraUp => _extraUp;

  String? title;
  String? subTitle;
  int _openIndexIndices = -1;
  int get openIndexIndices => _openIndexIndices;
  int _openIndex = -1;
  int get openIndex => _openIndex;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void setOpenIndexIndices(index) {
    _openIndexIndices = index;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void tabChange(index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
      getIndicesData(showProgress: false);
    }
  }

  Future onRefresh() async {
    getTabsData();
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
        url: Apis.exchanageTab,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _tabs = lowPriceStocksTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getIndicesData();
        }
      } else {
        _error = response.message;
        _tabs = null;
        // showErrorMessage(message: response.message);
      }
      setTabStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      _tabs = null;

      Utils().showLog(e.toString());
      setTabStatus(Status.loaded);
    }
  }

  Future onRefreshIndicesData() async {
    getTabsData();
  }

  Future getIndicesData({loadMore = false, showProgress = false}) async {
    setStatus(Status.loading);
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "exchange": _tabs?[selectedIndex].key,
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: Apis.indices,
        request: request,
        showProgress: false,
        onRefresh: onRefreshIndicesData,
      );
      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = indicesResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
          title = response.extra?.title;
          subTitle = response.extra?.subTitle;
        } else {
          _data?.addAll(indicesResFromJson(jsonEncode(response.data)));

          notifyListeners();
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());

      setStatus(Status.loaded);
    }
  }
}
