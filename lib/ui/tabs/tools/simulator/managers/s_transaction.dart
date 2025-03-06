import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class STransactionManager extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsPendingListRes>? _data;
  List<TsPendingListRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int _page = 1;
  bool get canLoadMore => _page <= (_extra?.totalPages ?? 1);

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void _updateStockData(String symbol, StockDataManagerRes stockData) {
    if (_data != null && _data?.isNotEmpty == true) {
      final index = _data!.indexWhere((stock) => stock.symbol == symbol);
      if (index == -1) {
        Utils().showLog("Stock with symbol $symbol not found in _data.");
        return;
      }
      TsPendingListRes? existingStock = _data?[index];
      existingStock?.currentPrice = stockData.price;

      Utils().showLog('Updating for $symbol, Price: ${stockData.price}');
    }

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
        // "token": navigatorKey.currentContext!.read<UserManager>().user?.token ?? "",
        "page": '$_page',
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsTransaction,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        if (_page == 1) {
          _data = tsPendingListResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
          _error = null;
        } else {
          _data?.addAll(tsPendingListResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message ?? Const.errSomethingWrong;
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
