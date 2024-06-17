import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/fifty_two_weeks_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FiftyTwoWeeksProvider extends ChangeNotifier with AuthProviderBase {
  Status _status = Status.ideal;
  // ************* GAP DOWN **************** //
  List<FiftyTwoWeeksRes>? _data;
  String? _error;
  int _page = 1;
  Extra? _extraUp;

  List<FiftyTwoWeeksRes>? get data => _data;
  Extra? get extraUp => _extraUp;
  bool get canLoadMore => _page < (_extraUp?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  // ************* GAP DOWN **************** //
  List<FiftyTwoWeeksRes>? _dataLows;
  String? _errorDown;
  int _pageDown = 1;
  // int? _totalPageDown;
  Extra? _extraDown;

  List<FiftyTwoWeeksRes>? get dataLows => _dataLows;
  bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;
  bool get isLoadingDown => _status == Status.loading;
  Status _statusFiftyTwoWeeks = Status.ideal;
  Status get statusFiftyTwoWeeks => _statusFiftyTwoWeeks;
  bool get isLoadingFiftyTwoWeeks => _statusFiftyTwoWeeks == Status.loading;
  int get openIndexFiftyTwoWeeks => _openIndexFiftyTwoWeeks;
  int _openIndexFiftyTwoWeeks = -1;
  int _openIndex = -1;

  int get openIndex => _openIndex;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusFiftyTwoWeeks(status) {
    _statusFiftyTwoWeeks = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexFiftyTwoWeeks(index) {
    _openIndexFiftyTwoWeeks = index;
    notifyListeners();
  }

  // void setStatusLosers(status) {
  //   _status = status;
  //   notifyListeners();
  // }
  // void setOpenIndex(index) {
  //   // _openIndex = index;
  //   notifyListeners();
  // }
  // void setOpenIndexLosers(index) {
  //   // _openIndexLosers = index;
  //   notifyListeners();
  // }

  Future getFiftyTwoWeekHigh({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {"page": "$_page"};

      ApiResponse response = await apiRequest(
        url: Apis.weekHighs,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = fiftyTwoWeeksResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _data?.addAll(fiftyTwoWeeksResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getFiftyTwoWeekLows({loadMore = false}) async {
    if (loadMore) {
      _pageDown++;
      setStatus(Status.loadingMore);
    } else {
      _pageDown = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {"page": "$_pageDown"};

      ApiResponse response = await apiRequest(
        url: Apis.weekLows,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _errorDown = null;
        if (_pageDown == 1) {
          _dataLows = fiftyTwoWeeksResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _dataLows
              ?.addAll(fiftyTwoWeeksResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_pageDown == 1) {
          _dataLows = null;
          _errorDown = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _dataLows = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
