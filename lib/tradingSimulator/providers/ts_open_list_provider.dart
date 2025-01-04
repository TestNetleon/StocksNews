import 'dart:convert';

import 'package:flutter/material.dart';
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

//
class TsOpenListProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsOpenListRes>? _data;
  List<TsOpenListRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int _page = 1;
  bool get canLoadMore => _page < (_extra?.totalPages ?? 1);

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  // Listener for updating data
  void _updateStockData(String symbol, StockDataManagerRes stockData) {
    if (_data != null && _data?.isNotEmpty == true) {
      final index = _data!.indexWhere((stock) => stock.symbol == symbol);
      num? shares = _data?[index].quantity ?? 0;
      num? invested = _data?[index].invested ?? 0;
      if (index != -1) {
        TsOpenListRes? existingStock = _data?[index];
        existingStock?.currentPrice = stockData.price;
        existingStock?.change = stockData.change;
        existingStock?.changesPercentage = stockData.changePercentage;
        existingStock?.currentInvested = (stockData.price ?? 0) * shares;
        existingStock?.investedChange =
            (existingStock.currentInvested ?? 0) - invested;

        existingStock?.investedChangePercentage =
            ((existingStock.investedChange ?? 0) / invested) * 100;

        Utils().showLog('Updating for $symbol, Price: ${stockData.price}');
      } else {
        TsOpenListRes newStock = TsOpenListRes(
            symbol: symbol,
            currentPrice: stockData.price,
            change: stockData.change,
            changesPercentage: stockData.changePercentage,
            currentInvested: (stockData.price ?? 0) * shares,
            investedChange: ((stockData.price ?? 0) * shares) - invested,
            investedChangePercentage:
                (((stockData.price ?? 0) * shares) - invested / invested) *
                    100);

        _data?.add(newStock);
      }
    }

    notifyListeners();
  }

  Future getData({loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "mssql_id":
            "${navigatorKey.currentContext!.read<TsPortfolioProvider>().userData?.sqlId}",
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsOrderList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        if (_page == 1) {
          _data = tsOpenListResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
          _error = null;
        } else {
          _data?.addAll(
            tsOpenListResFromJson(jsonEncode(response.data)),
          );
        }

        List<String> symbols =
            _data?.map((stock) => stock.symbol ?? '').toList() ?? [];
        // SSEManager.instance.disconnectAll();
        // SSEManager.instance.connectToSSEForMultipleStocks(symbols);

        SSEManager.instance.connectMultipleStocks(
          screen: SimulatorEnum.open,
          symbols: symbols,
        );
        for (var symbol in symbols) {
          SSEManager.instance.addListener(symbol,
              (StockDataManagerRes stockData) {
            _updateStockData(symbol, stockData);
          });
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message ?? Const.errSomethingWrong;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  num parseCurrencyString(String currencyString) {
    try {
      // Step 1: Remove any non-numeric characters (e.g., $, commas)
      String cleanedString = currencyString.replaceAll(RegExp(r'[^\d.]'), '');

      // Step 2: Convert the cleaned string to a number
      return double.parse(cleanedString);
    } catch (e) {
      // If the parsing fails, return a default value (e.g., 0)
      print("Error parsing currency string: $e");
      return 0;
    }
  }
}
