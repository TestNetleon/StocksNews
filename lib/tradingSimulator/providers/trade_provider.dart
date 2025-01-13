import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import '../../api/api_requester.dart';
import '../../api/api_response.dart';
import '../../api/apis.dart';
import '../../routes/my_app.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';

class TradeProviderNew extends ChangeNotifier {
  List<SummaryOrderNew> orders = [];

  void addOrderData(SummaryOrderNew? order) {
    Utils().showLog("------Buy order");
    TsPortfolioProvider provider =
        navigatorKey.currentContext!.read<TsPortfolioProvider>();
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

        if (invested > (provider.userData?.tradeBalance ?? 0)) {
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

        // provider.updateBalance(
        //   balance: (provider.userData?.tradeBalance ?? 0) - invested,
        //   invested: (provider.userData?.invested ?? 0) + invested,
        // );

        // data = UserBalanceDataNew(
        //   availableBalance: data.availableBalance - invested,
        //   invested: data.invested + invested,
        // );
      } else {
        Utils().showLog("ELSE: Received null order");
      }

      notifyListeners();
    } catch (e) {
      Utils().showLog("Error: $e");
    }
  }

  // void addAmount(num amount) {
  //   data.availableBalance = data.availableBalance + amount;
  //   notifyListeners();
  // }

  void sellOrderData(SummaryOrderNew? order) {
    Utils().showLog("------Sell order");
    // TsPortfolioProvider provider =
    //     navigatorKey.currentContext!.read<TsPortfolioProvider>();
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

          // num sharesToSell = order.shares ?? 0;
          // num dollarsToSell = order.dollars ?? 0;

          // String cleanedString =
          //     order.price?.replaceAll(RegExp(r'[^\d.]'), '') ?? "";
          // num price = num.parse(cleanedString);
          // num invested = order.isShare ? (price * sharesToSell) : dollarsToSell;

          // provider.updateBalance(
          //   balance: (provider.userData?.tradeBalance ?? 0) + invested,
          //   invested: (provider.userData?.invested ?? 0) - invested,
          // );

          // data = TsUserRes(
          //   tradeBalance: data.availableBalance + invested,
          //   invested: data.invested - invested,
          // );
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
