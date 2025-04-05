import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/signals/filter.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/lock.dart';
import '../../models/signals/politicians.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../user.dart';

class SignalsPoliticianManager extends ChangeNotifier {
  void clearAllData() {
    _data = null;
    _openIndexPolitician = -1;
    _signalPoliticianDetailData = null;
    _openIndexPoliticianDetail == -1;
    _filter = null;
    _filterParams = null;
    _filterRequest = null;
    notifyListeners();
  }

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _data?.lockInfo;
    return info;
  }

  //MARK: Politicians

  String? _error;
  String? get errorPolitician => _error;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;
  bool get canLoadMore => _page <= (_data?.totalPages ?? 1);

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  SignalPoliticiansRes? _data;
  SignalPoliticiansRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  int _openIndexPolitician = -1;
  int get openIndexPolitician => _openIndexPolitician;

  void openMorePolitician(index) {
    EventsService.instance.openClosePoliticiansDataToolsPage();
    _openIndexPolitician = index;
    notifyListeners();
  }

  Future getData({bool loadMore = false, filter = false}) async {
    // if (loadMore) {
    //   _page++;
    //   setStatus(Status.loadingMore);
    // } else {
    //   _page = 1;
    //   openMorePolitician(-1);

    //   setStatus(Status.loading);
    // }

    if (loadMore == false || filter) {
      _page = 1;
      openMorePolitician(-1);
    }

    setStatus(loadMore ? Status.loadingMore : Status.loading);

    try {
      Map request = filterRequest != null
          ? {'page': '$_page', ...filterRequest!}
          : {'page': '$_page'};

      ApiResponse response = await apiRequest(
        url: Apis.signalPoliticians,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _data = signalPoliticiansResFromJson(jsonEncode(response.data));
          _error = null;
          // _lockPoliticians = _data?.lockInfo;
        } else {
          _data?.data?.addAll(
              signalPoliticiansResFromJson(jsonEncode(response.data)).data ??
                  []);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
        }
      }
      _page++;
    } catch (e) {
      _page = 1;
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalPoliticians}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

