import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/most_bullish.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TrendingViewAllManager extends ChangeNotifier {
  //MARK: Trending
  String? _errorNow;
  String? get errorNow => _errorNow ?? Const.errSomethingWrong;

  Status _statusNow = Status.ideal;
  Status get statusNow => _statusNow;

  bool get isLoadingNow =>
      _statusNow == Status.loading || _statusNow == Status.ideal;

  MarketDataRes? _dataNow;
  MarketDataRes? get dataNow => _dataNow;

  setStatusNow(status) {
    _statusNow = status;
    notifyListeners();
  }

  int _pageNow = 1;
  bool get canLoadMoreNow => (_dataNow?.totalPages ?? 0) >= _pageNow;

  Future getTrendingNow({loadMore = false}) async {
    try {
      setStatusNow(loadMore ? Status.loadingMore : Status.loading);
      if (loadMore == false) {
        _pageNow = 1;
      }

      Map request = {"type": "now", "page": "$_pageNow"};
      ApiResponse response = await apiRequest(
        url: Apis.socialTrending,
        request: request,
      );
      if (response.status) {
        if (_pageNow == 1) {
          _dataNow = marketDataResFromJson(jsonEncode(response.data));
        } else {
          _dataNow!.data!.addAll(
            marketDataResFromJson(jsonEncode(response.data)).data!,
          );
        }
        _pageNow++;

        _errorNow = null;
      } else {
        _dataNow = null;
        _errorNow = response.message;
      }
      setStatusNow(Status.loaded);
    } catch (e) {
      _dataNow = null;
      _errorNow = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
      setStatusNow(Status.loaded);
    }
  }

  //MARK: TopGainers
  String? _errorRecently;
  String? get errorRecently => _errorRecently ?? Const.errSomethingWrong;

  Status _statusRecently = Status.ideal;
  Status get statusRecently => _statusRecently;

  bool get isLoadingRecently =>
      _statusRecently == Status.loading || _statusRecently == Status.ideal;

  MarketDataRes? _dataRecently;
  MarketDataRes? get dataRecently => _dataRecently;

  setStatusRecently(status) {
    _statusRecently = status;
    notifyListeners();
  }

  int _pageRecently = 1;
  bool get canLoadMoreRecently => (_dataNow?.totalPages ?? 0) >= _pageRecently;

  Future getTrendingRecently({loadMore = false}) async {
    try {
      setStatusRecently(loadMore ? Status.loadingMore : Status.loading);
      if (loadMore == false) {
        _pageRecently = 1;
      }
      Map request = {"type": "recently", "page": "$_pageRecently"};
      ApiResponse response = await apiRequest(
        url: Apis.socialTrending,
        request: request,
      );
      if (response.status) {
        if (_pageRecently == 1) {
          _dataRecently = marketDataResFromJson(jsonEncode(response.data));
        } else {
          _dataRecently!.data!.addAll(
            marketDataResFromJson(jsonEncode(response.data)).data!,
          );
        }
        _pageRecently++;
        _errorRecently = null;
      } else {
        _dataRecently = null;
        _errorRecently = response.message;
      }
      setStatusRecently(Status.loaded);
    } catch (e) {
      _dataRecently = null;
      _errorRecently = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
      setStatusRecently(Status.loaded);
    }
  }

  //MARK: TopLosers
  String? _errorByMarketCap;
  String? get errorByMarketCap => _errorByMarketCap ?? Const.errSomethingWrong;

  Status _statusByMarketCap = Status.ideal;
  Status get statusByMarketCap => _statusByMarketCap;

  bool get isLoadingByMarketCap =>
      _statusByMarketCap == Status.loading ||
      _statusByMarketCap == Status.ideal;

  MarketDataRes? _dataByMarketCap;
  MarketDataRes? get dataByMarketCap => _dataByMarketCap;

  setStatusByMarketCap(status) {
    _statusByMarketCap = status;
    notifyListeners();
  }

  Future getTrendingByMarketCap() async {
    try {
      setStatusByMarketCap(Status.loading);
      Map request = {"type": "losers"};
      ApiResponse response = await apiRequest(
        url: Apis.homeTrendingGainerLoser,
        request: request,
      );
      if (response.status) {
        _dataByMarketCap = marketDataResFromJson(jsonEncode(response.data));
        _errorByMarketCap = null;
      } else {
        _dataByMarketCap = null;
        _errorByMarketCap = response.message;
      }
      setStatusByMarketCap(Status.loaded);
    } catch (e) {
      _dataByMarketCap = null;
      _errorByMarketCap = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
      setStatusByMarketCap(Status.loaded);
    }
  }

  //MARK: TopLosers
  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    if (_dataNow?.data != null) {
      final index =
          _dataNow?.data?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataNow?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataNow?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
    if (_dataRecently?.data != null) {
      final index = _dataRecently?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataRecently?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataRecently?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
    if (_dataByMarketCap?.data != null) {
      final index = _dataByMarketCap?.data
          ?.indexWhere((element) => element.symbol == symbol);
      if (index != null && index != -1) {
        if (alertAdded != null) {
          _dataByMarketCap?.data![index].isAlertAdded = alertAdded;
        }
        if (watchListAdded != null) {
          _dataByMarketCap?.data![index].isWatchlistAdded = watchListAdded;
        }
        notifyListeners();
      }
    }
  }
}
