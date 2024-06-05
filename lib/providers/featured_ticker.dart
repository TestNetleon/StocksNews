import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../modals/featured_ticeker_res.dart';
import '../modals/home_alert_res.dart';
import '../route/my_app.dart';
import '../utils/constants.dart';
import 'user_provider.dart';

class FeaturedTickerProvider extends ChangeNotifier {
  FeaturedTickerRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  List<HomeAlertsRes>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getFeaturedTicker();
  }

  Future getFeaturedTicker({
    showProgress = false,
    loadMore = false,
  }) async {
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
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: Apis.featuredTicker,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = featuredTickerResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.addAll(
              featuredTickerResFromJson(jsonEncode(response.data)).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
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
