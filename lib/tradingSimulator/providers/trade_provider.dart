import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../providers/user_provider.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../manager/sse.dart';
import '../modals/ts_topbar.dart';

class TradeProviderNew extends ChangeNotifier {
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
          Utils().showLog('Detail: ${data.toMap()}');
          _tappedStock = data;
          notifyListeners();
        },
        SimulatorEnum.detail,
        // SimulatorEnum.detail,
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
      // if (response.status) {
      //   // _dataNew = searchNewResFromJson(jsonEncode(response.data));
      // } else {
      //   // _dataNew = null;
      //   // _errorS = response.message;
      // }
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
        formData: request,
        showProgress: showProgress,
      );
      notifyListeners();
      return response;
      // if (response.status) {
      //   // _dataNew = searchNewResFromJson(jsonEncode(response.data));
      // } else {
      //   // _dataNew = null;
      //   // _errorS = response.message;
      // }
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

  TsStockDetailRes? _detailRes;
  TsStockDetailRes? get detailRes => _detailRes;

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getDetailTopData({
    required String symbol,
    bool showProgress = false,
  }) async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "symbol": symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.tsTopBar,
        showProgress: showProgress,
        request: request,
      );
      if (response.status) {
        _detailRes = tsStockDetailTabResFromJson(jsonEncode(response.data));
        _error = null;

        try {
          SSEManager.instance.connectStock(
            screen: SimulatorEnum.detail,
            symbol: symbol,
          );

          SSEManager.instance.addListener(
            symbol,
            (stockData) {
              Utils().showLog('Detail: ${stockData.toMap()}');

              if (stockData.price != null) {
                _detailRes?.currentPrice = stockData.price;
                _detailRes?.change = stockData.change;
              }
              if (stockData.change != null) {
                _detailRes?.change = stockData.change;
              }
              if (stockData.changePercentage != null) {
                _detailRes?.changePercentage = stockData.changePercentage;
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
      print("Error formatting time: $e");
      return time;
    }
  }
}

class SummaryOrderNew {
  String? image, symbol, name, change, price;
  num? changePercentage, invested, shares, dollars;
  bool isShare;
  bool buy;
  String? date;
  SummaryOrderNew({
    this.image,
    this.symbol,
    this.name,
    this.dollars,
    this.shares,
    this.change,
    this.price,
    this.changePercentage,
    this.invested,
    this.date,
    required this.buy,
    this.isShare = false,
  });
}
