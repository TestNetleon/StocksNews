import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/filter_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/highlow_pe_res.dart';

class LowPeProvider extends ChangeNotifier with AuthProviderBase {
  List<HIghLowPeRes>? _data;
  List<HIghLowPeRes>? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;

  int _openIndex = -1;
  int get openIndex => _openIndex;

  bool get isLoading => _status == Status.loading;

  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

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
    getData();
  }

  void exchangeFilter(String item) {
    _filterParams!.exchange_name!.remove(item);
    _page = 1;
    notifyListeners();
    getData();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future getData({showProgress = false, loadMore = false}) async {
    _openIndex = -1;
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
        url: Apis.lowPE,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _extra = (response.extra is Extra ? response.extra as Extra : null);
          _data = hIghLowPeResFromJson(jsonEncode(response.data));
        } else {
          _data?.addAll(hIghLowPeResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _error = response.message;
          _data = null;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
