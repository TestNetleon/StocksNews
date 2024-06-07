import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/highlow_pe_res.dart';

class HighLowPeProvider extends ChangeNotifier with AuthProviderBase {
  List<HIghLowPeRes>? _data;
  List<HIghLowPeRes>? get data => _data;

  List<HIghLowPeRes>? _dataHighPERatio;
  List<HIghLowPeRes>? get dataHighPERatio => _dataHighPERatio;

  List<HIghLowPeRes>? _dataLowPERatio;
  List<HIghLowPeRes>? get dataLowPERatio => _dataLowPERatio;

  List<HIghLowPeRes>? _dataHighPEGrowth;
  List<HIghLowPeRes>? get dataHighPEGrowth => _dataHighPEGrowth;

  Status _status = Status.ideal;
  Status get status => _status;

  int _pageUp = 1;
  int _openIndex = -1;

  // List<MoreStocksRes>? _dataList;
  // List<MoreStocksRes>? get dataList => _dataList;

  bool get isLoading => _status == Status.loading;
  bool canLoadMore = true;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int get openIndex => _openIndex;
  String? title;
  String? subTitle;
  String? _type;
  String? get type => _type;

  Extra? _extra;
  Extra? get extra => _extra;

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
        url: type == "high"
            ? Apis.highPE
            : type == "low"
                ? Apis.lowPE
                : type == "highGrowth"
                    ? Apis.highPEGrowth
                    : Apis.lowPEGrowth,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _error = null;
        canLoadMore = _pageUp < (response.extra.totalPages ?? 1);
        if (_pageUp == 1) {
          _extra = (response.extra is Extra ? response.extra as Extra : null);
          title = response.extra?.title;
          subTitle = response.extra?.subTitle;
          type == "high"
              ? _dataHighPERatio =
                  hIghLowPeResFromJson(jsonEncode(response.data))
              : type == "low"
                  ? _dataLowPERatio =
                      hIghLowPeResFromJson(jsonEncode(response.data))
                  : type == "highGrowth"
                      ? _dataHighPEGrowth =
                          hIghLowPeResFromJson(jsonEncode(response.data))
                      : _data = hIghLowPeResFromJson(jsonEncode(response.data));
        } else {
          // List<HIghLowPeRes> parsedData = List<HIghLowPeRes>.from(
          //     (response.data as List).map((x) => HIghLowPeRes.fromJson(x)));
          // _data?.addAll(parsedData);
          type == "high"
              ? _dataHighPERatio
                  ?.addAll(hIghLowPeResFromJson(jsonEncode(response.data)))
              : type == "low"
                  ? _dataLowPERatio
                      ?.addAll(hIghLowPeResFromJson(jsonEncode(response.data)))
                  : type == "highGrowth"
                      ? _dataHighPEGrowth?.addAll(
                          hIghLowPeResFromJson(jsonEncode(response.data)))
                      : _data?.addAll(
                          hIghLowPeResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_pageUp == 1) {
          _error = response.message;
          type == "high"
              ? _dataHighPERatio = null
              : type == "low"
                  ? _dataLowPERatio = null
                  : type == "highGrowth"
                      ? _dataHighPEGrowth = null
                      : _data = null;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      type == "high"
          ? _dataHighPERatio = null
          : type == "low"
              ? _dataLowPERatio = null
              : type == "highGrowth"
                  ? _dataHighPEGrowth = null
                  : _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
