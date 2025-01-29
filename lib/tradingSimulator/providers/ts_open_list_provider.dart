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

  void _updateStockData(
      TsOpenListRes holdingStk, StockDataManagerRes stockData) {
    Utils().showLog('Holding: ${stockData.toMap()}');
    if (_data == null) return;

    // int index = _data!.indexWhere((stock) {
    //   // Utils().showLog('Holding: $id == ${stockData.symbol}');
    //   return stock.id == holdingStk.id;
    // });

    List<TsOpenListRes>? tempData = _data!.where((stock) {
      // Utils().showLog('Holding: $id == ${stockData.symbol}');
      return stock.symbol == holdingStk.symbol;
    }).toList();

    for (final stk in tempData) {
      int index = _data!.indexWhere((stock) {
        // Utils().showLog('Holding: $id == ${stockData.symbol}');
        return stock.id == stk.id;
      });

      if (index == -1) return;

      TsOpenListRes stock = _data![index];

      // Utils().showLog('Updated Index : index == $index');
      // Utils().showLog(
      //   'Match with Holding: ${stock.symbol} == ${stockData.symbol}',
      // );

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
    }

    // Utils().showLog(
    //     'Holding: $id == ${stockData.symbol} index=$index  list length = ${_data?.length}');

    // if (index == -1) return;

    // TsOpenListRes stock = _data![index];

    // Utils().showLog('Updated Index : index == $index');
    // // Utils().showLog(
    // //   'Match with Holding: ${stock.symbol} == ${stockData.symbol}',
    // // );

    // num shares = stock.quantity ?? 0;
    // num invested = stock.invested ?? 0;

    // stock.currentPrice = stockData.price ?? stock.currentPrice;

    // stock.change = stockData.change ?? stock.change;

    // stock.changesPercentage =
    //     stockData.changePercentage ?? stock.changesPercentage;

    // stock.previousClose = stockData.previousClose ?? stock.previousClose;

    // stock.currentInvested = (stock.currentPrice ?? 0) * shares;
    // num investedChange = (stock.tradeType == 'Short')
    //     ? invested - (stock.currentInvested ?? 0)
    //     : (stock.currentInvested ?? 0) - invested;

    // stock.investedChange = investedChange;

    // stock.investedChangePercentage =
    //     (invested > 0) ? (investedChange / invested) * 100 : 0;

    // _data![index] = stock;

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
      // TODO:

      Map<String, num> returnData = _calculateTodaysReturn(
          // stockData,
          stock);

      // Utils().showLog("RETURN DATA => ${stock.id} = $returnData");

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

    provider.updateBalance(
      marketValue: totalMarketValue,
      totalReturn: mainReturn,
      todayReturn: todaysReturn,
    );

    notifyListeners();
  }

  Map<String, num> _calculateTodaysReturn(
      // StockDataManagerRes stockData,
      TsOpenListRes stock) {
    // Utils().showLog("IDS==> ${stock.id}");

    num todaysReturn = 0;
    num todaysReturnPercentage = 0;
    num price =
        // stockData.price ??
        stock.currentPrice ?? 0;
    // Utils().showLog("TODAYS price => ${stock.symbol}(${stock.id}) => $price");

    bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
    num referencePrice = boughtToday
        ? (stock.avgPrice ?? 0)
        : (
            // stockData.previousClose ??
            stock.previousClose ?? 0);

    // Utils().showLog(
    //     "TODAYS referencePrice => ${stock.symbol}(${stock.id}) => $referencePrice"
    // );

    if (referencePrice > 0) {
      if (stock.tradeType == 'Short') {
        todaysReturn = (referencePrice - price) * stock.quantity!;
        todaysReturnPercentage = ((referencePrice - price) / price) * 100;
      } else {
        todaysReturn = (price - referencePrice) * stock.quantity!;
        // Utils().showLog(
        //     "TODAYS RET => ${stock.symbol}(${stock.id}) \n Quantity => ${stock.quantity}\nCurrentPrice = > ${stock.currentPrice}\nPrice => ${price}\nERef Price => ${referencePrice}\nTodays return => ${todaysReturn}");
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
        symbols = symbols.toSet().toList();
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
        // Utils().showLog("Listening for != > ${data.id}");

        if (data.id == null) return;
        _updateStockData(
          data,
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
              // Utils().showLog("Listening for = > ${data.id}");
              if (data.id == null) return;
              _updateStockData(data, stockData);
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
//   void _updateStockData(String id, StockDataManagerRes stockData) {
//     if (_data == null || _data!.isEmpty) return;

//     final index = _data!.indexWhere((stock) => stock.id.toString() == id);
//     if (index == -1) {
//       Utils().showLog("Stock with symbol $id not found in _data.");
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

//     _stockReturnMap[id] = returnData;

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
//           data.id.toString(),
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
//               _updateStockData(data.id.toString(), stockData);
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