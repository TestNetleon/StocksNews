// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/search_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
// import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/index.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
// import '../../utils/colors.dart';
// import '../screens/trade/sheet.dart';

// class TradingSearchProvider extends ChangeNotifier {
//   Status _status = Status.ideal;
//   Status get status => _status;
//   bool get isLoading => _status == Status.loading || _status == Status.ideal;
//   // final sseManager = SSEManager();

//   List<TradingSearchTickerRes>? _data;
//   List<TradingSearchTickerRes>? get data => _data;

//   String? _error;
//   String? get error => _error ?? Const.errSomethingWrong;

//   Status _statusS = Status.ideal;
//   Status get statusS => _statusS;
//   bool get isLoadingS => _statusS == Status.loading;

//   List<SearchRes>? _dataNew;
//   List<SearchRes>? get dataNew => _dataNew;

//   Extra? _extra;
//   Extra? get extra => _extra;

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   void setStatusS(status) {
//     _statusS = status;
//     notifyListeners();
//   }

//   void clearSearch() {
//     _status = Status.ideal;
//     _statusS = Status.ideal;
//     _dataNew = null;
//     notifyListeners();
//   }

//   /// Fetch search defaults and set up SSE
//   Future getSearchDefaults() async {
//     setStatus(Status.loading);
//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.tradingMostSearch,
//         request: request,
//         showProgress: false,
//       );

//       if (response.status) {
//         _extra = (response.extra is Extra ? response.extra as Extra : null);
//         _data = tradingSearchTickerResFromJson(jsonEncode(response.data));
//       } else {
//         _data = null;
//         _error = response.message ?? Const.errSomethingWrong;
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       _data = null;
//       _error = Const.errSomethingWrong;
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }

