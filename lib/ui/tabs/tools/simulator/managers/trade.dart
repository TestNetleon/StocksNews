import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TradeManager extends ChangeNotifier {
  //MARK: Sheet Stock
  StockDataManagerRes? _tappedStock;
  StockDataManagerRes? get tappedStock => _tappedStock;

  setTappedStock(StockDataManagerRes? stock) {
    try {
      _tappedStock = null;
      _tappedStock = stock;
      notifyListeners();

      SSEManager.instance.connectStock(
        symbol: stock?.symbol ?? "",
        screen: SimulatorEnum.detail,
      );

      SSEManager.instance.addListener(
        stock?.symbol ?? '',
        (data) {
          _tappedStock = data;
          notifyListeners();
        },
        SimulatorEnum.detail,
      );
    } catch (e) {
      Utils().showLog('---$e');
    }
  }

  //MARK: Buy Share API
  Future<ApiResponse> requestBuyShare(request, {showProgress = false}) async {
    notifyListeners();
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsRequestTrade,
        request: request,
        showProgress: showProgress,
      );
      notifyListeners();

      return response;
    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();

      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  //MARK: Sell Share API
  Future<ApiResponse> requestSellShare(request, {showProgress = false}) async {
    notifyListeners();
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsRequestTrade,
        request: request,
        showProgress: showProgress,
      );
      notifyListeners();
      return response;

    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  Future<ApiResponse> tsAddConditional(request, num id,
      {showProgress = false}) async {
    notifyListeners();
    try {
      ApiResponse response = await apiRequest(
        url: '${Apis.tsAddConditional}$id',
        request: request,
        showProgress: showProgress,
      );
      notifyListeners();
      return response;

    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  //MARK: Update Share API
  Future<ApiResponse> requestUpdateShare({
    Map? request,
    showProgress = false,
    required num id,
  }) async {
    notifyListeners();
    try {
      ApiResponse response = await apiRequest(
        url: '${Apis.updateOrder}$id',
        request: request,
        showProgress: showProgress,
      );
      notifyListeners();
      return response;
    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

//MARK: Detail Top API

  BaseTickerRes? _detailRes;
  BaseTickerRes? get detailRes => _detailRes;

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;
  bool short = false;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  shortStatus(shortValue) {
    short = shortValue;
    Navigator.pop(navigatorKey.currentContext!);
    notifyListeners();
  }

  Future getDetailTopData({
    required String symbol,
    bool showProgress = false,
  }) async {
    setStatus(Status.loading);
    try {
      Map request = {
        "symbol": symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.tsTopBar,
        showProgress: showProgress,
        request: request,
      );
      if (response.status) {
        _detailRes = baseTickerFromJson(jsonEncode(response.data));
        _error = null;

        try {
          _detailRes?.marketTime =
              _formatExtendedHoursTime(_detailRes?.marketTime);
          SSEManager.instance.connectStock(
            screen: SimulatorEnum.detail,
            symbol: symbol,
          );

          SSEManager.instance.addListener(
            symbol,
            (stockData) {
              // Utils().showLog('Detail: ${stockData.toMap()}');

              if (stockData.price != null) {
                _detailRes?.price = stockData.price;
                _detailRes?.change = stockData.change;
              }
              if (stockData.change != null) {
                _detailRes?.change = stockData.change;
              }
              if (stockData.changePercentage != null) {
                _detailRes?.changesPercentage = stockData.changePercentage;
              }

              _detailRes?.marketType = stockData.type;

              if (stockData.time != null) {
                _detailRes?.marketTime =
                    _formatExtendedHoursTime(stockData.time);
              }
              notifyListeners();
            },
            SimulatorEnum.detail,
          );
        } catch (e) {
          //
        }
      } else {
        _detailRes = null;
        _error = response.message;
      }
      setStatus(Status.loaded);

      return ApiResponse(status: response.status);
    } catch (e) {
      _detailRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error $e');
      setStatus(Status.loaded);
      return ApiResponse(status: false);
    }
  }

  String _formatExtendedHoursTime(String? time) {
    if (time == null) {
      return '';
    }
    try {
      // Parse the input time (assuming it's in HH:mm:ss.SSS format)
      final inputFormat = DateFormat("HH:mm:ss.SSS");
      final dateTime = inputFormat.parse(time);

      // Convert it to the desired output format
      final outputFormat = DateFormat("h:mm:ss a");
      final formattedTime = outputFormat.format(dateTime);

      // Append the timezone abbreviation
      return "$formattedTime EST";
    } catch (e) {
      return time;
    }
  }

  void updateTickerInfo({required String symbol, alertAdded, watchListAdded}) {
    if (_detailRes != null) {
      if (alertAdded != null) {
        _detailRes?.isAlertAdded = alertAdded;
      }
      if (watchListAdded != null) {
        _detailRes?.isWatchlistAdded = watchListAdded;
      }
      notifyListeners();
    }
  }


}

class SummaryOrderNew {
  String? image, symbol, name, change, price;
  num? changePercentage,
      invested,
      shares,
      dollars,
      currentPrice,
      targetPrice,
      stopPrice,
      limitPrice,
      investedPrice;
  bool isShare;
  StockType? selectedStock;
  String? date;
  int? selectedOption;
  SummaryOrderNew({
    this.image,
    this.symbol,
    this.name,
    this.dollars,
    this.shares,
    this.change,
    this.price,
    this.currentPrice,
    this.targetPrice,
    this.stopPrice,
    this.limitPrice,
    this.investedPrice,
    this.changePercentage,
    this.invested,
    this.date,
    this.selectedStock,
    this.selectedOption,
    this.isShare = false,
  });
}
