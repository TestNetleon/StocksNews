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

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
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

//   // final Map<String, Map<String, num>> _stockReturnMap = {};
//   final List<Map<String, Map<String, dynamic>>> __stockReturnMap = [];

//   void setStatus(Status status) {
//     _status = status;
//     notifyListeners();
//   }

//   bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
//     String createdAtDate =
//         DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
//     String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
//     return createdAtDate == responseDateString;
//   }

// //MARK: Today's Return
//   Map<String, dynamic> _calculateTodaysReturn(
//     StockDataManagerRes stockData,
//     TsOpenListRes stock,
//     num shares,
//     num invested,
//   ) {
//     print('++++++${stock.tradeType}');

//     num todaysReturn = 0;
//     num todaysReturnPercentage = 0;
//     num price = stockData.price ?? stock.currentPrice ?? 0;

//     bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
//     if (boughtToday) {
//       // Utils().showLog('Stock ${stock.symbol} is bought today');
//       // Stock bought today
//       num boughtPrice = stock.avgPrice ?? 0;
//       if (boughtPrice > 0) {
//         if (stock.tradeType == 'Short') {
//           todaysReturn = (boughtPrice - price) * shares;
//           todaysReturnPercentage = ((boughtPrice - price) / price) * 100;
//           print('short $todaysReturn');
//         } else {
//           todaysReturn = (price - boughtPrice) * shares;
//           todaysReturnPercentage = ((price - boughtPrice) / boughtPrice) * 100;
//           print('else $todaysReturn');
//         }
//       }
//     } else {
//       // Utils().showLog('Stock ${stock.symbol} is bought previously');

//       // Stock bought previously
//       num previousClose = stockData.previousClose ?? 0;
//       if (previousClose > 0) {
//         if (stock.tradeType == 'Short') {
//           todaysReturn = (previousClose - price) * shares;
//           todaysReturnPercentage = ((previousClose - price) / price) * 100;
//         } else {
//           todaysReturn = (price - previousClose) * shares;
//           todaysReturnPercentage =
//               ((price - previousClose) / previousClose) * 100;
//         }
//       }
//     }

//     return {
//       'todaysReturn': todaysReturn,
//       'todaysReturnPercentage': "$todaysReturnPercentage",
//       'tradeType': "${stock.tradeType}",
//     };
//   }

//   Map<String, dynamic> getTodaysReturnForStock(
//       String symbol, String? tradeType) {
//     int index = -1;
//     index = __stockReturnMap.indexWhere((element) =>
//         element.keys.first == symbol &&
//         element[symbol]?['tradeType'] == tradeType);

//     // Utils().showLog("ERORORORO ==> ${__stockReturnMap[index]}");
//     if (index != -1) {
//       return __stockReturnMap[index];
//     }

//     Utils().showLog("ERORORORO");
//     return //_stockReturnMap[symbol] ??
//         {'todaysReturn': 0, 'todaysReturnPercentage': 0};
//   }

// //MARK: Update Stock Data
//   void _updateStockData(String symbol, StockDataManagerRes stockData) {
//     try {
//       if (_data == null || _data!.isEmpty) return;
//       for (var a in _data!) {
//         print('1111${a.tradeType}');
//       }
//       List<TsOpenListRes> finds =
//           _data!.takeWhile((stock) => stock.symbol == symbol).toList();

//       final index = _data!.indexWhere((stock) => stock.symbol == symbol);
//       if (index == -1) {
//         Utils().showLog("Stock with symbol $symbol not found in _data.");
//         return;
//       }
//       TsOpenListRes? existingStock;
//       for (var data in finds) {
//         existingStock = data;

//         num shares = existingStock.quantity ?? 0;
//         num invested = existingStock.invested ?? 0;

//         // Update stock's current data
//         existingStock.currentPrice =
//             stockData.price ?? existingStock.currentPrice;
//         existingStock.change = stockData.change ?? existingStock.change;
//         existingStock.changesPercentage =
//             stockData.changePercentage ?? existingStock.changesPercentage;

//         existingStock.currentInvested =
//             (existingStock.currentPrice ?? 0) * shares;

//         if (existingStock.tradeType == 'Short') {
//           //Short condition
//           existingStock.investedChange =
//               invested - (existingStock.currentInvested ?? 0);

//           existingStock.investedChangePercentage = invested > 0
//               ? ((existingStock.investedChange ?? 0) /
//                       (existingStock.currentInvested ?? 0)) *
//                   100
//               : 0;
//         } else {
//           existingStock.investedChange =
//               (existingStock.currentInvested ?? 0) - invested;

//           existingStock.investedChangePercentage = invested > 0
//               ? ((existingStock.investedChange ?? 0) / invested) * 100
//               : 0;
//         }
//         var returnData =
//             _calculateTodaysReturn(stockData, existingStock, shares, invested);

