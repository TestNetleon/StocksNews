import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../tournament/provider/trades.dart';
import '../../widgets/custom/alert_popup.dart';
import '../screens/tradeBuySell/index.dart';

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

  Future stockHolding({
    bool buy = true,
    required int index,
  }) async {
    Utils().showLog('Checking holdings for $buy');
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _data?[index].symbol ?? '',
        'edit': '1',
      };

      ApiResponse res = await apiRequest(
          url: Apis.stockHoldings, request: request, showProgress: true);
      if (res.status) {
        if (!buy && res.data['quantity'] <= 0) {
          popUpAlert(
              title: 'Alert',
              message: "You don't own the shares of this stock");
          return;
        }

        StockDetailProviderNew provider =
            navigatorKey.currentContext!.read<StockDetailProviderNew>();

        ApiResponse response = await provider.getTabData(
          symbol: _data?[index].symbol,
          showProgress: true,
          startSSE: true,
        );
        if (response.status) {
          Navigator.pushReplacement(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => TradeBuySellIndex(
                buy:
                    data?[index].tradeType?.toLowerCase() == StockType.buy.name,
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
}
