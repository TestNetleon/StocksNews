import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/sector_graph_res.dart';
import 'package:stocks_news_new/modals/sector_industry_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class SectorIndustryProvider extends ChangeNotifier with AuthProviderBase {
  SectorIndustryRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  SectorIndustryRes? get data => _data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  List<String>? dates;
  List<double>? values;

  Status _isGraphLoading = Status.ideal;
  bool get isGraphLoading => _isGraphLoading == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future sectorGraphData({
    showProgress = false,
    String name = "",
  }) async {
    // setStatus(Status.loading);
    _isGraphLoading = Status.loading;
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "sector": name
      };
      ApiResponse response = await apiRequest(
        url: Apis.sectorChart,
        showProgress: showProgress,
        request: request,
      );
      if (response.status) {
        dates = sectorGraphResFromJson(jsonEncode(response.data)).dates;
        values = sectorGraphResFromJson(jsonEncode(response.data)).values;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        dates = null;
        values = null;
      }

      _isGraphLoading = Status.loaded;
    } catch (e) {
      dates = null;
      values = null;
      Utils().showLog(e.toString());
      // setStatus(Status.loaded);
      _isGraphLoading = Status.loaded;
    }
  }

  Future getStateIndustry({
    showProgress = false,
    loadMore = false,
    required StockStates stockStates,
    required String name,
  }) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    if (stockStates == StockStates.sector && !loadMore) {
      sectorGraphData(name: name);
    }

    try {
      Map request;
      stockStates == StockStates.sector
          ? request = {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_page",
              "sector": name
            }
          : request = {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_page",
              "industry": name
            };

      ApiResponse response = await apiRequest(
        url: stockStates == StockStates.sector ? Apis.sector : Apis.industry,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        if (_page == 1) {
          _data = sectorIndustryResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _data?.data.addAll(
              sectorIndustryResFromJson(jsonEncode(response.data)).data);
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
