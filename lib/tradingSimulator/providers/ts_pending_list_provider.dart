import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/screens/ConditionalOrder/ConditionalTrades.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../tournament/provider/trades.dart';
import '../../widgets/custom/alert_popup.dart';
import '../screens/tradeBuySell/index.dart';
import 'trade_provider.dart';

//
class TsPendingListProvider extends ChangeNotifier {
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
    // navigatorKey.currentContext!.read<TsPortfolioProvider>().getDashboardData();
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
        // "token": 'g74rffbRxdXF6iJ5RrWe',
        // "mssql_id":
        //     "${navigatorKey.currentContext!.read<TsPortfolioProvider>().userData?.sqlId}",
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
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
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
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
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
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _data?[index].symbol ?? '',
        'action': _data?[index].tradeType == "Sell"
            ? "SELL"
            : _data?[index].tradeType == "Buy"
                ? "BUY"
                : "BUY_TO_COVER",
        'edit': '1',
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

        TradeProviderNew provider =
            navigatorKey.currentContext!.read<TradeProviderNew>();

        ApiResponse response = await provider.getDetailTopData(
          symbol: _data?[index].symbol ?? '',
          showProgress: true,
        );
        if (response.status) {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => TradeBuySellIndex(
                selectedStock: _data?[index].tradeType == "Buy"
                    ? StockType.buy
                    : _data?[index].tradeType == "Sell"
                        ? StockType.sell
                        : StockType.btc,
                qty: res.data['quantity'],
                editTradeID: data?[index].id,
              ),
            ),
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

  Future shortRedirection({required int index}) async {
    try {
      TradeProviderNew provider =
          navigatorKey.currentContext!.read<TradeProviderNew>();

      ApiResponse response = await provider.getDetailTopData(
        symbol: _data?[index].symbol ?? '',
        showProgress: true,
      );
      if (response.status) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => TradeBuySellIndex(
              selectedStock: StockType.short,
              qty: 0,
              editTradeID: data?[index].id,
            ),
          ),
        );
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }

  Future conditionalRedirection({required int index}) async {
    try {
      TradeProviderNew provider =
          navigatorKey.currentContext!.read<TradeProviderNew>();
      ApiResponse response = await provider.getDetailTopData(
        symbol: _data?[index].symbol ?? '',
        showProgress: true,
      );
      if (response.status) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => ConditionalTradesIndex(
              conditionalType: ConditionType.bracketOrder,
              editTradeID: data?[index].id,
            ),
          ),
        );
      }
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog('stock holding: $e');
      return ApiResponse(status: false);
    }
  }
}
