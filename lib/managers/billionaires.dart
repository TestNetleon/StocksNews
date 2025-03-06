import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BillionairesManager extends ChangeNotifier{

  BillionairesRes? _billionairesRes;
  BillionairesRes? get billionairesRes=> _billionairesRes;

  MarketResData? _categoriesData;
  MarketResData? get categoriesData => _categoriesData;

  String? _error;
  Status _status = Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Status _statusCrypto = Status.ideal;
  bool get isLoadingCrypto => _statusCrypto == Status.loading || _statusCrypto == Status.ideal;


  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusCrypto(status) {
    _statusCrypto = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getCryptoCurrencies();
  }


  Future<void> getTabs() async {
    try {
      setStatus(Status.loading);
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoTabs,
        request: request,
      );

      if (response.status) {
        _categoriesData = marketResDataFromJson(jsonEncode(response.data));
        _error = null;
         onScreenChange(0);
      } else {
        _categoriesData = null;
        _error = response.message;
      }
    } catch (e) {
      _categoriesData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.newsCategories}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }


  Future getCryptoCurrencies() async {
    setStatusCrypto(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoHome,
        showProgress: false,
        request: request,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _billionairesRes = billionairesResFromJson(jsonEncode(response.data));
      }
      else {
        _billionairesRes = null;
        _error = response.message;
      }
      setStatusCrypto(Status.loaded);
    } catch (e) {
      _billionairesRes = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusCrypto(Status.loaded);
    }
  }

  int? selectedScreen=-1;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      switch (selectedScreen) {
        case 0:
          getCryptoCurrencies();
          break;

        case 1:
          //getSignalSentimentData();
          break;

        case 2:
         // getInsidersData();
          break;
        default:
      }
      }
    }


  int? selectedInnerScreen=0;
  onScreenChangeInner(index) {
    if (selectedInnerScreen != index) {
      selectedInnerScreen = index;
      notifyListeners();
    }
  }
}