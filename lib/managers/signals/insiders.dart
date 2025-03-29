import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/signals/filter.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../models/lock.dart';
import '../../models/signals/insiders.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../user.dart';

class SignalsInsiderManager extends ChangeNotifier {
  void clearAllData() {
    _data = null;
    _signalInsidersCompanyData = null;
    _openIndexCompany = -1;
    _signalInsidersReportingData = null;
    _openIndexReporting = -1;
    _filter = null;
    _filterParams = null;
    _filterRequest = null;
    notifyListeners();
  }

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _data?.lockInfo;
    return info;
  }

  //MARK: Insiders
  String? _error;
  String? get error => _error;

  Status _status = Status.ideal;
  Status get status => _status;

  int _page = 1;
  bool get canLoadMore => _page <= (_data?.totalPages ?? 1);

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  SignalInsidersRes? _data;
  SignalInsidersRes? get data => _data;

  int _openIndex = -1;
  int get openIndex => _openIndex;

  void openMore(index) {
    _openIndex = index;
    notifyListeners();
  }

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({bool loadMore = false, filter = false}) async {
    if (loadMore == false || filter) {
      _page = 1;
      openMore(-1);
    }

    setStatus(loadMore ? Status.loadingMore : Status.loading);
    // if (loadMore) {
    //   _page++;
    //   setStatus(Status.loadingMore);
    // } else {
    //   _page = 1;
    //   openMore(-1);
    //   setStatus(Status.loading);
    // }
    try {
      Map request = filterRequest != null
          ? {'page': '$_page', ...filterRequest!}
          : {'page': '$_page'};

      ApiResponse response = await apiRequest(
        url: Apis.signalInsiders,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _data = signalInsidersResFromJson(jsonEncode(response.data));
          _error = null;
          // _lockInsiders = _data?.lockInfo;
        } else {
          _data?.data?.addAll(
              signalInsidersResFromJson(jsonEncode(response.data)).data ?? []);
        }
        _page++;
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
        }
      }
    } catch (e) {
      _page = 1;
      _data = null;
      _error = Const.errSomethingWrong;
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
  DateTime _selectedDay = DateTime.now();
  DateTime? get selectedDay => _selectedDay;
  void selectDate(selectedDate) {
    _selectedDay=selectedDate;
    notifyListeners();
  }

  Future getFilterData({bool loadMore = false}) async {
    setStatus(Status.loading);

    try {
      Map request = {'type': 'insider'};
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

  FilterParamsInsider? _filterParams;
  FilterParamsInsider? get filterParams => _filterParams;

  void selectTxnType(index) {
    String slug = _filter!.txnType![index].value;
    _filterParams = _filterParams ?? FilterParamsInsider();
    if (_filterParams?.txnType != null && _filterParams?.txnType == slug) {
      _filterParams?.txnType = null;
    } else {
      _filterParams?.txnType = slug;
    }
    notifyListeners();
  }

  void selectMarketCap(index) {
    String slug = _filter!.marketCap![index].value;
    _filterParams = _filterParams ?? FilterParamsInsider();
    if (filterParams?.marketCap != null && _filterParams?.marketCap == slug) {
      _filterParams?.marketCap = null;
    } else {
      _filterParams?.marketCap = slug;
    }

    notifyListeners();
  }

  void selectSector(index) {
    String slug = _filter!.sector![index].value;
    _filterParams = _filterParams ?? FilterParamsInsider();
    if (filterParams?.sector != null && _filterParams?.sector == slug) {
      _filterParams?.sector = null;
    } else {
      _filterParams?.sector = slug;
    }
    notifyListeners();
  }

  void selectExchange(index) {
    String slug = _filter!.exchange![index].value;
    _filterParams = _filterParams ?? FilterParamsInsider();
    if (filterParams?.exchange != null && _filterParams?.exchange == slug) {
      _filterParams?.exchange = null;
    } else {
      _filterParams?.exchange = slug;
    }
    notifyListeners();
  }

  void selectTxnSize(index) {
    String slug = _filter!.txnSize![index].value;
    _filterParams = _filterParams ?? FilterParamsInsider();
    if (_filterParams?.txnSize != null && _filterParams?.txnSize == slug) {
      _filterParams?.txnSize = null;
    } else {
      _filterParams?.txnSize = slug;
    }
    notifyListeners();
  }

  void selectTxnDate(date) {
    _filterParams = _filterParams ?? FilterParamsInsider();
    _filterParams?.txnDate = date;
    notifyListeners();
  }

  void resetFilter({apiCallNeeded = true}) {
    _filterRequest = null;
    _filterParams = null;
    _selectedDay= DateTime.now();
    notifyListeners();
    if (apiCallNeeded) {
      getData();
    }
  }

  void applyFilter() {
    final request = {};
    if (filterParams != null && _filterParams?.txnType != null) {
      request['txn_type'] = _filterParams?.txnType;
    }
    if (filterParams != null && _filterParams?.marketCap != null) {
      request['market_cap'] = _filterParams?.marketCap;
    }
    if (filterParams != null && _filterParams?.sector != null) {
      request['sector'] = _filterParams?.sector;
    }
    if (filterParams != null && _filterParams?.exchange != null) {
      request['exchange_name'] = _filterParams?.exchange;
    }
    if (filterParams != null && _filterParams?.txnSize != null) {
      request['txn_size'] = _filterParams?.txnSize;
    }
    if (filterParams != null && _filterParams?.txnDate != null) {
      request['txn_date'] = _filterParams?.txnDate;
    }
    _filterRequest = request;
    getData(filter: true);
  }
// FILTER : END ---------

  //MARK: Insiders: Company
  String? _errorInsidersCompany;
  String? get errorInsidersCompany => _errorInsidersCompany;

  Status _statusInsidersCompany = Status.ideal;
  Status get statusInsidersCompany => _statusInsidersCompany;

  int _pageInsidersCompany = 1;
  bool get canLoadMoreInsidersCompany =>
      _pageInsidersCompany <= (_signalInsidersCompanyData?.totalPages ?? 1);

  bool get isLoadingInsidersCompany =>
      _statusInsidersCompany == Status.loading ||
      _statusInsidersCompany == Status.ideal;

  SignalInsidersRes? _signalInsidersCompanyData;
  SignalInsidersRes? get signalInsidersCompanyData =>
      _signalInsidersCompanyData;

  int _openIndexCompany = -1;
  int get openIndexCompany => _openIndexCompany;

  void openMoreCompany(index) {
    _openIndexCompany = index;
    notifyListeners();
  }

  setStatusInsidersCompany(status) {
    _statusInsidersCompany = status;
    notifyListeners();
  }

  Future getInsidersCompanyData(
      {bool loadMore = false, required String cik}) async {
    if (loadMore) {
      _pageInsidersCompany++;
      setStatusInsidersCompany(Status.loadingMore);
    } else {
      _pageInsidersCompany = 1;
      openMoreCompany(-1);
      setStatusInsidersCompany(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pageInsidersCompany',
        'companyCik': cik,
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalInsiders,
        request: request,
      );
      if (response.status) {
        if (_pageInsidersCompany == 1) {
          _signalInsidersCompanyData =
              signalInsidersResFromJson(jsonEncode(response.data));
          _errorInsidersCompany = null;
        } else {
          _signalInsidersCompanyData?.data?.addAll(
              signalInsidersResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_pageInsidersCompany == 1) {
          _signalInsidersCompanyData = null;
          _errorInsidersCompany = response.message;
        }
      }
    } catch (e) {
      _pageInsidersCompany = 1;
      _signalInsidersCompanyData = null;
      _errorInsidersCompany = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalInsiders}: $e');
    } finally {
      setStatusInsidersCompany(Status.loaded);
    }
  }

  //MARK: Insiders: Reporting

  String? _errorInsidersReporting;
  String? get errorInsidersReporting => _errorInsidersReporting;

  Status _statusInsidersReporting = Status.ideal;
  Status get statusInsidersReporting => _statusInsidersReporting;

  int _pageInsidersReporting = 1;
  bool get canLoadMoreInsidersReporting =>
      _pageInsidersReporting <= (_signalInsidersReportingData?.totalPages ?? 1);

  bool get isLoadingInsidersReporting =>
      _statusInsidersReporting == Status.loading ||
      _statusInsidersReporting == Status.ideal;

  SignalInsidersRes? _signalInsidersReportingData;
  SignalInsidersRes? get signalInsidersReportingData =>
      _signalInsidersReportingData;

  int _openIndexReporting = -1;
  int get openIndexReporting => _openIndexReporting;

  void openMoreReporting(index) {
    _openIndexReporting = index;
    notifyListeners();
  }

  setStatusInsidersReporting(status) {
    _statusInsidersReporting = status;
    notifyListeners();
  }

  Future getInsidersReportingData(
      {bool loadMore = false, required String cik}) async {
    if (loadMore) {
      _pageInsidersReporting++;
      setStatusInsidersReporting(Status.loadingMore);
    } else {
      _pageInsidersReporting = 1;
      openMoreReporting(-1);
      setStatusInsidersReporting(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pageInsidersReporting',
        'reportingCik': cik,
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalInsiders,
        request: request,
      );
      if (response.status) {
        if (_pageInsidersReporting == 1) {
          _signalInsidersReportingData =
              signalInsidersResFromJson(jsonEncode(response.data));
          _errorInsidersReporting = null;
        } else {
          _signalInsidersReportingData?.data?.addAll(
              signalInsidersResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_pageInsidersReporting == 1) {
          _signalInsidersReportingData = null;
          _errorInsidersReporting = response.message;
        }
      }
    } catch (e) {
      _pageInsidersReporting = 1;
      _signalInsidersReportingData = null;
      _errorInsidersReporting = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalInsiders}: $e');
    } finally {
      setStatusInsidersReporting(Status.loaded);
    }
  }
}
