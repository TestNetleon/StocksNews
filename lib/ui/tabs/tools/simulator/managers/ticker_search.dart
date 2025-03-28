import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/search.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/order_info_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/ConditionalTrades.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/conditionalOrder/RecurringOrder/recurring_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class TickerSearchManager extends ChangeNotifier {
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  void clearAllData() {
    _searchData = null;
    _errorSearch = null;
    _errorRecentSearch = null;
    _recentSearchData = null;
    notifyListeners();
  }

  Status _statusSearch = Status.ideal;
  Status get statusSearch => _statusSearch;

  bool get isLoadingSearch => _statusSearch == Status.loading;

  BaseSearchRes? _searchData;
  BaseSearchRes? get searchData => _searchData;

  String? _errorSearch;
  String? get errorSearch => _errorSearch;

  setStatusSearch(status) {
    _statusSearch = status;
    notifyListeners();
  }

  getBaseSearchData({required String term}) async {
    setStatusSearch(Status.loading);
    try {
      Map request = {
        'term': term,
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsSearchSymbol,
        request: request,
      );
      if (response.status) {
        if (response.data != null) {
          _searchData = baseSearchResFromJson(jsonEncode(response.data));
        } else {
          _searchData = null;
        }
        _errorSearch = response.message;
      } else {
        _searchData = null;
        _errorSearch = null;
      }
    } catch (e) {
      _searchData = null;
      _errorSearch = Const.errSomethingWrong;
    } finally {
      setStatusSearch(Status.loaded);
    }
  }

//MARK: Recent Search Data
  String? _errorRecentSearch;
  String? get errorRecentSearch => _errorRecentSearch;

  Status _statusRecentSearch = Status.ideal;
  Status get statusRecentSearch => _statusRecentSearch;

  bool get isLoadingRecentSearch => _statusRecentSearch == Status.loading;

  BaseSearchRes? _recentSearchData;
  BaseSearchRes? get recentSearchData => _recentSearchData;

  setStatusRecentSearch(status) {
    _statusRecentSearch = status;
    notifyListeners();
  }

  Future getRecentSearchData() async {
    try {
      setStatusRecentSearch(Status.loading);
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.tradingMostSearch,
        request: request,
      );
      if (response.status) {
        _recentSearchData = baseSearchResFromJson(jsonEncode(response.data));
        _errorRecentSearch = null;
      } else {
        _recentSearchData = null;
        _errorRecentSearch = response.message;
      }
    } catch (e) {
      _recentSearchData = null;
      _errorRecentSearch = Const.errSomethingWrong;
    } finally {
      setStatusRecentSearch(Status.loaded);
    }
  }

  Future stockHolding(String symbol, {StockType? selectedStock}) async {
    Utils().showLog('Checking holdings for ${selectedStock?.name}');
    try {
      Map request = {
        'symbol': symbol,
        'action': selectedStock == StockType.sell
            ? "SELL"
            : selectedStock == StockType.buy
                ? "BUY"
                : "BUY_TO_COVER",
        'order_type': "MARKET_ORDER"
      };
      ApiResponse res = await apiRequest(
          url: Apis.stockHoldings, request: request, showProgress: true);
      if (res.status) {
        if ((selectedStock == StockType.sell ||
                selectedStock == StockType.btc) &&
            res.data['quantity'] <= 0) {
          popUpAlert(
              title: 'Alert',
              message: "You don't own the shares of this stock");
          return;
        }

        TradeManager manager =
            navigatorKey.currentContext!.read<TradeManager>();

        ApiResponse response = await manager.getDetailTopData(
          symbol: symbol,
          showProgress: true,
        );
        if (response.status) {
          Navigator.pushReplacementNamed(
              navigatorKey.currentContext!, TradeBuySellIndex.path,
              arguments: {
                "stockType": selectedStock,
                "qty": res.data['quantity'],
              });
        }
      } else {
        //
      }
      return ApiResponse(status: res.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future shortRedirection(String symbol) async {
    try {
      TradeManager manager = navigatorKey.currentContext!.read<TradeManager>();
      ApiResponse response = await manager.getDetailTopData(
        symbol: symbol,
        showProgress: true,
      );
      if (response.status) {
        Navigator.pushReplacementNamed(
            navigatorKey.currentContext!, TradeBuySellIndex.path,
            arguments: {
              "stockType": StockType.short,
              "qty": 0,
            });
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future stockHoldingOfCondition(String symbol,
      {String? selectedStock, ConditionType? conditionalType}) async {
    if (conditionalType == ConditionType.recurringOrder) {
      return Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, RecurringIndex.path);
    }
    Utils().showLog('Checking holdings for ${conditionalType?.name}');
    try {
      Map request = {
        'symbol': symbol,
        'action': selectedStock?.toUpperCase() ?? "",
        'order_type': conditionalType == ConditionType.limitOrder
            ? "LIMIT_ORDER"
            : conditionalType == ConditionType.stopOrder
                ? "STOP_ORDER"
                : conditionalType == ConditionType.stopLimitOrder
                    ? "STOP_LIMIT_ORDER"
                    : conditionalType == ConditionType.trailingOrder
                        ? "TRAILING_ORDER"
                        : "RECURRING_ORDER",
      };
      ApiResponse res = await apiRequest(
          url: Apis.stockHoldings, request: request, showProgress: true);
      if (res.status) {
        if ((selectedStock == "Sell" || selectedStock == "BUY_TO_COVER") &&
            res.data['quantity'] <= 0) {
          popUpAlert(
              title: 'Alert',
              message: "You don't own the shares of this stock");
          return;
        }
        TradeManager manager =
            navigatorKey.currentContext!.read<TradeManager>();

        ApiResponse response = await manager.getDetailTopData(
          symbol: symbol,
          showProgress: true,
        );
        if (response.status) {
          if (conditionalType == ConditionType.recurringOrder) {
            Navigator.pushReplacementNamed(
                navigatorKey.currentContext!, RecurringIndex.path);
          } else {
            Navigator.pushReplacementNamed(
                navigatorKey.currentContext!, ConditionalTradesIndex.path,
                arguments: {
                  "conditionType": conditionalType,
                  "qty": res.data['quantity'],
                  "tradeType": selectedStock,
                });
          }
        }
      } else {
        //
      }
      return ApiResponse(status: res.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future conditionalRedirection(String symbol,
      {int? tickerID,
      num? qty,
      ConditionType? conditionalType,
      String? tradeType}) async {
    try {
      TradeManager manager = navigatorKey.currentContext!.read<TradeManager>();
      ApiResponse response = await manager.getDetailTopData(
        symbol: symbol,
        showProgress: true,
      );
      if (response.status) {
       /* Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => ConditionalTradesIndex(
              conditionalType: conditionalType,
              tickerID: tickerID,
              qty: qty,
            ),
          ),
        );*/
        Navigator.pushReplacementNamed(
            navigatorKey.currentContext!, ConditionalTradesIndex.path,
            arguments: {
              "conditionType": conditionalType,
              "qty": qty,
              "tickerID": tickerID,
            });
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future stockHoldingOfRecurringCondition(String symbol) async {
    try {
      Map request = {
        'symbol': symbol,
      };
      ApiResponse res = await apiRequest(
          url: Apis.recurringHoldings, request: request, showProgress: true);
      if (res.status) {
        if (res.data['status'] == "FOUND") {
          popUpAlert(
              title: 'Alert',
              message: "You already have this recurring trade.");
          return;
        } else {
          TradeManager manager =
              navigatorKey.currentContext!.read<TradeManager>();
          ApiResponse response = await manager.getDetailTopData(
            symbol: symbol,
            showProgress: true,
          );
          if (response.status) {
            Navigator.pushReplacement(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => RecurringIndex(),
              ),
            );
          }
        }
      } else {
        Utils().showLog('stock holding: ${res.message}');
      }
      return ApiResponse(status: res.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  /*Future infoDisable({bool enableDisable = false}) async {
    try {
      Map request = {
        '': enableDisable,
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsInfoDisable,
        request: request,
      );
      if (response.status) {
        PortfolioManager portfolioManager = navigatorKey.currentContext!.read<PortfolioManager>();
        TsUserDataRes? userDataRes = portfolioManager.userData?.userDataRes;

       // _userData = tsUserResFromJson(jsonEncode(response.data));
        _error = null;
      }
      else {
        _error = response.message ?? Const.errSomethingWrong;
      }
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog('Error getDashboardData $e');
    }
  }*/

  Status _infoStatus = Status.ideal;
  Status get infoStatus => _infoStatus;
  bool get isInfoLoading =>
      _infoStatus == Status.loading || _infoStatus == Status.ideal;

  void setInfoStatus(Status status) {
    _infoStatus = status;
    notifyListeners();
  }

  OrderInfoRes? _infoData;
  OrderInfoRes? get infoData => _infoData;

  Future<void> orderInfo(
      {ConditionType? conditionalType, StockType? selectedStock}) async {
    setInfoStatus(Status.loading);
    try {
      Map request = {
        'action': selectedStock == StockType.sell
            ? "SELL"
            : selectedStock == StockType.buy
                ? "BUY"
                : selectedStock == StockType.btc
                    ? "BUY_TO_COVER"
                    : selectedStock == StockType.short
                        ? "SHORT"
                        : "",
        'order_type': conditionalType == ConditionType.bracketOrder
            ? "BRACKET_ORDER"
            : conditionalType == ConditionType.limitOrder
                ? "LIMIT_ORDER"
                : conditionalType == ConditionType.stopOrder
                    ? "STOP_ORDER"
                    : conditionalType == ConditionType.stopLimitOrder
                        ? "STOP_LIMIT_ORDER"
                        : conditionalType == ConditionType.trailingOrder
                            ? "TRAILING_ORDER"
                            :
        conditionalType == ConditionType.recurringOrder
            ? "RECURRING_ORDER":"MARKET_ORDER"
      };
      ApiResponse res = await apiRequest(
          url: Apis.orderTypeInfo, request: request, showProgress: false);
      if (res.status) {
        _infoData = orderInfoResFromMap(jsonEncode(res.data));
        _error = null;
      } else {
        _infoData = null;
        _error = res.message ?? Const.errSomethingWrong;
      }
      setInfoStatus(Status.loaded);
    } catch (e) {
      _infoData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('info: $e');
      setInfoStatus(Status.loaded);
    }
  }
}