//         int index = -1;
//         index = __stockReturnMap.indexWhere((element) {
//           Utils().showLog("ELE KEY =>> ${element.keys.first}");
//           return existingStock?.symbol == element.keys.first &&
//               existingStock?.tradeType ==
//                   element[existingStock?.symbol]?['tradeType'];
//         });

//         Utils().showLog('HERE 0: ${index}');
//         if (index == -1) {
//           __stockReturnMap.add({symbol: returnData});
//         }
//         Utils().showLog('HERE : ${__stockReturnMap.length}');

//         // _stockReturnMap[symbol] = returnData;

//         Utils().showLog('Holding: ${stockData.toMap()}');

//         // Utils()
//         //     .showLog('Today\'s Return for $symbol: ${returnData['todaysReturn']}');

//         _updatePortfolioBalance(finds);
//         notifyListeners();
//       }
//       if (existingStock == null) return;
//       print(
//           '1111++++------- ${existingStock.tradeType} ${finds[0].tradeType} ${finds[1].tradeType}');

//       // Calculate today's return and update map
//     } catch (e) {
//       //
//     }
//   }

// //MARK: Update Balance
//   void _updatePortfolioBalance(List<TsOpenListRes> finds) {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();

//     num totalMarketValue = 0;
//     num todaysReturn = 0;

//     for (var stock in finds) {
//       String symbol = stock.symbol ?? '';
//       Map<String, dynamic> returnData =
//           getTodaysReturnForStock(symbol, stock.tradeType);
//       if (returnData['todaysReturn'] == null) {
//         returnData = {'todaysReturn': 0, 'todaysReturnPercentage': '0'};
//       }

//       Utils().showLog('$symbol=> return $returnData');
//       totalMarketValue += stock.currentInvested ?? 0;
//       todaysReturn += returnData[symbol]['todaysReturn'] ?? 0;
//       Utils().showLog('$symbol=> end of return value $todaysReturn');
//     }

//     provider.updateBalance(totalReturn: 0);

//     num? mainReturn = 0;

//     if (_data != null && _data!.isNotEmpty) {
//       mainReturn = _data!
//           .map((item) => item.investedChange ?? 0.0)
//           .fold(0.0, (prev, element) => prev + element);
//     }

//     provider.updateBalance(
//       marketValue: totalMarketValue,

//       // totalReturn:
//       //     (totalMarketValue - (provider.userData?.investedAmount ?? 0)),
//       totalReturn: mainReturn,

//       todayReturn: todaysReturn,
//     );

//     Utils().showLog('Final Portfolio Return: $todaysReturn');
//     notifyListeners();
//   }

//   // void _removeStockFromMap(String symbol) {
//   //   if (_stockReturnMap.containsKey(symbol)) {
//   //     _stockReturnMap.remove(symbol);
//   //     Utils().showLog('Removed $symbol from return map.');
//   //   }
//   // }

//   // void _updateStockDataForMultipleSymbols(
//   //     List<StockDataManagerRes> stockDataList) {
//   //   Set<String> existingSymbols =
//   //       _data?.map((stock) => stock.symbol ?? '').toSet() ?? {};

//   //   for (var stockData in stockDataList) {
//   //     String symbol = stockData.symbol;

//   //     if (existingSymbols.contains(symbol)) {
//   //       _updateStockData(symbol, stockData);
//   //     } else {
//   //       _removeStockFromMap(symbol);
//   //     }
//   //   }
//   // }

// //MARK: API Call
//   Future<void> getData() async {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();
//     provider.getDashboardData();

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

//         // num? totalReturn = 0;
//         // if (_data != null && _data!.isNotEmpty) {
//         //   totalReturn = _data!
//         //       .map((item) => item.investedChange ?? 0.0)
//         //       .fold(0.0, (prev, element) => prev + element);
//         // }

//         // provider.updateBalance(totalReturn: totalReturn);

//         _extra = response.extra is Extra ? response.extra as Extra : null;
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

// // MARK: SSE Manager
//   void _connectSSEForSymbols(List<String> symbols) {
//     if (_data != null &&
//         _data?.isNotEmpty == true &&
//         (_extra?.executable == true)) {
//       for (var data in _data!) {
//         _updateStockData(
//           data.symbol ?? '',
//           StockDataManagerRes(
//             symbol: data.symbol ?? "",
//             change: data.change,
//             changePercentage: data.changesPercentage,
//             price: data.currentPrice,
//             previousClose: data.previousClose,
//           ),
//         );
//         try {
//           SSEManager.instance.connectMultipleStocks(
//             screen: SimulatorEnum.open,
//             symbols: symbols,
//           );

