// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/tradingSimulator/modals/ts_open_list_res.dart';
// import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import '../manager/sse.dart';

// class TsOpenListProvider extends ChangeNotifier {
//   Status _status = Status.ideal;
//   Status get status => _status;
//   bool get isLoading => _status == Status.loading || _status == Status.ideal;

//   List<TsOpenListRes>? _data;
//   List<TsOpenListRes>? get data => _data;

//   String? _error;
//   String? get error => _error ?? Const.errSomethingWrong;

//   Extra? _extra;
//   Extra? get extra => _extra;

//   Map<String, Map<String, num>> _stockReturnMap = {};

//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
//     String createdAtDate =
//         DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
//     String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
//     return createdAtDate == responseDateString;
//   }

//   Map<String, num> _calculateTodaysReturn(StockDataManagerRes stockData,
//       TsOpenListRes stock, num shares, num invested) {
//     num todaysReturn = 0;
//     num todaysReturnPercentage = 0;
//     num price = stockData.price ?? 0;

//     bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);

//     if (boughtToday) {
//       // Stock bought today
//       num boughtPrice = stock.avgPrice ?? 0;
//       if (boughtPrice > 0 && invested > 0) {
//         todaysReturn = (price - boughtPrice) * shares;
//         todaysReturnPercentage = ((price - boughtPrice) / boughtPrice) * 100;
//       }
//     } else {
//       // Stock bought previously
//       num previousClose = stockData.previousClose ?? 0;
//       if (previousClose > 0 && invested > 0) {
//         todaysReturn = (price - previousClose) * shares;
//         todaysReturnPercentage =
//             ((price - previousClose) / previousClose) * 100;
//       }
//     }

//     return {
//       'todaysReturn': todaysReturn,
//       'todaysReturnPercentage': todaysReturnPercentage,
//     };
//   }

//   Map<String, num> getTodaysReturnForStock(String symbol) {
//     return _stockReturnMap[symbol] ??
//         {'todaysReturn': 0, 'todaysReturnPercentage': 0};
//   }

//   void _updateStockData(String symbol, StockDataManagerRes stockData) {
//     if (_data == null || _data!.isEmpty) return;

//     final index = _data!.indexWhere((stock) => stock.symbol == symbol);
//     if (index == -1) {
//       Utils().showLog("Stock with symbol $symbol not found in _data.");
//       return;
//     }

//     TsOpenListRes existingStock = _data![index];
//     num shares = existingStock.quantity ?? 0;
//     num invested = existingStock.invested ?? 0;
//     if (stockData.price != null) {
//       existingStock.currentPrice = stockData.price;
//     }

//     if (stockData.change != null) {
//       existingStock.change = stockData.change;
//     }
//     if (stockData.changePercentage != null) {
//       existingStock.changesPercentage = stockData.changePercentage;
//     }

//     existingStock.currentInvested =
//         (stockData.price ?? (_data?[index].currentPrice ?? 0)) * shares;
//     existingStock.investedChange =
//         (existingStock.currentInvested ?? 0) - invested;

//     existingStock.investedChangePercentage =
//         ((existingStock.investedChange ?? 0) / invested) * 100;
//     notifyListeners();
//     var returnData =
//         _calculateTodaysReturn(stockData, existingStock, shares, invested);

//     _stockReturnMap[symbol] = {
//       'todaysReturn': returnData['todaysReturn']!,
//       'todaysReturnPercentage': returnData['todaysReturnPercentage']!
//     };

//     Utils().showLog('Updating for $symbol, Price: ${stockData.price}');
//     Utils()
//         .showLog('Today\'s Return for $symbol: ${returnData['todaysReturn']}');
//     // Utils().showLog(
//     //     'Today\'s Return Percentage for $symbol: ${returnData['todaysReturnPercentage']}%');

//     _updatePortfolioBalance();
//   }

//   void _removeStockFromMap(String symbol) {
//     if (_stockReturnMap.containsKey(symbol)) {
//       _stockReturnMap.remove(symbol);
//       Utils().showLog('Removed $symbol from return map.');
//     }
//   }

//   void _updatePortfolioBalance() {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();

//     num totalMarketValue = 0;
//     num todaysReturn = 0;

//     for (var stock in _data!) {
//       String symbol = stock.symbol ?? '';
//       Map<String, num> returnData = getTodaysReturnForStock(symbol);

//       // Add the current stock's market value to the total
//       totalMarketValue += stock.currentInvested ?? 0;

//       // Add the latest today's return for the stock
//       todaysReturn += returnData['todaysReturn'] ?? 0;
//     }

//     provider.updateBalance(
//       marketValue: totalMarketValue,
//       totalReturn: provider.userData?.totalReturn != null
//           ? (provider.userData?.totalReturn ?? 0) + todaysReturn
//           : 0,
//       todayReturn: todaysReturn,
//     );

