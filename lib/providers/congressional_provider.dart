import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../modals/congressional_res.dart';

class CongressionalProvider extends ChangeNotifier with AuthProviderBase {
  List<CongressionalRes>? _data;
  List<CongressionalRes>? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  int _pageUp = 1;
  int _openIndex = -1;

  bool get isLoading => _status == Status.loading;

  bool canLoadMore = true;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int get openIndex => _openIndex;

  String? title;
  String? subTitle;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future onRefresh() async {
    getData();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
  }) async {
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
        url: Apis.congress,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _error = null;
        canLoadMore = _pageUp < (response.extra.totalPages ?? 1);

        if (_pageUp == 1) {
          title = response.extra?.title;
          subTitle = response.extra?.subTitle;
          _data = congressionalResFromJson(jsonEncode(response.data));
        } else {
          List<CongressionalRes> parsedData = List<CongressionalRes>.from(
              (response.data as List).map((x) => CongressionalRes.fromJson(x)));
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