//           SSEManager.instance.addListener(
//             data.symbol ?? '',
//             (StockDataManagerRes stockData) {
//               _updateStockData(data.symbol ?? '', stockData);
//             },
//             SimulatorEnum.open,
//           );
//         } catch (e) {
//           //
//         }
//       }
//     } else {
//       if (kDebugMode) {
//         print('not executable');
//       }
//     }
//   }
// }

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

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
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

//   final Map<String, Map<String, num>> _stockReturnMap = {};

//   void setStatus(Status status) {
//     _status = status;
//     notifyListeners();
//   }

//   bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
//     String createdAtDate =
//         DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
//     String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
//     return createdAtDate == responseDateString;
//   }

// //MARK: Today's Return
//   Map<String, num> _calculateTodaysReturn(
//     StockDataManagerRes stockData,
//     TsOpenListRes stock,
//     num shares,
//     num invested,
//   ) {
//     num todaysReturn = 0;
//     num todaysReturnPercentage = 0;
//     num price = stockData.price ?? stock.currentPrice ?? 0;

//     bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
//     if (boughtToday) {
//       // Utils().showLog('Stock ${stock.symbol} is bought today');
//       // Stock bought today
//       num boughtPrice = stock.avgPrice ?? 0;
//       if (boughtPrice > 0) {
//         if (stock.tradeType == 'Short') {
//           todaysReturn = (boughtPrice - price) * shares;
//           todaysReturnPercentage = ((boughtPrice - price) / price) * 100;
//         } else {
//           todaysReturn = (price - boughtPrice) * shares;
//           todaysReturnPercentage = ((price - boughtPrice) / boughtPrice) * 100;
//         }
//       }
//     } else {
//       // Utils().showLog('Stock ${stock.symbol} is bought previously');

//       // Stock bought previously
//       num previousClose = stockData.previousClose ?? 0;
//       if (previousClose > 0) {
//         if (stock.tradeType == 'Short') {
//           todaysReturn = (previousClose - price) * shares;
//           todaysReturnPercentage = ((previousClose - price) / price) * 100;
//         } else {
//           todaysReturn = (price - previousClose) * shares;
//           todaysReturnPercentage =
//               ((price - previousClose) / previousClose) * 100;
//         }
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

// //MARK: Update Stock Data
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

//     // Update stock's current data
//     existingStock.currentPrice = stockData.price ?? existingStock.currentPrice;
//     existingStock.change = stockData.change ?? existingStock.change;
//     existingStock.changesPercentage =
//         stockData.changePercentage ?? existingStock.changesPercentage;

//     existingStock.currentInvested = (existingStock.currentPrice ?? 0) * shares;

//     if (existingStock.tradeType == 'Short') {
//       //Short condition
//       existingStock.investedChange =
//           invested - (existingStock.currentInvested ?? 0);

//       existingStock.investedChangePercentage = invested > 0
//           ? ((existingStock.investedChange ?? 0) /
//                   (existingStock.currentInvested ?? 0)) *
//               100
//           : 0;
//     } else {
//       existingStock.investedChange =
//           (existingStock.currentInvested ?? 0) - invested;

//       existingStock.investedChangePercentage = invested > 0
//           ? ((existingStock.investedChange ?? 0) / invested) * 100
//           : 0;
//     }

//     // Calculate today's return and update map
//     var returnData =
//         _calculateTodaysReturn(stockData, existingStock, shares, invested);

//     _stockReturnMap[symbol] = returnData;

//     Utils().showLog('Holding: ${stockData.toMap()}');

//     // Utils()
//     //     .showLog('Today\'s Return for $symbol: ${returnData['todaysReturn']}');

//     _updatePortfolioBalance();
//     notifyListeners();
//   }

// //MARK: Update Balance
//   void _updatePortfolioBalance() {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();

//     num totalMarketValue = 0;
//     num todaysReturn = 0;

//     for (var stock in _data!) {
//       String symbol = stock.symbol ?? '';
//       Map<String, num> returnData = getTodaysReturnForStock(symbol);
//       Utils().showLog('$symbol=> return $returnData');
//       totalMarketValue += stock.currentInvested ?? 0;
//       todaysReturn += returnData['todaysReturn'] ?? 0;
//     }

//     provider.updateBalance(totalReturn: 0);

//     num? mainReturn = 0;

//     if (_data != null && _data!.isNotEmpty) {
//       mainReturn = _data!
//           .map((item) => item.investedChange ?? 0.0)
//           .fold(0.0, (prev, element) => prev + element);
//     }

//     provider.updateBalance(
//       marketValue: totalMarketValue,

//       // totalReturn:
//       //     (totalMarketValue - (provider.userData?.investedAmount ?? 0)),
//       totalReturn: mainReturn,
//       todayReturn: todaysReturn,
//     );

//     Utils().showLog('Final Portfolio Return: $todaysReturn');
//     notifyListeners();
//   }

//   void _removeStockFromMap(String symbol) {
//     if (_stockReturnMap.containsKey(symbol)) {
//       _stockReturnMap.remove(symbol);
//       Utils().showLog('Removed $symbol from return map.');
//     }
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