//     Utils().showLog('Final Portfolio Return: $todaysReturn');
//   }

//   void _updateStockDataForMultipleSymbols(
//       List<StockDataManagerRes> stockDataList) {
//     Set<String> existingSymbols =
//         _data?.map((stock) => stock.symbol ?? '').toSet() ?? {};

//     for (var stockData in stockDataList) {
//       String symbol = stockData.symbol;

//       if (existingSymbols.contains(symbol)) {
//         _updateStockData(symbol, stockData);
//       } else {
//         _removeStockFromMap(symbol);
//       }
//     }
//   }

//   // Method to fetch new data
//   Future getData() async {
//     navigatorKey.currentContext!.read<TsPortfolioProvider>().getDashboardData();
//     setStatus(Status.loading);

//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.tsOrderList,
//         request: request,
//         showProgress: false,
//       );

//       if (response.status) {
//         _data = tsOpenListResFromJson(jsonEncode(response.data));
//         _extra = (response.extra is Extra ? response.extra as Extra : null);
//         _error = null;

//         List<String> symbols =
//             _data?.map((stock) => stock.symbol ?? '').toList() ?? [];

//         _connectSSEForSymbols(symbols);
//       } else {
//         _data = null;
//         _error = response.message ?? Const.errSomethingWrong;
//       }

//       setStatus(Status.loaded);
//     } catch (e) {
//       _data = null;
//       _error = Const.errSomethingWrong;
//       Utils().showLog('Open data: $e');
//       setStatus(Status.loaded);
//     }
//   }

//   // Helper method to connect SSE for stock symbols
//   void _connectSSEForSymbols(List<String> symbols) {
//     SSEManager.instance.connectMultipleStocks(
//       screen: SimulatorEnum.open,
//       symbols: symbols,
//     );

//     for (var symbol in symbols) {
//       SSEManager.instance.addListener(symbol, (StockDataManagerRes stockData) {
//         _updateStockData(symbol, stockData);
//       });
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_open_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../manager/sse.dart';

class TsOpenListProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsOpenListRes>? _data;
  List<TsOpenListRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  final Map<String, Map<String, num>> _stockReturnMap = {};

  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
    String createdAtDate =
        DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
    String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
    return createdAtDate == responseDateString;
  }

//MARK: Today's Return
  Map<String, num> _calculateTodaysReturn(
    StockDataManagerRes stockData,
    TsOpenListRes stock,
    num shares,
    num invested,
  ) {
    num todaysReturn = 0;
    num todaysReturnPercentage = 0;
    num price = stockData.price ?? stock.currentPrice ?? 0;

    bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
    if (boughtToday) {
      // Utils().showLog('Stock ${stock.symbol} is bought today');
      // Stock bought today
      num boughtPrice = stock.avgPrice ?? 0;
      if (boughtPrice > 0) {
        if (stock.tradeType == 'Short') {
          todaysReturn = (boughtPrice - price) * shares;
          todaysReturnPercentage = ((boughtPrice - price) / price) * 100;
        } else {
          todaysReturn = (price - boughtPrice) * shares;
          todaysReturnPercentage = ((price - boughtPrice) / boughtPrice) * 100;
        }
      }
    } else {
      // Utils().showLog('Stock ${stock.symbol} is bought previously');

      // Stock bought previously
      num previousClose = stockData.previousClose ?? 0;
      if (previousClose > 0) {
        if (stock.tradeType == 'Short') {
          todaysReturn = (previousClose - price) * shares;
          todaysReturnPercentage = ((previousClose - price) / price) * 100;
        } else {
          todaysReturn = (price - previousClose) * shares;
          todaysReturnPercentage =
              ((price - previousClose) / previousClose) * 100;
        }
      }
    }

    return {
      'todaysReturn': todaysReturn,
      'todaysReturnPercentage': todaysReturnPercentage,
    };
  }

  Map<String, num> getTodaysReturnForStock(String symbol) {
    return _stockReturnMap[symbol] ??
        {'todaysReturn': 0, 'todaysReturnPercentage': 0};
  }

