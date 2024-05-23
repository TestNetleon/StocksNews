import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/modals/more_stocks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

import '../modals/highlow_pe_res.dart';

class HighLowPeProvider extends ChangeNotifier with AuthProviderBase {
  List<HIghLowPeRes>? _data;
  List<HIghLowPeRes>? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  int _pageUp = 1;
  int _openIndex = -1;

  List<MoreStocksRes>? _dataList;
  List<MoreStocksRes>? get dataList => _dataList;

  bool get isLoading => _status == Status.loading;

  bool canLoadMore = true;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int get openIndex => _openIndex;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future getData(
      {showProgress = false, loadMore = false, required String type}) async {
    log("-------------$type----------");
    _openIndex = -1;
    if (loadMore) {
      _pageUp++;
      setStatus(Status.loadingMore);
    } else {
      _pageUp = 1;
      setStatus(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_pageUp",
      };

      ApiResponse response = await apiRequest(
        url: type == "high" ? Apis.highPE : Apis.lowPE,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _error = null;
        if (_pageUp == 1) {
          canLoadMore = _pageUp < (response.extra.totalPages ?? 1);
          _data = hIghLowPeResFromJson(jsonEncode(response.data));
        } else {
          List<HIghLowPeRes> parsedData = List<HIghLowPeRes>.from(
              (response.data as List).map((x) => HIghLowPeRes.fromJson(x)));
          _data?.addAll(parsedData);
        }
      } else {
        if (_pageUp == 1) {
          _error = response.message;
          _data = null;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }
}
