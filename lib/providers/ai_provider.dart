import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/modals/news_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/api_response.dart';
import 'user_provider.dart';

class AIProvider extends ChangeNotifier {
  NewsRes? _data;
  String? _error;
  String? _errorDetail;

  Status _status = Status.ideal;

  Status _detailStatus = Status.ideal;

  int _page = 1;
  int selectedIndex = 0;

  Extra? _extra;
  Extra? get extra => _extra;

  NewsDetailDataRes? _detail;
  NewsDetailDataRes? get detail => _detail;

  List<NewsData>? get data => _data?.data;

  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  String? get errorDetail => _errorDetail ?? Const.errSomethingWrong;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get detailLoading => _detailStatus == Status.loading;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onLoadMore() async {
    await getNews(loadMore: true);
  }

  void setStatusDetail(status) {
    _detailStatus = status;
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    getNews();
  }

  Future getNews({
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
        url: Apis.aiNewsList,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = newsResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _data?.data.addAll(newsResFromJson(jsonEncode(response.data)).data);
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

  Future getNewsDetailData({
    showProgress = false,
    String? slug,
    inAppMsgId,
    notificationId,
    pointsDeducted,
  }) async {
    setStatusDetail(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "slug": slug ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.newsDetails,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _detail = newsDetailDataResFromJson(jsonEncode(response.data));
      } else {
        _detail = null;
        _errorDetail = response.message;
      }
      setStatusDetail(Status.loaded);
    } catch (e) {
      _detail = null;
      _errorDetail = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusDetail(Status.loaded);
    }
  }
}