// FILTER : START ---------

  Map? _filterRequest;
  Map? get filterRequest => _filterRequest;

  SignalFilter? _filter;
  SignalFilter? get filter => _filter;

  String? errorFilter;
  String? get filterError => errorFilter;

  Future getFilterData({bool loadMore = false}) async {
    setStatus(Status.loading);

    try {
      Map request = {'type': 'politician'};
      ApiResponse response = await apiRequest(
        url: Apis.signalFilters,
        request: request,
      );
      if (response.status) {
        _filter = signalFilterResFromJson(jsonEncode(response.data)).filter;
        errorFilter = null;
      } else {
        errorFilter = response.message;
        _filter = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _filter = null;
      errorFilter = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
  }

  FilterParamsPolitician? _filterParams;
  FilterParamsPolitician? get filterParams => _filterParams;

  void selectExchange(index) {
    String slug = _filter!.exchange![index].value;
    _filterParams = _filterParams ?? FilterParamsPolitician();
    if (filterParams?.exchange != null &&
        _filterParams!.exchange!.contains(slug)) {
      _filterParams?.exchange?.remove(slug);
      if (_filterParams!.exchange!.isEmpty) {
        _filterParams?.exchange = null;
      }
    } else {
      _filterParams?.exchange =
          _filterParams?.exchange ?? List.empty(growable: true);
      _filterParams?.exchange?.add(slug);
    }

    notifyListeners();
  }

  void selectSectors(index) {
    String slug = _filter!.sector![index].value;
    _filterParams = _filterParams ?? FilterParamsPolitician();
    if (filterParams?.sectors != null &&
        _filterParams!.sectors!.contains(slug)) {
      _filterParams?.sectors?.remove(slug);
      if (_filterParams!.sectors!.isEmpty) {
        _filterParams?.sectors = null;
      }
    } else {
      _filterParams?.sectors =
          _filterParams?.sectors ?? List.empty(growable: true);
      _filterParams?.sectors?.add(slug);
    }
    notifyListeners();
  }

  void selectIndustry(index) {
    String slug = _filter!.industry![index].value;
    _filterParams = _filterParams ?? FilterParamsPolitician();
    if (filterParams?.industry != null &&
        _filterParams!.industry!.contains(slug)) {
      _filterParams?.industry?.remove(slug);
      if (_filterParams!.industry!.isEmpty) {
        _filterParams?.industry = null;
      }
    } else {
      _filterParams?.industry =
          _filterParams?.industry ?? List.empty(growable: true);
      _filterParams?.industry?.add(slug);
    }
    notifyListeners();
  }

  void selectMarketCap(index) {
    String slug = _filter!.marketCap![index].value;
    _filterParams = _filterParams ?? FilterParamsPolitician();
    if (filterParams?.marketCap != null && _filterParams?.marketCap == slug) {
      _filterParams?.marketCap = null;
    } else {
      _filterParams?.marketCap = slug;
    }

    notifyListeners();
  }

  void selectMarketRank(index) {
    String slug = _filter!.marketRank![index].value;
    _filterParams = _filterParams ?? FilterParamsPolitician();
    if (filterParams?.marketRank != null &&
        _filterParams!.marketRank!.contains(slug)) {
      _filterParams?.marketRank?.remove(slug);
      if (_filterParams!.marketRank!.isEmpty) {
        _filterParams?.marketRank = null;
      }
    } else {
      _filterParams?.marketRank =
          _filterParams?.marketRank ?? List.empty(growable: true);
      _filterParams?.marketRank?.add(slug);
    }
    notifyListeners();
  }

  void selectAnalystConsensus(index) {
    String slug = _filter!.analystConsensus![index].value;
    _filterParams = _filterParams ?? FilterParamsPolitician();
    if (filterParams?.analystConsensus != null &&
        _filterParams!.analystConsensus!.contains(slug)) {
      _filterParams?.analystConsensus?.remove(slug);
      if (_filterParams!.analystConsensus!.isEmpty) {
        _filterParams?.analystConsensus = null;
      }
    } else {
      _filterParams?.analystConsensus =
          _filterParams?.analystConsensus ?? List.empty(growable: true);
      _filterParams?.analystConsensus?.add(slug);
    }
    notifyListeners();
  }

  void resetFilter({apiCallNeeded = true}) {
    _filterRequest = null;
    _filterParams = null;
    notifyListeners();
    if (apiCallNeeded) {
      getData();
    }
  }

  void applyFilter() {
    final request = {};

    if (filterParams != null && _filterParams?.exchange != null) {
      request['exchange_name'] = _filterParams?.exchange?.join(",");
    }
    if (filterParams != null && _filterParams?.sectors != null) {
      request['sector'] = _filterParams?.sectors?.join(",");
    }
    if (filterParams != null && _filterParams?.industry != null) {
      request['industry'] = _filterParams?.industry?.join(",");
    }
    if (filterParams != null && _filterParams?.marketCap != null) {
      request['market_cap'] = _filterParams?.marketCap;
    }
    if (filterParams != null && _filterParams?.marketRank != null) {
      request['marketRank'] = _filterParams?.marketRank?.join(",");
    }
    if (filterParams != null && _filterParams?.analystConsensus != null) {
      request['analystConsensus'] = _filterParams?.analystConsensus?.join(",");
    }
    _filterRequest = request;
    getData(filter: true);
  }
// FILTER : END ---------

  //MARK: Politicians: Detail

  String? _errorPoliticianDetail;
  String? get errorPoliticianDetail => _errorPoliticianDetail;

  Status _statusPoliticianDetail = Status.ideal;
  Status get statusPoliticianDetail => _statusPoliticianDetail;

  int _pagePoliticianDetail = 1;
  bool get canLoadMorePoliticianDetail =>
      _pagePoliticianDetail <= (_signalPoliticianDetailData?.totalPages ?? 1);

  bool get isLoadingPoliticianDetail =>
      _statusPoliticianDetail == Status.loading ||
      _statusPoliticianDetail == Status.ideal;

  SignalPoliticiansRes? _signalPoliticianDetailData;
  SignalPoliticiansRes? get signalPoliticianDetailData =>
      _signalPoliticianDetailData;

  setStatusPoliticianDetail(status) {
    _statusPoliticianDetail = status;
    notifyListeners();
  }

  int _openIndexPoliticianDetail = -1;
  int get openIndexPoliticianDetail => _openIndexPoliticianDetail;

  void openMorePoliticianDetail(index) {
    _openIndexPoliticianDetail = index;
    notifyListeners();
  }

  Future getPoliticianDetailData({
    bool loadMore = false,
    required String userSlug,
  }) async {
    if (loadMore) {
      _pagePoliticianDetail++;
      setStatusPoliticianDetail(Status.loadingMore);
    } else {
      _pagePoliticianDetail = 1;
      openMorePoliticianDetail(-1);
      setStatusPoliticianDetail(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pagePoliticianDetail',
        'user_slug': userSlug,
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalPoliticians,
        request: request,
      );
      if (response.status) {
        if (_pagePoliticianDetail == 1) {
          _signalPoliticianDetailData =
              signalPoliticiansResFromJson(jsonEncode(response.data));
          _errorPoliticianDetail = null;
        } else {
          _signalPoliticianDetailData?.data?.addAll(
              signalPoliticiansResFromJson(jsonEncode(response.data)).data ??
                  []);
        }
      } else {
        if (_pagePoliticianDetail == 1) {
          _signalPoliticianDetailData = null;
          _errorPoliticianDetail = response.message;
        }
      }
    } catch (e) {
      _pagePoliticianDetail = 1;
      _signalPoliticianDetailData = null;
      _errorPoliticianDetail = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalPoliticians}: $e');
    } finally {
      setStatusPoliticianDetail(Status.loaded);
    }
  }

  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    //TODO:
  }
}