// //MARK: API Call
//   Future<void> getData() async {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();
//     provider.getDashboardData();

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

//         // num? totalReturn = 0;
//         // if (_data != null && _data!.isNotEmpty) {
//         //   totalReturn = _data!
//         //       .map((item) => item.investedChange ?? 0.0)
//         //       .fold(0.0, (prev, element) => prev + element);
//         // }

//         // provider.updateBalance(totalReturn: totalReturn);

//         _extra = response.extra is Extra ? response.extra as Extra : null;
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

// // MARK: SSE Manager
//   void _connectSSEForSymbols(List<String> symbols) {
//     if (_data != null &&
//         _data?.isNotEmpty == true &&
//         (_extra?.executable == true)) {
//       for (var data in _data!) {
//         _updateStockData(
//           data.symbol ?? '',
//           StockDataManagerRes(
//             symbol: data.symbol ?? "",
//             change: data.change,
//             changePercentage: data.changesPercentage,
//             price: data.currentPrice,
//             previousClose: data.previousClose,
//           ),
//         );
//         try {
//           SSEManager.instance.connectMultipleStocks(
//             screen: SimulatorEnum.open,
//             symbols: symbols,
//           );

//           SSEManager.instance.addListener(
//             data.symbol ?? '',
//             (StockDataManagerRes stockData) {
//               _updateStockData(data.symbol ?? '', stockData);
//             },
//             SimulatorEnum.open,
//           );
//         } catch (e) {
//           //
//         }
//       }
//     } else {
//       if (kDebugMode) {
//         print('not executable');
//       }
//     }
//   }
// }

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
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
//   Map<int, TsOpenListRes> _dataMap = {};

//   void setStatus(Status status) {
//     _status = status;
//     notifyListeners();
//   }

//   void _updateStockData(int id, StockDataManagerRes stockData) {
//     Utils().showLog('MAP => ${stockData.toMap()}');

//     // Now let's remove any stock entries that are no longer in _data
//     _removeStocksNotInData();
//     if (_data == null || _data?.isEmpty == true) return;
//     print('Updating stock with id: $id with new data: ${stockData.toMap()}');

//     // Check if the stock exists in _dataMap by ID
//     TsOpenListRes? stock = _dataMap[id];

//     if (stock != null) {
//       // Stock exists in _dataMap, update it
//       print('Stock exists. Updating stock data...');
//       _updateStockFromData(stock, stockData);

//       // Also update the corresponding stock in _data
//       _updateStockInData(id, stockData);
//     } else {
//       // New stock entry (if ID doesn't exist in _dataMap)
//       print('New stock entry. Creating new stock...');
//       TsOpenListRes newStock = _createNewStock(id, stockData);
//       _dataMap[id] = newStock; // Add the new stock to _dataMap

//       // Add the new stock to _data
//       _data?.add(newStock);
//     }

//     // Update portfolio balance after stock data change
//     _updatePortfolioBalance();
//     notifyListeners();
//   }

//   void _updateStockInData(int id, StockDataManagerRes stockData) {
//     // Find the corresponding stock in _data based on the ID
//     TsOpenListRes? stockInData = _data?.firstWhere(
//       (s) => s.id == id,
//       orElse: () => TsOpenListRes(),
//     );

//     if (stockInData != null) {
//       // Update the stock in _data with the new data
//       stockInData.currentPrice = stockData.price ?? stockInData.currentPrice;
//       stockInData.change = stockData.change ?? stockInData.change;
//       stockInData.changesPercentage =
//           stockData.changePercentage ?? stockInData.changesPercentage;
//       stockInData.currentInvested =
//           (stockInData.currentPrice ?? 0) * (stockInData.quantity ?? 0);

//       // Optionally, update any other properties you need
//     } else {
//       // If no matching stock is found in _data, add a new stock
//       TsOpenListRes newStock = _createNewStock(id, stockData);
//       _data?.add(newStock);
//     }
//   }

//   void _updateStockFromData(
//       TsOpenListRes stock, StockDataManagerRes stockData) {
//     // Update the real-time data without affecting persistent data
//     stock.currentPrice = stockData.price ?? stock.currentPrice;
//     stock.change = stockData.change ?? stock.change;
//     stock.changesPercentage =
//         stockData.changePercentage ?? stock.changesPercentage;

//     // Update currentInvested based on the latest price and quantity
//     stock.currentInvested = (stock.currentPrice ?? 0) * (stock.quantity ?? 0);

//     // Calculate the change in investment based on trade type
//     stock.investedChange = stock.tradeType == 'Short'
//         ? (stock.invested ?? 0) - (stock.currentInvested ?? 0)
//         : (stock.currentInvested ?? 0) - (stock.invested ?? 0);

