import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class GapDownProvider extends ChangeNotifier with AuthProviderBase {
  int _openIndex = -1;
  int? get openIndex => _openIndex;

  // ************* GAP DOWN **************** //
  Status _status = Status.ideal;
  List<GapUpRes>? _data;
  String? _error;
  int _page = 1;
  // int? _totalPageDown;

  Extra? _extra;
  Extra? get extra => _extra;

  List<GapUpRes>? get data => _data;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  FilteredParams? _filterParams;
  FilteredParams? get filterParams => _filterParams;

  void resetFilter() {
    _filterParams = null;
    _page = 1;
    notifyListeners();
  }

  void applyFilter(FilteredParams? params) {
    _filterParams = params;
    _page = 1;
    notifyListeners();
    getGapDownStocks();
  }

  void exchangeFilter(String item) {
    _filterParams!.exchange_name!.remove(item);
    if (_filterParams!.exchange_name!.isEmpty) {
      _filterParams!.exchange_name = null;
    }
    _page = 1;
    notifyListeners();
    getGapDownStocks();
  }

  void setStatusDown(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future onRefreshGapDown() async {
    getGapDownStocks();
  }

  Future getGapDownStocks({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusDown(Status.loadingMore);
    } else {
      _page = 1;
      setStatusDown(Status.loading);
    }
    _openIndex = -1;
    // _extraUp = null;
    // _extraDown = null;
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page",
        "exchange_name": _filterParams?.exchange_name?.join(",") ?? "",
        "price": _filterParams?.price ?? "",
        "industry": _filterParams?.industry ?? "",
        "market_cap": _filterParams?.market_cap ?? "",
        "beta": _filterParams?.beta ?? "",
        "dividend": _filterParams?.dividend ?? "",
        "isEtf": _filterParams?.isEtf ?? "",
        "isFund": _filterParams?.isFund ?? "",
        "isActivelyTrading": _filterParams?.isActivelyTrading ?? "",
        "sector": _filterParams?.sector ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.gapDownStocks,
        request: request,
        showProgress: false,
        onRefresh: onRefreshGapDown,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = gapUpResFromJson(jsonEncode(response.data));
          _extra = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(gapUpResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatusDown(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());
      setStatusDown(Status.loaded);
    }
  }
}
