import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/models/market/industries_res.dart';
import 'package:stocks_news_new/models/market/industries_view_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class IndustriesManager extends ChangeNotifier {
  IndustriesRes? _data;
  IndustriesRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int _page = 1;
  bool get canLoadMore => (_data?.totalPages ?? 0) >= _page;


  IndustriesViewRes? _dataView;
  IndustriesViewRes? get dataView => _dataView;

  bool get canLoadMoreView => (_dataView?.totalPages ?? 0) >= _page;
  Status _statusView = Status.ideal;
  Status get statusView => _statusView;
  bool get isLoadingView => _statusView == Status.loading || _statusView == Status.ideal;


  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusView(status) {
    _statusView = status;
    notifyListeners();
  }

  Future getData({loadMore = false}) async {
    if (loadMore == false) {
      _page = 1;
    }

    try {
      _error = null;
      setStatus(loadMore ? Status.loadingMore : Status.loading);

      final request = {"page": "$_page"};

      ApiResponse response = await apiRequest(
        url: Apis.industries,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _data = industriesResFromJson(jsonEncode(response.data));
          _lockInformation = _data?.lockInfo;
        } else {
          _data!.data!.addAll(
            industriesResFromJson(jsonEncode(response.data)).data!,
          );
        }
        _page++;
      } else {
        _data = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      _data = null;
      _error = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
  }

  Future getViewData(String slug,{loadMore = false}) async {
    if (loadMore == false) {
      _page = 1;
    }
    try {
      _error = null;
      setStatusView(loadMore ? Status.loadingMore : Status.loading);

      final request = {"page": "$_page","slug":slug};

      ApiResponse response = await apiRequest(
        url: Apis.industriesView,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _dataView = industriesViewResFromJson(jsonEncode(response.data));
         // _lockInformation = _data?.lockInfo;
        } else {
          _dataView!.data!.addAll(
            industriesViewResFromJson(jsonEncode(response.data)).data!,
          );
        }
        _page++;
      } else {
        _dataView = null;
        _error = response.message;
      }
      setStatusView(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      _dataView = null;
      _error = Const.errSomethingWrong;
      setStatusView(Status.loaded);
    }
  }

  // void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
  //   if (_data?.data != null) {
  //     final index =
  //         _data?.data?.indexWhere((element) => element.symbol == symbol);
  //     if (index != null && index != -1) {
  //       if (alertAdded != null) {
  //         _data?.data![index].isAlertAdded = alertAdded;
  //       }
  //       if (watchListAdded != null) {
  //         _data?.data![index].isWatchlistAdded = watchListAdded;
  //       }
  //       notifyListeners();
  //     }
  //   }
  // }

  BaseLockInfoRes? _lockInformation;
  BaseLockInfoRes? get lockInformation => _lockInformation;

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _lockInformation;
    return info;
  }
}
