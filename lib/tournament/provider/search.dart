import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../modals/search_res.dart';
import '../../providers/user_provider.dart';
import '../../routes/my_app.dart';
import '../../tradingSimulator/modals/trading_search_res.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class TournamentSearchProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  String? _error;
  String? get error => _error;

  List<TradingSearchTickerRes>? _topSearch;
  List<TradingSearchTickerRes>? get topSearch => _topSearch;

// MARK: DEFAULT TICKERS
  Future getSearchDefaults() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.tTickerList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _topSearch = tradingSearchTickerResFromJson(jsonEncode(response.data));
        TournamentTradesProvider provider =
            navigatorKey.currentContext!.read<TournamentTradesProvider>();
        clearSearch();
        provider.setSelectedStock(
          stock: _topSearch?[0],
          refresh: true,
          clearEverything: true,
        );
      } else {
        _topSearch = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _topSearch = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  String? _errorSearch;
  String? get errorSearch => _errorSearch ?? Const.errSomethingWrong;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;
  bool get isLoadingS => _statusS == Status.loading;

  List<SearchRes>? _dataNew;
  List<SearchRes>? get dataNew => _dataNew;

  void setStatusSearch(status) {
    _statusS = status;
    notifyListeners();
  }

  void clearSearch() {
    _dataNew = null;
    _statusS = Status.ideal;
    notifyListeners();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsSearchSymbol,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchResFromJson(jsonEncode(response.data));
      } else {
        _dataNew = null;
      }
      setStatusSearch(Status.loaded);
    } catch (e) {
      _dataNew = null;

      Utils().showLog(e.toString());
      setStatusSearch(Status.loaded);
    }
  }
}
