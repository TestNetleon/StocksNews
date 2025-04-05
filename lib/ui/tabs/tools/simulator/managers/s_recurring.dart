import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/conditionalOrder/RecurringOrder/recurring_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class SRecurringManager extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsRecurringListRes>? _data;
  List<TsRecurringListRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getData() async {
    setStatus(Status.loading);
    try {
      Map request = {
        //"token": navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.recurringList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _data = tsRecurringListResFromJson(jsonEncode(response.data));
        _extra = response.extra is Extra ? response.extra as Extra : null;
        _error = null;
        List<String>? symbols = _data
                ?.where((trade) =>
                    trade.statusType != "CANCEL" && trade.symbol != null)
                .map((trade) => trade.symbol!)
                .toList() ??
            [];

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
      Utils().showLog('Recurring data: $e');
      setStatus(Status.loaded);
    }
  }

  Status _detailStatus = Status.ideal;
  Status get detailStatus => _detailStatus;
  bool get isDetailLoading =>
      _detailStatus == Status.loading || _detailStatus == Status.ideal;

  void setDetailStatus(Status status) {
    _detailStatus = status;
    notifyListeners();
  }

  RecurringDetailRes? _detailData;
  RecurringDetailRes? get detailData => _detailData;
  Future<void> getRecurringDetail(tradeID) async {
    setDetailStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.recurringDetail + tradeID,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _detailData = recurringDetailResFromMap(jsonEncode(response.data));
        _error = null;
      } else {
        _detailData = null;
        _error = response.message ?? Const.errSomethingWrong;
      }

      setDetailStatus(Status.loaded);
    } catch (e) {
      _detailData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Recurring data: $e');
      setDetailStatus(Status.loaded);
    }
  }

  Future cancelOrder(id) async {
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: '${Apis.recurringClose}$id',
        request: request,
        showProgress: true,
      );
      if (response.status) {
        Navigator.pop(navigatorKey.currentContext!);
        getData();
      } else {
        //
      }
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );

      notifyListeners();
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('cancle order error: $e');
      notifyListeners();
      return ApiResponse(status: false);
    }
  }

  Future recurringCondition(String symbol, {required int index}) async {
    try {
      TradeManager manager = navigatorKey.currentContext!.read<TradeManager>();
      ApiResponse response = await manager.getDetailTopData(
        symbol: symbol,
        showProgress: true,
      );
      if (response.status) {
        // Navigator.pushReplacementNamed(navigatorKey.currentContext!, RecurringIndex.path,
        //     arguments: {
        //       "editTradeID":_data?[index].id,
        //     }
        // );
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => RecurringIndex(
              editTradeID: _data?[index].id,
            ),
          ),
        );
      } else {
        Utils().showLog('stock holding: ${response.message}');
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  final Map<int, Map<String, dynamic>> _dataMap = {};

  void _updateStockData(
      TsRecurringListRes holdingStk, StockDataManagerRes stockData) {
    if (_data == null) return;

    List<TsRecurringListRes>? tempData = _data!.where((stock) {
      return stock.symbol == holdingStk.symbol;
    }).toList();

    for (final stk in tempData) {
      int index = tempData.indexWhere((stock) {
        return stock.id == stk.id;
      });
      if (index == -1) return;
      TsRecurringListRes stock = tempData[index];

      num shares = stock.quantity ?? 0;
      num invested = stock.totalInvested ?? 0;
      stock.currentPrice = stockData.price ?? stock.currentPrice;

      stock.change = stockData.change ?? stock.change;
      stock.changesPercentage =
          stockData.changePercentage ?? stock.changesPercentage;

      stock.previousClose = stockData.previousClose ?? stock.previousClose;

      stock.currentValuation = (stock.currentPrice ?? 0) * shares;
      num investedChange = (stock.currentValuation ?? 0) - invested;
      stock.investedChange = investedChange;
      stock.investedChangePercentage =
          (invested > 0) ? (investedChange / invested) * 100 : 0;

      tempData[index] = stock;
    }
    notifyListeners();
  }

  Map<String, num> _calculateTodaysReturn(TsRecurringListRes stock) {
    num todaysReturn = 0;
    num todaysReturnPercentage = 0;
    num price = stock.currentPrice ?? 0;
    bool boughtToday = _isStockBoughtToday(stock, _extra!.reponseTime!);
    num referencePrice =
        boughtToday ? (stock.averagePrice ?? 0) : (stock.previousClose ?? 0);

    if (referencePrice > 0) {
      todaysReturn = (price - referencePrice) * stock.quantity!;
      todaysReturnPercentage =
          ((price - referencePrice) / referencePrice) * 100;
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

  bool _isStockBoughtToday(TsRecurringListRes stock, DateTime responseDate) {
    String createdAtDate =
        DateFormat('yyyy-MM-dd').format(stock.createdAt ?? DateTime.now());
    String responseDateString = DateFormat('yyyy-MM-dd').format(responseDate);
    return createdAtDate == responseDateString;
  }

  void _connectSSEForSymbols(List<String> symbols) {
    Utils().showLog('symbols : ${symbols.toString()}');
    if (_data != null &&
        _data?.isNotEmpty == true &&
        (_extra?.executable == true)) {
      for (var data in _data!) {
        if (data.id == null) return;
        if (data.statusType == "CANCEL") {
          Utils().showLog('CANCEL statusType: ${data.symbol}');
        } else {
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
              screen: SimulatorEnum.recurring,
              symbols: symbols,
            );

            SSEManager.instance.addListener(
              data.symbol ?? '',
              (StockDataManagerRes stockData) {
                if (data.id == null) return;
                _updateStockData(data, stockData);
              },
              SimulatorEnum.recurring,
            );
          } catch (e) {
            //
          }
        }
      }
    } else {
      if (kDebugMode) {
        print('not executable');
      }
    }
  }
}