//MARK: Update Stock Data
  void _updateStockData(String symbol, StockDataManagerRes stockData) {
    if (_data == null || _data!.isEmpty) return;

    final index = _data!.indexWhere((stock) => stock.symbol == symbol);
    if (index == -1) {
      Utils().showLog("Stock with symbol $symbol not found in _data.");
      return;
    }

    TsOpenListRes existingStock = _data![index];
    num shares = existingStock.quantity ?? 0;
    num invested = existingStock.invested ?? 0;

    // Update stock's current data
    existingStock.currentPrice = stockData.price ?? existingStock.currentPrice;
    existingStock.change = stockData.change ?? existingStock.change;
    existingStock.changesPercentage =
        stockData.changePercentage ?? existingStock.changesPercentage;

    existingStock.currentInvested = (existingStock.currentPrice ?? 0) * shares;

    if (existingStock.tradeType == 'Short') {
      //Short condition
      existingStock.investedChange =
          invested - (existingStock.currentInvested ?? 0);

      existingStock.investedChangePercentage = invested > 0
          ? ((existingStock.investedChange ?? 0) /
                  (existingStock.currentInvested ?? 0)) *
              100
          : 0;
    } else {
      existingStock.investedChange =
          (existingStock.currentInvested ?? 0) - invested;

      existingStock.investedChangePercentage = invested > 0
          ? ((existingStock.investedChange ?? 0) / invested) * 100
          : 0;
    }

    // Calculate today's return and update map
    var returnData =
        _calculateTodaysReturn(stockData, existingStock, shares, invested);

    _stockReturnMap[symbol] = returnData;

    Utils().showLog('Holding: ${stockData.toMap()}');

    // Utils()
    //     .showLog('Today\'s Return for $symbol: ${returnData['todaysReturn']}');

    _updatePortfolioBalance();
    notifyListeners();
  }

//MARK: Update Balance
  void _updatePortfolioBalance() {
    TsPortfolioProvider provider =
        navigatorKey.currentContext!.read<TsPortfolioProvider>();

    num totalMarketValue = 0;
    num todaysReturn = 0;

    for (var stock in _data!) {
      String symbol = stock.symbol ?? '';
      Map<String, num> returnData = getTodaysReturnForStock(symbol);
      Utils().showLog('$symbol=> return $returnData');
      totalMarketValue += stock.currentInvested ?? 0;
      todaysReturn += returnData['todaysReturn'] ?? 0;
    }

    provider.updateBalance(totalReturn: 0);

    num? mainReturn = 0;

    if (_data != null && _data!.isNotEmpty) {
      mainReturn = _data!
          .map((item) => item.investedChange ?? 0.0)
          .fold(0.0, (prev, element) => prev + element);
    }

    provider.updateBalance(
      marketValue: totalMarketValue,

      // totalReturn:
      //     (totalMarketValue - (provider.userData?.investedAmount ?? 0)),
      totalReturn: mainReturn,

      todayReturn: todaysReturn,
    );

    // Utils().showLog('Final Portfolio Return: $todaysReturn');
  }

  void _removeStockFromMap(String symbol) {
    if (_stockReturnMap.containsKey(symbol)) {
      _stockReturnMap.remove(symbol);
      Utils().showLog('Removed $symbol from return map.');
    }
  }

  void _updateStockDataForMultipleSymbols(
      List<StockDataManagerRes> stockDataList) {
    Set<String> existingSymbols =
        _data?.map((stock) => stock.symbol ?? '').toSet() ?? {};

    for (var stockData in stockDataList) {
      String symbol = stockData.symbol;

      if (existingSymbols.contains(symbol)) {
        _updateStockData(symbol, stockData);
      } else {
        _removeStockFromMap(symbol);
      }
    }
  }

//MARK: API Call
  Future<void> getData() async {
    TsPortfolioProvider provider =
        navigatorKey.currentContext!.read<TsPortfolioProvider>();
    provider.getDashboardData();

    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.tsOrderList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _data = tsOpenListResFromJson(jsonEncode(response.data));

        // num? totalReturn = 0;
        // if (_data != null && _data!.isNotEmpty) {
        //   totalReturn = _data!
        //       .map((item) => item.investedChange ?? 0.0)
        //       .fold(0.0, (prev, element) => prev + element);
        // }

        // provider.updateBalance(totalReturn: totalReturn);

        _extra = response.extra is Extra ? response.extra as Extra : null;
        _error = null;

        List<String> symbols =
            _data?.map((stock) => stock.symbol ?? '').toList() ?? [];

        _connectSSEForSymbols(symbols);
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Open data: $e');
      setStatus(Status.loaded);
    }
  }

// MARK: SSE Manager
  void _connectSSEForSymbols(List<String> symbols) {
    if (_data != null &&
        _data?.isNotEmpty == true &&
        (_extra?.executable == true)) {
      for (var data in _data!) {
        _updateStockData(
          data.symbol ?? '',
          StockDataManagerRes(
            symbol: data.symbol ?? "",
            change: data.change,
            changePercentage: data.changesPercentage,
            price: data.currentPrice,
            previousClose: data.previousClose,
          ),
        );
        try {
          SSEManager.instance.connectMultipleStocks(
            screen: SimulatorEnum.open,
            symbols: symbols,
          );

          SSEManager.instance.addListener(
            data.symbol ?? '',
            (StockDataManagerRes stockData) {
              _updateStockData(data.symbol ?? '', stockData);
            },
            SimulatorEnum.open,
          );
        } catch (e) {
          //
        }
      }
    } else {
      if (kDebugMode) {
        print('not executable');
      }
    }
  }
}
