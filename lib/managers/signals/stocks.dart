import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/signals/filter.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/lock.dart';
import '../../models/signals/stock.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../user.dart';

class SignalsStocksManager extends ChangeNotifier {
  String? _error;
  String? get error => _error;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  SignalSocksRes? _data;
  SignalSocksRes? get data => _data;

  int _page = 1;
  bool get canLoadMore => _page <= (_data?.totalPages ?? 1);

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _data?.lockInfo;
    return info;
  }

  Future getData({bool loadMore = false, filter = false}) async {
    // if (loadMore) {
    //   _page++;
    //   setStatus(Status.loadingMore);
    // } else {
    //   _page = 1;
    //   setStatus(Status.loading);
    // }

    if (loadMore == false || filter) {
      _page = 1;
    }
    setStatus(loadMore ? Status.loadingMore : Status.loading);

    try {
      Map request = filterRequest != null
          ? {'page': '$_page', ...filterRequest!}
          : {'page': '$_page'};

      ApiResponse response = await apiRequest(
        url: Apis.signalStocks,
        request: request,
      );

      if (response.status) {
        if (_page == 1) {
          _data = signalSocksResFromJson(jsonEncode(response.data));
          _error = null;
          // _lockStocks = _signalSocksData?.lockInfo;
        } else {
          _data?.data?.addAll(
            signalSocksResFromJson(jsonEncode(response.data)).data ?? [],
          );
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
        }
      }
      _page++;
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
    } finally {
      setStatus(Status.loaded);
    }
  }

  void clearAllData() {
    _data = null;
    _filter = null;
    _filterParams = null;
    _filterRequest = null;
    notifyListeners();
  }

  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    if (_data?.data != null) {
      final index =
          _data?.data?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _data?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _data?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
  }

// FILTER : START ---------

  TextEditingController controller = TextEditingController();

  Map? _filterRequest;
  Map? get filterRequest => _filterRequest;

  SignalFilter? _filter;
  SignalFilter? get filter => _filter;

  String? errorFilter;
  String? get filterError => errorFilter;

  Future getFilterData({bool loadMore = false}) async {
    setStatus(Status.loading);

    try {
      Map request = {'type': 'stocks'};

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

  FilterParamsStocks? _filterParams;
  FilterParamsStocks? get filterParams => _filterParams;

  void selectExchange(index) {
    String slug = _filter!.exchange![index].value;
    _filterParams = _filterParams ?? FilterParamsStocks();
    if (filterParams?.exchange != null && _filterParams?.exchange == slug) {
      _filterParams?.exchange = null;
    } else {
      _filterParams?.exchange = slug;
    }
    notifyListeners();
  }

  void selectPriceRange(index) {
    String slug = _filter!.priceRange![index].value;
    _filterParams = _filterParams ?? FilterParamsStocks();
    if (filterParams?.priceRange != null && _filterParams?.priceRange == slug) {
      _filterParams?.priceRange = null;
    } else {
      _filterParams?.priceRange = slug;
    }
    notifyListeners();
  }

  void selectPercentage({value, increment = false, decrement = false}) {
    _filterParams = _filterParams ?? FilterParamsStocks();
    if (value != null) {
      _filterParams?.changePercentage = value;
    } else if (increment) {
      if (_filterParams?.changePercentage == null) {
        _filterParams?.changePercentage = "0";
      } else {
        value = num.tryParse(_filterParams?.changePercentage ?? '0');
        _filterParams?.changePercentage = "${value + 1}";
      }
    } else if (decrement) {
      if (_filterParams?.changePercentage == null) {
        _filterParams?.changePercentage = "0";
      } else {
        value = num.tryParse(_filterParams?.changePercentage ?? '0');
        _filterParams?.changePercentage = "${value - 1}";
      }
    }
    controller.text = _filterParams?.changePercentage ?? "";
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
      request['exchange_name'] = _filterParams?.exchange;
    }
    if (filterParams != null && _filterParams?.priceRange != null) {
      request['price_range'] = _filterParams?.priceRange;
    }
    if (filterParams != null && _filterParams?.changePercentage != null) {
      request['change_percentage'] = _filterParams?.changePercentage;
    }
    _filterRequest = request;
    getData(filter: true);
  }
// FILTER : END ---------
}