//     stock.investedChangePercentage = stock.invested! > 0
//         ? (stock.investedChange! / stock.invested!) * 100
//         : 0;

//     // Calculate today's return and store it
//     final returnData = _calculateTodaysReturn(stockData, stock);
//     _stockReturnMap[stock.id.toString()] = returnData;

//     print('Updated returns for stock with id ${stock.id}: $returnData');
//   }

//   TsOpenListRes _createNewStock(int id, StockDataManagerRes stockData) {
//     print('Creating new stock with id: $id');

//     // Retrieve existing stock from _data (if available)
//     TsOpenListRes existingStock = _data!.firstWhere(
//       (s) => s.id == id,
//       orElse: () => TsOpenListRes(id: id),
//     );

//     TsOpenListRes newStock = TsOpenListRes(
//       id: id, // Use the unique ID
//       symbol: existingStock.symbol ?? stockData.symbol,
//       currentPrice: stockData.price ?? existingStock.currentPrice,
//       change: stockData.change ?? existingStock.change,
//       changesPercentage:
//           stockData.changePercentage ?? existingStock.changesPercentage,
//       invested: existingStock.invested,
//       quantity: existingStock.quantity,
//       avgPrice: existingStock.avgPrice,
//       currentInvested: existingStock.currentInvested,
//       createdAt: existingStock.createdAt,
//     );

//     // Update currentInvested for new stock
//     newStock.currentInvested =
//         (newStock.currentPrice ?? 0) * (newStock.quantity ?? 0);

//     return newStock;
//   }

//   void _removeStocksNotInData() {
//     // Iterate through _dataMap and check if the stock is still in _data by ID
//     List<int> idsToRemove = [];
//     _dataMap.forEach((id, stock) {
//       if (!_data!.any((existingStock) => existingStock.id == id)) {
//         idsToRemove.add(id);
//       }
//     });

//     // Remove the stocks from _dataMap that are no longer present in _data
//     for (var id in idsToRemove) {
//       _dataMap.remove(id);
//       _stockReturnMap
//           .remove(id.toString()); // Remove from return map using string key
//       print('Removed stock with id $id from _dataMap and _stockReturnMap');
//     }
//   }

//   Map<String, num> _calculateTodaysReturn(
//       StockDataManagerRes stockData, TsOpenListRes stock) {
//     num todaysReturn = 0;
//     num todaysReturnPercentage = 0;
//     num price = stockData.price ?? stock.currentPrice ?? 0;

//     bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
//     num referencePrice = boughtToday
//         ? (stock.avgPrice ?? 0)
//         : (stockData.previousClose ?? stock.previousClose ?? 0);

//     if (kDebugMode) {
//       print(
//           "Calculating today's return for stock ${stock.id}. Reference Price: $referencePrice, Current Price: $price");
//     }

//     if (referencePrice > 0) {
//       if (stock.tradeType == 'Short') {
//         todaysReturn = (referencePrice - price) * stock.quantity!;
//         todaysReturnPercentage = ((referencePrice - price) / price) * 100;
//       } else {
//         todaysReturn = (price - referencePrice) * stock.quantity!;
//         todaysReturnPercentage =
//             ((price - referencePrice) / referencePrice) * 100;
//       }
//     }

//     return {
//       'todaysReturn': todaysReturn,
//       'todaysReturnPercentage': todaysReturnPercentage
//     };
//   }

//   clearAll() {
//     _dataMap = {};
//     _stockReturnMap = {};
//     notifyListeners();
//   }

//   bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
//     String createdAtDate =
//         DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
//     String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
//     if (kDebugMode) {
//       print(
//           'Checking if stock was bought today: $createdAtDate vs $responseDateString');
//     }
//     return createdAtDate == responseDateString;
//   }

//   void _updatePortfolioBalance() {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();

//     num totalMarketValue = 0;
//     num todaysReturn = 0;

//     for (var stock in _data!) {
//       int id = stock.id ?? 0;
//       Map<String, num> returnData = getTodaysReturnForStock(id);
//       totalMarketValue += stock.currentInvested ?? 0;
//       todaysReturn += returnData['todaysReturn'] ?? 0;
//     }

//     provider.updateBalance(totalReturn: 0);

//     num? mainReturn = 0;

//     if (_data != null && _data!.isNotEmpty) {
//       mainReturn = _data!
//           .map((item) => item.investedChange ?? 0.0)
//           .fold(0.0, (prev, element) => prev + element);
//     }

//     if (kDebugMode) {
//       print(
//           'Updating portfolio balance. Market Value: $totalMarketValue, Total Return: $mainReturn, Today\'s Return: $todaysReturn');
//     }

//     provider.updateBalance(
//       marketValue: totalMarketValue,
//       totalReturn: mainReturn,
//       todayReturn: todaysReturn,
//     );

//     notifyListeners();
//   }

