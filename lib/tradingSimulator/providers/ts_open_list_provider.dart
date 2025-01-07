import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  // Map to store returns for each stock separately
  Map<String, Map<String, num>> _stockReturnMap = {};

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
    String createdAtDate =
        DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
    String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
    return createdAtDate == responseDateString;
  }

  // Helper method to calculate today's return for a stock
  // Map<String, num> _calculateTodaysReturn(StockDataManagerRes stockData,
  //     TsOpenListRes stock, num shares, num invested) {
  //   num todaysReturn = 0;
  //   num todaysReturnPercentage = 0;
  //   num price = stockData.price ?? 0;

  //   // Check if the stock was bought today
  //   bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);

  //   if (boughtToday) {
  //     print('bought today ${stockData.symbol}');
  //     num boughtPrice = stock.avgPrice ?? 0;
  //     if (boughtPrice > 0 && invested > 0) {
  //       todaysReturn = (price - boughtPrice) * shares;
  //       todaysReturnPercentage = ((price - boughtPrice) / boughtPrice) * 100;
  //     }
  //   } else {
  //     print('bought previous ${stockData.symbol}');

  //     num previousClose = stockData.previousClose ?? 0;
  //     if (previousClose > 0 && invested > 0) {
  //       todaysReturn = (price - previousClose) * shares;
  //       todaysReturnPercentage =
  //           ((price - previousClose) / previousClose) * 100;
  //     }
  //   }

  //   return {
  //     'todaysReturn': todaysReturn,
  //     'todaysReturnPercentage': todaysReturnPercentage
  //   };
  // }

  Map<String, num> _calculateTodaysReturn(StockDataManagerRes stockData,
      TsOpenListRes stock, num shares, num invested) {
    num todaysReturn = 0;
    num todaysReturnPercentage = 0;
    num price = stockData.price ?? 0;

    // Check if the stock was bought today
    bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);

    if (boughtToday) {
      // Stock bought today
      num boughtPrice = stock.avgPrice ?? 0;
      if (boughtPrice > 0 && invested > 0) {
        todaysReturn = (price - boughtPrice) * shares;
        todaysReturnPercentage = ((price - boughtPrice) / boughtPrice) * 100;
      }
    } else {
      // Stock bought previously
      num previousClose = stockData.previousClose ?? 0;
      if (previousClose > 0 && invested > 0) {
        todaysReturn = (price - previousClose) * shares;
        todaysReturnPercentage =
            ((price - previousClose) / previousClose) * 100;
      }
    }

    return {
      'todaysReturn': todaysReturn,
      'todaysReturnPercentage': todaysReturnPercentage,
    };
  }

  // Helper method to retrieve the return value for a stock
  Map<String, num> getTodaysReturnForStock(String symbol) {
    return _stockReturnMap[symbol] ??
        {'todaysReturn': 0, 'todaysReturnPercentage': 0};
  }

  // Method to update stock data for each ticker
  void _updateStockData(String symbol, StockDataManagerRes stockData) {
    if (_data == null || _data!.isEmpty) return;

    // Find the stock data for the given symbol
    final index = _data!.indexWhere((stock) => stock.symbol == symbol);
    if (index == -1) {
      Utils().showLog("Stock with symbol $symbol not found in _data.");
      return;
    }

    TsOpenListRes existingStock = _data![index];
    num shares = existingStock.quantity ?? 0;
    num invested = existingStock.invested ?? 0;
    if (stockData.price != null) {
      existingStock.currentPrice = stockData.price;
    }

    if (stockData.change != null) {
      existingStock.change = stockData.change;
    }
    if (stockData.changePercentage != null) {
      existingStock.changesPercentage = stockData.changePercentage;
    }

    existingStock.currentInvested =
        (stockData.price ?? (_data?[index].currentPrice ?? 0)) * shares;
    existingStock.investedChange =
        (existingStock.currentInvested ?? 0) - invested;

    existingStock.investedChangePercentage =
        ((existingStock.investedChange ?? 0) / invested) * 100;
    notifyListeners();
    // Calculate today's return and percentage
    var returnData =
        _calculateTodaysReturn(stockData, existingStock, shares, invested);

    // Update the map with the return data for the stock
    _stockReturnMap[symbol] = {
      'todaysReturn': returnData['todaysReturn']!,
      'todaysReturnPercentage': returnData['todaysReturnPercentage']!
    };

    // Log for debugging
    Utils().showLog('Updating for $symbol, Price: ${stockData.price}');
    Utils()
        .showLog('Today\'s Return for $symbol: ${returnData['todaysReturn']}');
    Utils().showLog(
        'Today\'s Return Percentage for $symbol: ${returnData['todaysReturnPercentage']}%');

    // Update the portfolio
    _updatePortfolioBalance();
  }

  // Method to remove stock data from the map when no longer available
  void _removeStockFromMap(String symbol) {
    if (_stockReturnMap.containsKey(symbol)) {
      _stockReturnMap.remove(symbol);
      Utils().showLog('Removed $symbol from return map.');
    }
  }

  // Method to update portfolio balance
  // void _updatePortfolioBalance() {
  //   TsPortfolioProvider provider =
  //       navigatorKey.currentContext!.read<TsPortfolioProvider>();

  //   num totalMarketValue = 0;
  //   num totalReturn = 0;

  //   // Calculate total return and market value
  //   for (var stock in _data!) {
  //     String symbol = stock.symbol ?? '';
  //     Map<String, num> returnData = getTodaysReturnForStock(symbol);
  //     totalReturn += returnData['todaysReturn'] ?? 0;
  //     totalMarketValue += stock.currentInvested ?? 0;
  //   }

  //   provider.updateBalance(
  //     marketValue: totalMarketValue,
  //     position: totalMarketValue - (provider.userData?.invested ?? 0),
  //     todayReturn: totalReturn, // Total return of the portfolio
  //   );

  //   Utils().showLog('Final Portfolio Return: $totalReturn');
  // }

