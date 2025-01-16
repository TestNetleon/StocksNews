import 'package:flutter/material.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../manager/sse.dart';

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