//   Map<String, num> getTodaysReturnForStock(int id) {
//     var returnData = _stockReturnMap[id.toString()] ??
//         {'todaysReturn': 0, 'todaysReturnPercentage': 0};
//     print('Fetching return data for stock id $id: $returnData');
//     return returnData;
//   }

// //MARK: API Call
//   Future<void> getData() async {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();
//     provider.getDashboardData();

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

//         // num? totalReturn = 0;
//         // if (_data != null && _data!.isNotEmpty) {
//         //   totalReturn = _data!
//         //       .map((item) => item.investedChange ?? 0.0)
//         //       .fold(0.0, (prev, element) => prev + element);
//         // }

//         // provider.updateBalance(totalReturn: totalReturn);

//         _extra = response.extra is Extra ? response.extra as Extra : null;
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

// // MARK: SSE Manager

//   void _connectSSEForSymbols(List<String> symbols) {
//     if (_data != null &&
//         _data?.isNotEmpty == true &&
//         (_extra?.executable == true || kDebugMode)) {
//       for (var data in _data!) {
//         if (data.id == null) return;
//         _updateStockData(
//           data.id ?? 0,
//           StockDataManagerRes(
//             symbol: data.symbol ?? "",
//             change: data.change,
//             changePercentage: data.changesPercentage,
//             price: data.currentPrice,
//             previousClose: data.previousClose,
//           ),
//         );
//         try {
//           SSEManager.instance.connectMultipleStocks(
//             screen: SimulatorEnum.open,
//             symbols: symbols,
//           );

//           SSEManager.instance.addListener(
//             data.symbol ?? '',
//             (StockDataManagerRes stockData) {
//               if (data.id == null) return;
//               _updateStockData(data.id ?? 0, stockData);
//             },
//             SimulatorEnum.open,
//           );
//         } catch (e) {
//           //
//         }
//       }
//     } else {
//       if (kDebugMode) {
//         print('not executable');
//       }
//     }
//   }
// }

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
//   void setStatus(Status status) {
//     _status = status;
//     notifyListeners();
//   }

//   Map<int, Map<String, dynamic>> _dataMap = {};

//   void _updateStockData(int id, StockDataManagerRes stockData) {
//     Utils().showLog('Holding: ${stockData.toMap()}');
//     if (_data == null) return;

//     int index = _data!.indexWhere((stock) => stock.id == id);
//     if (index == -1) return;

//     TsOpenListRes stock = _data![index];
//     num shares = stock.quantity ?? 0;
//     num invested = stock.invested ?? 0;

//     stock.currentPrice = stockData.price ?? stock.currentPrice;
//     stock.change = stockData.change ?? stock.change;
//     stock.changesPercentage =
//         stockData.changePercentage ?? stock.changesPercentage;
//     stock.previousClose = stockData.previousClose ?? stock.previousClose;

//     stock.currentInvested = (stock.currentPrice ?? 0) * shares;
//     num investedChange = (stock.tradeType == 'Short')
//         ? invested - (stock.currentInvested ?? 0)
//         : (stock.currentInvested ?? 0) - invested;

//     stock.investedChange = investedChange;

//     stock.investedChangePercentage =
//         (invested > 0) ? (investedChange / invested) * 100 : 0;

//     _data![index] = stock;
//     notifyListeners();

//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();

//     num totalMarketValue = 0;
//     num todaysReturn = 0;

//     // Check for missing stocks and remove them from _dataMap
//     _dataMap.removeWhere((id, value) {
//       if (_data!.every((stock) => stock.id != id)) {
//         return true; // Remove the entry if stock id is not found
//       }
//       return false; // Keep the entry if the stock id exists
//     });

//     for (var stock in _data!) {
//       Map<String, num> returnData = _calculateTodaysReturn(stockData, stock);
//       totalMarketValue += stock.currentInvested ?? 0;
//       todaysReturn += returnData['todaysReturn'] ?? 0;
//     }

//     provider.updateBalance(totalReturn: 0);

//     num? mainReturn = 0;

//     if (_data != null && _data!.isNotEmpty) {
//       mainReturn = _data!
//           .map((item) => item.investedChange ?? 0.0)
//           .fold(0.0, (prev, element) => prev + element);
//     }

//     if (kDebugMode) {
//       print(
//           'Updating portfolio balance. Market Value: $totalMarketValue, Total Return: $mainReturn, Today\'s Return: $todaysReturn');
//     }

//     provider.updateBalance(
//       marketValue: totalMarketValue,
//       totalReturn: mainReturn,
//       todayReturn: todaysReturn,
//     );

//     notifyListeners();
//   }

//   Map<String, num> _calculateTodaysReturn(
//       StockDataManagerRes stockData, TsOpenListRes stock) {
//     num todaysReturn = 0;
//     num todaysReturnPercentage = 0;
//     num price = stockData.price ?? stock.currentPrice ?? 0;

