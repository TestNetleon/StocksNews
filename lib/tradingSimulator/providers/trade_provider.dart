import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../modals/search_new.dart';
import '../../modals/top_search_res.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../providers/user_provider.dart';

class TradeProviderNew extends ChangeNotifier {
  List<SummaryOrderNew> orders = [];

  UserBalanceDataNew data = UserBalanceDataNew(
    availableBalance: 100000,
    invested: 0,
  );

  void addOrderData(SummaryOrderNew? order) {
    Utils().showLog("------Buy order");

    try {
      if (order != null) {
        int existingOrderIndex =
            orders.indexWhere((o) => o.symbol == order.symbol);
        num shares = order.shares ?? 0;
        num dollars = order.dollars ?? 0;
        String cleanedString =
            order.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "";
        num price = num.parse(cleanedString);
        num invested = order.isShare ? (price * shares) : dollars;

        if (invested > data.availableBalance) {
          popUpAlert(
            message: "Insufficient available balance to place this order.",
            title: "Alert",
          );
          return;
        }

        if (existingOrderIndex != -1) {
          SummaryOrderNew existingOrder = orders[existingOrderIndex];
          num existingShares = existingOrder.shares ?? 0;
          num newShares = order.shares ?? 0;
          num totalShares = existingShares + newShares;
          num existingDollars = existingOrder.dollars ?? 0;
          num newDollars = order.dollars ?? 0;
          num totalDollars = existingDollars + newDollars;
          num existingInvested = existingOrder.invested ?? 0;
          num newInvested = order.invested ?? 0;
          num totalInvested = existingInvested + newInvested;

          orders[existingOrderIndex] = SummaryOrderNew(
            image: order.image,
            symbol: order.symbol,
            name: order.name,
            shares: totalShares,
            dollars: totalDollars,
            price: order.price,
            change: order.change,
            changePercentage: order.changePercentage,
            invested: totalInvested,
            isShare: order.isShare,
            buy: order.buy,
          );
        } else {
          orders.add(order);
        }

        data = UserBalanceDataNew(
          availableBalance: data.availableBalance - invested,
          invested: data.invested + invested,
        );
      } else {
        Utils().showLog("ELSE: Received null order");
      }

      notifyListeners();
    } catch (e) {
      Utils().showLog("Error: $e");
    }
  }

  void addAmount(num amount) {
    data.availableBalance = data.availableBalance + amount;
    notifyListeners();
  }

  void sellOrderData(SummaryOrderNew? order) {
    Utils().showLog("------Sell order");
    try {
      if (order != null) {
        int existingOrderIndex =
            orders.indexWhere((o) => o.symbol == order.symbol);
        if (existingOrderIndex != -1) {
          Utils().showLog("----$existingOrderIndex");
          SummaryOrderNew existingOrder = orders[existingOrderIndex];
          num existingShares = existingOrder.shares ?? 0;
          num soldShares = order.shares ?? 0;
          num remainingShares = existingShares - soldShares;

          num existingDollars = existingOrder.dollars ?? 0;
          num soldDollars = order.dollars ?? 0;
          num remainingDollars = existingDollars - soldDollars;

          num existingInvested = existingOrder.invested ?? 0;
          num newInvested = order.invested ?? 0;
          num totalInvested = existingInvested - newInvested;

          if (totalInvested <= 0) {
            orders.removeAt(existingOrderIndex);
          } else {
            orders[existingOrderIndex] = SummaryOrderNew(
                image: order.image,
                symbol: order.symbol,
                name: order.name,
                shares: remainingShares,
                dollars: remainingDollars,
                price: order.price,
                change: order.change,
                changePercentage: order.changePercentage,
                invested: totalInvested,
                isShare: order.isShare,
                buy: order.buy);
          }

          num sharesToSell = order.shares ?? 0;
          num dollarsToSell = order.dollars ?? 0;

          String cleanedString =
              order.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "";
          num price = num.parse(cleanedString);
          num invested = order.isShare ? (price * sharesToSell) : dollarsToSell;

          data = UserBalanceDataNew(
            availableBalance: data.availableBalance + invested,
            invested: data.invested - invested,
          );
        } else {
          orders.add(order);
          Utils().showLog("Order not found for symbol: ${order.symbol}");
        }

        notifyListeners();
      } else {
        Utils().showLog("ELSE: Received null order");
      }
    } catch (e) {
      Utils().showLog("Error: $e");
    }
  }

  //  Top Search Trade
  List<TopSearch>? _topSearch;
  List<TopSearch>? get topSearch => _topSearch;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatusTop(status) {
    _status = status;
    notifyListeners();
  }

  Future getSearchDefaults() async {
    setStatusTop(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.getMostSearch,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _topSearch = topSearchFromJson(jsonEncode(response.data));
      } else {
        _topSearch = null;
        _error = response.message;
      }
      setStatusTop(Status.loaded);
    } catch (e) {
      _topSearch = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusTop(Status.loaded);
    }
  }
// Search API

  void clearSearch() {
    _dataNew = null;
    notifyListeners();
  }

  SearchNewRes? _dataNew;
  SearchNewRes? get dataNew => _dataNew;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;

  bool get isLoadingS => _statusS == Status.loading;

  String? _errorS;
  String? get errorS => _errorS ?? Const.errSomethingWrong;

  void setStatusSearch(status) {
    _statusS = status;
    notifyListeners();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.searchWithNews,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchNewResFromJson(jsonEncode(response.data));
      } else {
        _dataNew = null;
        _errorS = response.message;
      }
      setStatusSearch(Status.loaded);
    } catch (e) {
      _dataNew = null;
      _errorS = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatusSearch(Status.loaded);
    }
  }

  Future<ApiResponse> requestBuyShare(request, {showProgress = false}) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsRequestBuy,
        request: request,
        showProgress: showProgress,
      );
      setStatusSearch(Status.loaded);
      return response;
      // if (response.status) {
      //   // _dataNew = searchNewResFromJson(jsonEncode(response.data));
      // } else {
      //   // _dataNew = null;
      //   // _errorS = response.message;
      // }
    } catch (e) {
      _dataNew = null;
      _errorS = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatusSearch(Status.loaded);
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }

  Future<ApiResponse> requestSellShare(request, {showProgress = false}) async {
    setStatusSearch(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.tsRequestSell,
        request: request,
        showProgress: showProgress,
      );
      setStatusSearch(Status.loaded);
      return response;
      // if (response.status) {
      //   // _dataNew = searchNewResFromJson(jsonEncode(response.data));
      // } else {
      //   // _dataNew = null;
      //   // _errorS = response.message;
      // }
    } catch (e) {
      _dataNew = null;
      _errorS = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatusSearch(Status.loaded);
      return ApiResponse(status: false, message: Const.errSomethingWrong);
    }
  }
}

class SummaryOrderNew {
  String? image, symbol, name, change, price;
  num? changePercentage, invested, shares, dollars;
  bool isShare;
  bool buy;
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
    required this.buy,
    this.isShare = false,
  });
}

class UserBalanceDataNew {
  num availableBalance;
  num invested;

  UserBalanceDataNew({
    required this.availableBalance,
    required this.invested,
  });
}
