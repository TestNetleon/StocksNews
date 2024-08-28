import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/watchlist_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';

import '../../api/api_response.dart';
import '../../modals/msAnalysis/radar_chart.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../user_provider.dart';

class MSAnalysisProvider extends ChangeNotifier {
  String? _errorRadar;
  String? get errorRadar => _errorRadar ?? Const.errSomethingWrong;

  Status _statusRadar = Status.ideal;
  Status get statusRadar => _statusRadar;

  bool get isLoadingRadar => _statusRadar == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  List<MsRadarChartRes>? _radar;
  List<MsRadarChartRes>? get radar => _radar;

  void setStatus(status) {
    _statusRadar = status;
    notifyListeners();
  }

  callAPIs() {
    getRadarChartData();
    navigatorKey.currentContext!.read<WatchlistProvider>().getData(
          loadMore: false,
          showProgress: false,
        );
  }

  Future getRadarChartData() async {
    setStatus(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msRadarChart,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        _radar = msRadarChartResFromJson(jsonEncode(response.data));
        _errorRadar = null;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _radar = null;
        _errorRadar = response.message;
        _extra = null;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _radar = null;
      _extra = null;
      _errorRadar = Const.errSomethingWrong;
      setStatus(Status.loaded);
      Utils().showLog(e.toString());
    }
  }
}
