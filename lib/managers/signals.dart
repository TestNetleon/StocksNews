import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../models/market/market_res.dart';
import '../models/signals/sentiment.dart';
import '../models/signals/stock.dart';
import '../routes/my_app.dart';
import '../utils/constants.dart';
import 'user.dart';

class SignalsManager extends ChangeNotifier {
  //MARK: Signals

  List<MarketResData> tabs = [
    MarketResData(title: 'Stocks'),
    MarketResData(title: 'Sentiment'),
    MarketResData(title: 'Insiders'),
    MarketResData(title: 'Politicians'),
  ];

  int? selectedScreen;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      switch (selectedScreen) {
        case 0:
          getStocksData();
          break;

        case 1:
          getSignalSentimentData();
          break;

        default:
      }
    }
  }

//MARK: Stocks
  String? _errorStocks;
  String? get errorStocks => _errorStocks;

  Status _statusStocks = Status.ideal;
  Status get statusStocks => _statusStocks;

  bool get isLoadingStocks =>
      _statusStocks == Status.loading || _statusStocks == Status.ideal;

  SignalSocksRes? _signalSocksData;
  SignalSocksRes? get signalSocksData => _signalSocksData;

  int _page = 1;
  bool get canLoadMoreStocks => _page <= (_signalSocksData?.totalPages ?? 1);

  setStatusStocks(status) {
    _statusStocks = status;
    notifyListeners();
  }

  Future getStocksData({bool loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusStocks(Status.loadingMore);
    } else {
      _page = 1;
      setStatusStocks(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_page',
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalStocks,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _signalSocksData = signalSocksResFromJson(jsonEncode(response.data));
          _errorStocks = null;
        } else {
          _signalSocksData?.data?.addAll(
              signalSocksResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_page == 1) {
          _signalSocksData = null;
          _errorStocks = response.message;
        }
      }
    } catch (e) {
      _signalSocksData = null;
      _errorStocks = Const.errSomethingWrong;
    } finally {
      setStatusStocks(Status.loaded);
    }
  }

//MARK: Sentiment
  String? _errorSentiment;
  String? get errorSentiment => _errorSentiment;

  Status _statusSentiment = Status.ideal;
  Status get statusSentiment => _statusSentiment;

  bool get isLoadingSentiment => _statusSentiment == Status.loading;

  SignalSentimentRes? _signalSentimentData;
  SignalSentimentRes? get signalSentimentData => _signalSentimentData;

  setStatusSentiment(status) {
    _statusSentiment = status;
    notifyListeners();
  }

  Future getSignalSentimentData({
    int dataAll = 1,
    num days = 1,
    bool loadFull = true,
  }) async {
    try {
      if (loadFull) setStatusSentiment(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      request['all_data'] = '$dataAll';
      request['days'] = '$days';

      ApiResponse response = await apiRequest(
        url: Apis.signalSentiment,
        request: request,
        showProgress: !loadFull,
      );
      if (response.status) {
        if (dataAll == 1) {
          _signalSentimentData =
              signalSentimentResFromJson(jsonEncode(response.data));
        } else {
          _signalSentimentData?.mostMentions?.data =
              signalSentimentResFromJson(jsonEncode(response.data))
                  .mostMentions
                  ?.data;
        }

        _errorSentiment = null;
      } else {
        _signalSentimentData = null;
        _errorSentiment = response.message;
      }
    } catch (e) {
      _signalSentimentData = null;
      _errorSentiment = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.signalSentiment}: $e');
    } finally {
      if (loadFull) {
        setStatusSentiment(Status.loaded);
      } else {
        notifyListeners();
      }
    }
  }

  //MARK: Insiders
  String? _errorInsiders;
  String? get errorInsiders => _errorInsiders;

  Status _statusInsiders = Status.ideal;
  Status get statusInsiders => _statusInsiders;

  bool get isLoadingInsiders =>
      _statusInsiders == Status.loading || _statusInsiders == Status.ideal;

  setStatusInsiders(status) {
    _statusInsiders = status;
    notifyListeners();
  }
}
