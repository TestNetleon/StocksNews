import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_open_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class SOpenManager extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsOpenListRes>? _data;
  List<TsOpenListRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  final Map<int, Map<String, dynamic>> _dataMap = {};

  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  void _updateStockData(
    TsOpenListRes holdingStk,
    StockDataManagerRes stockData,
  ) {
    if (_data == null) return;
    List<TsOpenListRes>? tempData = _data!.where((stock) {
      return stock.symbol == holdingStk.symbol;
    }).toList();

    for (final stk in tempData) {
      int index = _data!.indexWhere((stock) {
        return stock.id == stk.id;
      });

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
    }

    notifyListeners();
    PortfolioManager manager = navigatorKey.currentContext!.read<PortfolioManager>();

    num totalMarketValue = 0;
    num todaysReturn = 0;

    _dataMap.removeWhere((id, value) {
      if (_data!.every((stock) => stock.id != id)) {
        return true;
      }
      return false;
    });

    for (var stock in _data!) {
      Map<String, num> returnData = _calculateTodaysReturn(stock);

      totalMarketValue += stock.currentInvested ?? 0;

      todaysReturn += returnData['todaysReturn'] ?? 0;
      if (_dataMap.containsKey(stock.id)) {
        _dataMap[stock.id]!['todaysReturn'] = returnData['todaysReturn']!;
      } else {
        _dataMap[stock.id!] = {
          'todaysReturn': returnData['todaysReturn']!,
          'todaysReturnPercentage': returnData['todaysReturnPercentage']!,
        };
      }
      notifyListeners();
    }
    manager.updateBalance(totalReturn: 0);

    num? mainReturn = 0;

    if (_data != null && _data!.isNotEmpty) {
      mainReturn = _data!
          .map((item) => item.investedChange ?? 0.0)
          .fold(0.0, (prev, element) => prev + element);
    }
    notifyListeners();

    manager.updateBalance(
      marketValue: totalMarketValue,
      totalReturn: mainReturn,
      todayReturn: todaysReturn,
    );
  }

  Map<String, num> _calculateTodaysReturn(
      TsOpenListRes stock) {
    num todaysReturn = 0;
    num todaysReturnPercentage = 0;
    num price = stock.currentPrice ?? 0;
    PortfolioManager manager = navigatorKey.currentContext!.read<PortfolioManager>();
    bool boughtToday = _isStockBoughtToday(stock, manager.userData!.reponseTime!);
    num referencePrice = boughtToday
        ? (stock.avgPrice ?? 0)
        : (stock.previousClose ?? 0);
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
    return createdAtDate == responseDateString;
  }

//MARK: API Call
  Future<void> getData() async {
    setStatus(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.tsOrderList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _data = tsOpenListResFromJson(jsonEncode(response.data));
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

  Future<bool> squareOffRequest(id) async {
    // TsPortfolioProvider provider =
    //     navigatorKey.currentContext!.read<TsPortfolioProvider>();
    // await provider.getDashboardData();
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "portfolio_trade_id": id
      };

      ApiResponse response = await apiRequest(
        url: Apis.squareOff,
        request: request,
        showProgress: false,
      );

      setStatus(Status.loaded);
      if (response.status) {
        return true;
      } else {
        TopSnackbar.show(
          message: response.message ?? '',
          type: ToasterEnum.error,
        );
        return false;
      }
    } catch (e) {
      Utils().showLog('Open data: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatus(Status.loaded);
      return false;
    }
  }

// MARK: SSE Manager
  void _connectSSEForSymbols(List<String> symbols) {
    PortfolioManager manager = navigatorKey.currentContext!.read<PortfolioManager>();
    if (_data != null &&
        _data?.isNotEmpty == true &&
        (manager.userData?.userDataRes?.executable == true)) {
      for (var data in _data!) {

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
