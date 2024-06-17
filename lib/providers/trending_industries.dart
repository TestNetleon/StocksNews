import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/trending_industries_graph_res.dart';
import 'package:stocks_news_new/modals/trending_industries_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TrendingIndustriesProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
//
  List<TrendingIndustriesRes>? _data;
  List<TrendingIndustriesRes>? get data => _data;

  List<String>? labels;
  List<int>? totalMentions;
  List<int>? positiveMentions;
  List<int>? negativeMentions;
  List<int>? neutralMentions;

  TextRes? _textRes;
  TextRes? get textRes => _textRes;

  Status _isGraphLoading = Status.ideal;
  bool get isGraphLoading => _isGraphLoading == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getData();
  }

  Future trendingIndustriesGraphData({
    showProgress = false,
  }) async {
    // setStatus(Status.loading);
    _isGraphLoading = Status.loading;

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.trendingIndustryChart,
        showProgress: showProgress,
        request: request,
      );
      if (response.status) {
        labels = trendingIndustriesGraphResFromJson(jsonEncode(response.data))
            .labels;
        totalMentions =
            trendingIndustriesGraphResFromJson(jsonEncode(response.data))
                .totalMentions;
        positiveMentions =
            trendingIndustriesGraphResFromJson(jsonEncode(response.data))
                .positiveMentions;
        negativeMentions =
            trendingIndustriesGraphResFromJson(jsonEncode(response.data))
                .negativeMentions;
        neutralMentions =
            trendingIndustriesGraphResFromJson(jsonEncode(response.data))
                .neutralMentions;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        labels = null;
        totalMentions = null;
        positiveMentions = null;
        negativeMentions = null;
        neutralMentions = null;
      }
      if (response.extra is! List) {
        _textRes = response.extra?.text;
      }
      _isGraphLoading = Status.loaded;
    } catch (e) {
      labels = null;
      totalMentions = null;
      positiveMentions = null;
      negativeMentions = null;
      neutralMentions = null;
      Utils().showLog(e);
      // setStatus(Status.loaded);
      _isGraphLoading = Status.loaded;
    }
  }

  Future getData() async {
    setStatus(Status.loading);
    trendingIndustriesGraphData(); //FewMinutes
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.trendingIndustries,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _data = trendingIndustriesResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
        // showErrorMessage(message: response.message);
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
