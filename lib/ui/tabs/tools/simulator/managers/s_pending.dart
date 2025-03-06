
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/ConditionalTrades.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class SPendingManager extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsPendingListRes>? _data;
  List<TsPendingListRes>? get data => _data;

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
        //"token": navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "page": '$_page',
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsPendingList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        if (_page == 1) {
          _data = tsPendingListResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
          _error = null;

          if (_data?.length != null && _data?.isNotEmpty == true) {
            BrazeService.brazeBaseEvents(
              attributionKey: 'has_pending_trades',
              attributeValue: true,
            );
          }
        } else {
          _data?.addAll(
            tsPendingListResFromJson(jsonEncode(response.data)),
          );
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message ?? Const.errSomethingWrong;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      if (_page == 1) {
        _data = null;
        _error = Const.errSomethingWrong;
      }
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future cancleOrder(id) async {
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: '${Apis.cancleOrder}$id',
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

  Future editStock({
    required int index,
  }) async {
    Utils().showLog('Checking holdings for ${_data?[index].tradeType ?? ''}');
    try {
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': manager.user?.token ?? '',
        'symbol': _data?[index].symbol ?? '',
        'action': _data?[index].tradeType == "Sell"
            ? "SELL"
            : _data?[index].tradeType == "Buy"
                ? "BUY"
                : "BUY_TO_COVER",
        'edit': '1',
        'order_type':"MARKET_ORDER",
        'trade_id':"${_data?[index].id ?? ''}",
      };

      ApiResponse res = await apiRequest(
          url: Apis.stockHoldings, request: request, showProgress: true);
      if (res.status) {
        if ((_data?[index].tradeType == "Sell" ||
                _data?[index].tradeType == "But To Cover") &&
            res.data['quantity'] <= 0) {
          popUpAlert(
              title: 'Alert',
              message: "You don't own the shares of this stock");
          return;
        }

        TradeManager manager =
            navigatorKey.currentContext!.read<TradeManager>();

        ApiResponse response = await manager.getDetailTopData(
          symbol: _data?[index].symbol ?? '',
          showProgress: true,
        );
        if (response.status) {
          Navigator.pushReplacementNamed(navigatorKey.currentContext!, TradeBuySellIndex.path,
              arguments: {
            "stockType":_data?[index].tradeType == "Buy"
                ? StockType.buy
                : _data?[index].tradeType == "Sell"
                ? StockType.sell
                : StockType.btc,
            "qty":res.data['quantity'],
            "editTradeID": _data?[index].id,
          }
          );
          /*Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => TradeBuySellIndex(
                selectedStock: _data?[index].tradeType == "Buy"
                    ? StockType.buy
                    : _data?[index].tradeType == "Sell"
                        ? StockType.sell
                        : StockType.btc,
                qty: res.data['quantity'],
                editTradeID: _data?[index].id,
              ),
            ),
          );*/
        }
      } else {
        //
      }
      return ApiResponse(status: res.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future shortRedirection({required int index}) async {
    try {
      TradeManager manager =
      navigatorKey.currentContext!.read<TradeManager>();

      ApiResponse response = await manager.getDetailTopData(
        symbol: _data?[index].symbol ?? '',
        showProgress: true,
      );
      if (response.status) {
        Navigator.pushReplacementNamed(navigatorKey.currentContext!, TradeBuySellIndex.path,
            arguments: {
              "stockType":_data?[index].tradeType == "Buy"
                  ? StockType.buy
                  : _data?[index].tradeType == "Sell"
                  ? StockType.sell
                  : StockType.btc,
              "qty":0,
              "editTradeID": _data?[index].id,
            }
        );
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future stockHoldingOfCondition({required int index}) async {
    try {
      UserManager manager = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': manager.user?.token ?? '',
        'symbol': _data?[index].symbol ?? '',
        'action':_data?[index].tradeType=="Buy To Cover"?"BUY_TO_COVER":_data?[index].tradeType?.toUpperCase()??'',
        'order_type': _data?[index].orderTypeOriginal??"",
        'trade_id':"${_data?[index].id ?? ''}",
        'edit': '1',
      };
      ApiResponse res = await apiRequest(
          url: Apis.stockHoldings, request: request, showProgress: true);
      if (res.status) {
        if ((_data?[index].tradeType == "Sell"||
            _data?[index].tradeType == "But To Cover") && res.data['quantity'] <= 0) {
          popUpAlert(
              title: 'Alert',
              message: "You don't own the shares of this stock");
          return;
        }
        TradeManager manager =
        navigatorKey.currentContext!.read<TradeManager>();

        ApiResponse response = await manager.getDetailTopData(
          symbol: _data?[index].symbol ?? '',
          showProgress: true,
        );
        if (response.status) {
          Navigator.pushReplacementNamed(navigatorKey.currentContext!, ConditionalTradesIndex.path,
              arguments: {
                "conditionType": _data?[index].orderTypeOriginal == "BRACKET_ORDER"?ConditionType.bracketOrder:
                _data?[index].orderTypeOriginal == "LIMIT_ORDER"?ConditionType.limitOrder:
                _data?[index].orderTypeOriginal == "STOP_ORDER"?ConditionType.stopOrder:
                _data?[index].orderTypeOriginal == "STOP_LIMIT_ORDER"?ConditionType.stopLimitOrder:ConditionType.trailingOrder,
                "qty":res.data['quantity'],
                "editTradeID":_data?[index].id,
              }
          );
        }
      } else {
        //
      }
      return ApiResponse(status: res.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }
}