//     bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
//     num referencePrice = boughtToday
//         ? (stock.avgPrice ?? 0)
//         : (stockData.previousClose ?? stock.previousClose ?? 0);

//     if (kDebugMode) {
//       print(
//           "Calculating today's return for stock ${stock.id}. Reference Price: $referencePrice, Current Price: $price");
//     }

//     if (referencePrice > 0) {
//       if (stock.tradeType == 'Short') {
//         todaysReturn = (referencePrice - price) * stock.quantity!;
//         todaysReturnPercentage = ((referencePrice - price) / price) * 100;
//       } else {
//         todaysReturn = (price - referencePrice) * stock.quantity!;
//         todaysReturnPercentage =
//             ((price - referencePrice) / referencePrice) * 100;
//       }
//     }

//     // Save today's return in the map using stock id
//     _dataMap[stock.id!] = {
//       'todaysReturn': todaysReturn,
//       'todaysReturnPercentage': todaysReturnPercentage
//     };

//     return {
//       'todaysReturn': todaysReturn,
//       'todaysReturnPercentage': todaysReturnPercentage
//     };
//   }

//   bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
//     String createdAtDate =
//         DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
//     String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
//     if (kDebugMode) {
//       print(
//           'Checking if stock was bought today: $createdAtDate vs $responseDateString');
//     }
//     return createdAtDate == responseDateString;
//   }

// //MARK: API Call
//   Future<void> getData() async {
//     TsPortfolioProvider provider =
//         navigatorKey.currentContext!.read<TsPortfolioProvider>();
//     provider.getDashboardData();

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

//         // num? totalReturn = 0;
//         // if (_data != null && _data!.isNotEmpty) {
//         //   totalReturn = _data!
//         //       .map((item) => item.investedChange ?? 0.0)
//         //       .fold(0.0, (prev, element) => prev + element);
//         // }

//         // provider.updateBalance(totalReturn: totalReturn);

//         _extra = response.extra is Extra ? response.extra as Extra : null;
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

// // MARK: SSE Manager

//   void _connectSSEForSymbols(List<String> symbols) {
//     if (_data != null &&
//         _data?.isNotEmpty == true &&
//         (_extra?.executable == true || kDebugMode)) {
//       for (var data in _data!) {
//         if (data.id == null) return;
//         _updateStockData(
//           data.id ?? 0,
//           StockDataManagerRes(
//             symbol: data.symbol ?? "",
//             change: data.change,
//             changePercentage: data.changesPercentage,
//             price: data.currentPrice,
//             previousClose: data.previousClose,
//           ),
//         );
//         try {
//           SSEManager.instance.connectMultipleStocks(
//             screen: SimulatorEnum.open,
//             symbols: symbols,
//           );