// Method to update portfolio balance
  void _updatePortfolioBalance() {
    TsPortfolioProvider provider =
        navigatorKey.currentContext!.read<TsPortfolioProvider>();

    num totalMarketValue = 0;
    num totalReturn = 0;

    // Calculate total return and market value for all stocks
    for (var stock in _data!) {
      String symbol = stock.symbol ?? '';
      Map<String, num> returnData = getTodaysReturnForStock(symbol);

      // Add today's return to total portfolio return
      totalReturn += returnData['todaysReturn'] ?? 0;

      // Add current market value of the stock to total
      totalMarketValue += stock.currentInvested ?? 0;
    }

    // Update portfolio provider with aggregated values
    provider.updateBalance(
      marketValue: totalMarketValue,
      position: totalMarketValue - (provider.userData?.invested ?? 0),
      todayReturn: totalReturn, // Combined return of the portfolio
    );

    Utils().showLog('Final Portfolio Return: $totalReturn');
  }

  // Method to handle stock data update for multiple symbols
  void _updateStockDataForMultipleSymbols(
      List<StockDataManagerRes> stockDataList) {
    // Create a set of existing stock symbols
    Set<String> existingSymbols =
        _data?.map((stock) => stock.symbol ?? '').toSet() ?? {};

    // Iterate through the stock data
    for (var stockData in stockDataList) {
      String symbol = stockData.symbol;

      // If the symbol exists in _data, update the stock return
      if (existingSymbols.contains(symbol)) {
        _updateStockData(symbol, stockData);
      } else {
        // If stock is not found, remove it from the map
        _removeStockFromMap(symbol);
      }
    }
  }

  // Method to fetch new data
  Future getData() async {
    navigatorKey.currentContext!.read<TsPortfolioProvider>().getDashboardData();
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
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        _error = null;

        List<String> symbols =
            _data?.map((stock) => stock.symbol ?? '').toList() ?? [];

        // Connect SSE for multiple stocks
        _connectSSEForSymbols(symbols);
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog('Open data: $e');
      setStatus(Status.loaded);
    }
  }

  // Helper method to connect SSE for stock symbols
  void _connectSSEForSymbols(List<String> symbols) {
    SSEManager.instance.connectMultipleStocks(
      screen: SimulatorEnum.open,
      symbols: symbols,
    );

    for (var symbol in symbols) {
      SSEManager.instance.addListener(symbol, (StockDataManagerRes stockData) {
        // Utils().showLog('${stockData.previousClose}');
        _updateStockData(symbol, stockData);
      });
    }
  }
}




  // num parseCurrencyString(String currencyString) {
  //   try {
  //     // Step 1: Remove any non-numeric characters (e.g., $, commas)
  //     String cleanedString = currencyString.replaceAll(RegExp(r'[^\d.]'), '');

  //     // Step 2: Convert the cleaned string to a number
  //     return double.parse(cleanedString);
  //   } catch (e) {
  //     // If the parsing fails, return a default value (e.g., 0)
  //     print("Error parsing currency string: $e");
  //     return 0;
  //   }
  // }