//   /// Dispose method to clean up SSE
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future searchSymbols(request, {showProgress = false}) async {
//     setStatusS(Status.loading);
//     try {
//       ApiResponse response = await apiRequest(
//         url: Apis.tsSearchSymbol,
//         request: request,
//         showProgress: showProgress,
//       );
//       if (response.status) {
//         _dataNew = searchResFromJson(jsonEncode(response.data));
//       } else {
//         _dataNew = null;
//       }
//       setStatusS(Status.loaded);
//     } catch (e) {
//       _dataNew = null;

//       Utils().showLog(e.toString());
//       setStatusS(Status.loaded);
//     }
//   }

//   Future stockHolding(String symbol, {bool buy = true}) async {
//     Utils().showLog('Checking holdings for $buy');
//     try {
//       UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

//       Map request = {
//         'token': provider.user?.token ?? '',
//         'symbol': symbol,
//       };

//       ApiResponse res = await apiRequest(
//           url: Apis.stockHoldings, request: request, showProgress: true);
//       if (res.status) {
//         if (!buy && res.data['quantity'] <= 0) {
//           popUpAlert(
//               title: 'Alert',
//               message: "You don't own the shares of this stock");
//           return;
//         }

//         StockDetailProviderNew provider =
//             navigatorKey.currentContext!.read<StockDetailProviderNew>();

//         ApiResponse response = await provider.getTabData(
//           symbol: symbol,
//           showProgress: true,
//           startSSE: true,
//         );
//         if (response.status) {
//           SummaryOrderNew? order = await Navigator.pushReplacement(
//             navigatorKey.currentContext!,
//             MaterialPageRoute(
//               builder: (context) => TradeBuySellIndex(
//                 buy: buy,
//                 qty: res.data['quantity'],
//               ),
//             ),
//           );
//           if (order != null) {
//             // TradeProviderNew provider =
//             //     navigatorKey.currentContext!.read<TradeProviderNew>();

//             // buy ? provider.addOrderData(order) : provider.sellOrderData(order);
//             await _showSheet(order, buy);
//           }
//         }
//       } else {
//         //
//       }
//       return ApiResponse(status: res.status);
//     } catch (e) {
//       Utils().showLog('stock holding: $e');
//       return ApiResponse(status: false);
//     }
//   }

//   Future _showSheet(SummaryOrderNew? order, bool buy) async {
//     await showModalBottomSheet(
//       useSafeArea: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5),
//           topRight: Radius.circular(5),
//         ),
//       ),
//       backgroundColor: ThemeColors.transparent,
//       isScrollControlled: false,
//       context: navigatorKey.currentContext!,
//       builder: (context) {
//         return SuccessTradeSheet(
//           order: order,
//           buy: buy,
//           close: true,
//         );
//       },
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/tournament/provider/trades.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/ConditionalOrder/ConditionalTrades.dart';
import 'package:stocks_news_new/tradingSimulator/screens/tradeBuySell/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class TradingSearchProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  // final sseManager = SSEManager();

  List<TradingSearchTickerRes>? _data;
  List<TradingSearchTickerRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;
  bool get isLoadingS => _statusS == Status.loading;

  List<SearchRes>? _dataNew;
  List<SearchRes>? get dataNew => _dataNew;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusS(status) {
    _statusS = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _statusS = Status.ideal;
    _dataNew = null;
    notifyListeners();
  }

  /// Fetch search defaults and set up SSE
  Future getSearchDefaults() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.tradingMostSearch,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        _data = tradingSearchTickerResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  /// Dispose method to clean up SSE
  @override
  void dispose() {
    super.dispose();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatusS(Status.loading);
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
      setStatusS(Status.loaded);
    } catch (e) {
      _dataNew = null;

      Utils().showLog(e.toString());
      setStatusS(Status.loaded);
    }
  }

  Future stockHolding(String symbol, {StockType? selectedStock}) async {
    Utils().showLog('Checking holdings for ${selectedStock?.name}');
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
        'action': selectedStock == StockType.sell
            ? "SELL"
            : selectedStock == StockType.buy
                ? "BUY"
                : "BUY_TO_COVER",
        'order_type':"MARKET_ORDER"

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

        TradeProviderNew provider =
            navigatorKey.currentContext!.read<TradeProviderNew>();

        ApiResponse response = await provider.getDetailTopData(
          symbol: symbol,
          showProgress: true,
        );
        if (response.status) {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => TradeBuySellIndex(
                selectedStock: selectedStock,
                qty: res.data['quantity'],
              ),
            ),
          );
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
      TradeProviderNew provider =
          navigatorKey.currentContext!.read<TradeProviderNew>();
      ApiResponse response = await provider.getDetailTopData(
        symbol: symbol,
        showProgress: true,
      );
      if (response.status) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => TradeBuySellIndex(
              selectedStock: StockType.short,
              qty: 0,
            ),
          ),
        );
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }


  Future stockHoldingOfCondition(String symbol, {String? selectedStock, ConditionType? conditionalType}) async {
    Utils().showLog('Checking holdings for ${conditionalType?.name}');
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
        'action': selectedStock?.toUpperCase(),
        'order_type':  conditionalType == ConditionType.limitOrder?"LIMIT_ORDER":"STOP_ORDER",
      };
      ApiResponse res = await apiRequest(
          url: Apis.stockHoldings, request: request, showProgress: true);
      if (res.status) {
        if ((selectedStock == "Sell" || selectedStock == "BUY_TO_COVER") && res.data['quantity'] <= 0) {
          popUpAlert(
              title: 'Alert',
              message: "You don't own the shares of this stock");
          return;
        }
        TradeProviderNew provider =
        navigatorKey.currentContext!.read<TradeProviderNew>();

        ApiResponse response = await provider.getDetailTopData(
          symbol: symbol,
          showProgress: true,
        );
        if (response.status) {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => ConditionalTradesIndex(
                conditionalType: conditionalType,
                qty:  res.data['quantity'],
                tradeType: selectedStock,
              ),
            ),
          );
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
      {int? tickerID, num? qty,ConditionType? conditionalType, String? tradeType}) async {
    try {
      TradeProviderNew provider =
          navigatorKey.currentContext!.read<TradeProviderNew>();
      ApiResponse response = await provider.getDetailTopData(
        symbol: symbol,
        showProgress: true,
      );
      if (response.status) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => ConditionalTradesIndex(
              conditionalType: conditionalType,
              tickerID: tickerID,
              qty: qty,
            ),
          ),
        );
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  /*Future _showSheet(SummaryOrderNew? order, bool buy) async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      backgroundColor: ThemeColors.transparent,
      isScrollControlled: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SizedBox();

        /// not call _show sheet
        SuccessTradeSheet(
          order: order,
          buy: buy,
          close: true,
        );
      },
    );
  }*/
}