//           SSEManager.instance.addListener(
//             data.symbol ?? '',
//             (StockDataManagerRes stockData) {
//               if (data.id == null) return;
//               _updateStockData(data.id ?? 0, stockData);
//             },
//             SimulatorEnum.open,
//           );
//         } catch (e) {
//           //
//         }
//       }
//     } else {
//       if (kDebugMode) {
//         print('not executable');
//       }
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

  Map<int, Map<String, dynamic>> _dataMap = {};

  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  void _updateStockData(int id, StockDataManagerRes stockData) {
    Utils().showLog('Holding: ${stockData.toMap()}');
    if (_data == null) return;

    int index = _data!.indexWhere((stock) => stock.id == id);
    if (index == -1) return;

    TsOpenListRes stock = _data![index];
    num shares = stock.quantity ?? 0;
    num invested = stock.invested ?? 0;

    stock.currentPrice = stockData.price ?? stock.currentPrice;
    stock.change = stockData.change ?? stock.change;
    stock.changesPercentage =
        stockData.changePercentage ?? stock.changesPercentage;
    stock.previousClose = stockData.previousClose ?? stock.previousClose;

    stock.currentInvested = (stock.currentPrice ?? 0) * shares;
    num investedChange = (stock.tradeType == 'Short')
        ? invested - (stock.currentInvested ?? 0)
        : (stock.currentInvested ?? 0) - invested;

    stock.investedChange = investedChange;

    stock.investedChangePercentage =
        (invested > 0) ? (investedChange / invested) * 100 : 0;

    _data![index] = stock;
    notifyListeners();

    TsPortfolioProvider provider =
        navigatorKey.currentContext!.read<TsPortfolioProvider>();

    num totalMarketValue = 0;
    num todaysReturn = 0;

    _dataMap.removeWhere((id, value) {
      if (_data!.every((stock) => stock.id != id)) {
        return true;
      }
      return false;
    });

    for (var stock in _data!) {
      Map<String, num> returnData = _calculateTodaysReturn(stockData, stock);

      print("Checking stock: ${stock.id} for today's return.");
      print("Today's Return Calculation: ${returnData['todaysReturn']}");

      totalMarketValue += stock.currentInvested ?? 0;

      todaysReturn += returnData['todaysReturn'] ?? 0;

      if (_dataMap.containsKey(stock.id)) {
        print(
            "Stock ID ${stock.id} found in _dataMap. Updating today's return.");
        _dataMap[stock.id]!['todaysReturn'] = returnData['todaysReturn']!;
      } else {
        print("Stock ID ${stock.id} not found in _dataMap. Adding new entry.");
        // If not present, add the stock's return to the map with the ID
        _dataMap[stock.id!] = {
          'todaysReturn': returnData['todaysReturn']!,
          'todaysReturnPercentage': returnData['todaysReturnPercentage']!,
        };
      }
    }

// Log the final results
    print("Total Market Value: $totalMarketValue");
    print("Total Today's Return: $todaysReturn");

    provider.updateBalance(totalReturn: 0);

    num? mainReturn = 0;

    if (_data != null && _data!.isNotEmpty) {
      mainReturn = _data!
          .map((item) => item.investedChange ?? 0.0)
          .fold(0.0, (prev, element) => prev + element);
    }

    if (kDebugMode) {
      print(
          'Updating portfolio balance. Market Value: $totalMarketValue, Total Return: $mainReturn, Today\'s Return: $todaysReturn');
    }

    provider.updateBalance(
      marketValue: totalMarketValue,
      totalReturn: mainReturn,
      todayReturn: todaysReturn,
    );

    notifyListeners();
  }

  Map<String, num> _calculateTodaysReturn(
      StockDataManagerRes stockData, TsOpenListRes stock) {
    num todaysReturn = 0;
    num todaysReturnPercentage = 0;
    num price = stockData.price ?? stock.currentPrice ?? 0;

    bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
    num referencePrice = boughtToday
        ? (stock.avgPrice ?? 0)
        : (stockData.previousClose ?? stock.previousClose ?? 0);

    // if (kDebugMode) {
    //   print(
    //       "Calculating today's return for stock ${stock.id}. Reference Price: $referencePrice, Current Price: $price");
    // }

    if (referencePrice > 0) {
      if (stock.tradeType == 'Short') {
        todaysReturn = (referencePrice - price) * stock.quantity!;
        todaysReturnPercentage = ((referencePrice - price) / price) * 100;
      } else {
        todaysReturn = (price - referencePrice) * stock.quantity!;
        todaysReturnPercentage =
            ((price - referencePrice) / referencePrice) * 100;
      }
    }

    // Save today's return in the map using stock id
    _dataMap[stock.id!] = {
      'todaysReturn': todaysReturn,
      'todaysReturnPercentage': todaysReturnPercentage
    };

    return {
      'todaysReturn': todaysReturn,
      'todaysReturnPercentage': todaysReturnPercentage
    };
  }

  bool _isStockBoughtToday(TsOpenListRes stock, DateTime responseDate) {
    String createdAtDate =
        DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
    String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
    if (kDebugMode) {
      print(
          'Checking if stock was bought today: $createdAtDate vs $responseDateString');
    }
    return createdAtDate == responseDateString;
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
        (_extra?.executable == true || kDebugMode)) {
      for (var data in _data!) {
        if (data.id == null) return;
        _updateStockData(
          data.id ?? 0,
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
              if (data.id == null) return;
              _updateStockData(data.id ?? 0, stockData);
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



  // void _updateStockData(int id, StockDataManagerRes stockData) {
  //   Utils().showLog('Holding: ${stockData.toMap()}');
  //   if (_data == null) return;

  //   int index = _data!.indexWhere((stock) => stock.id == id);
  //   if (index == -1) return; // Exit early if stock not found

  //   TsOpenListRes stock = _data![index];
  //   num shares = stock.quantity ?? 0;
  //   num invested = stock.invested ?? 0;

  //   // Assign values only if they are not null
  //   stock.currentPrice = stockData.price ?? stock.currentPrice;
  //   stock.change = stockData.change ?? stock.change;
  //   stock.changesPercentage =
  //       stockData.changePercentage ?? stock.changesPercentage;
  //   stock.previousClose = stockData.previousClose ?? stock.previousClose;

  //   // Update stock's current invested value
  //   stock.currentInvested = (stock.currentPrice ?? 0) * shares;
  //   num investedChange = (stock.tradeType == 'Short')
  //       ? invested - (stock.currentInvested ?? 0)
  //       : (stock.currentInvested ?? 0) - invested;

  //   stock.investedChange = investedChange;

  //   // Unified percentage calculation
  //   stock.investedChangePercentage =
  //       (invested > 0) ? (investedChange / invested) * 100 : 0;

  //   _data![index] = stock;
  //   notifyListeners(); // Notify UI update
  // }