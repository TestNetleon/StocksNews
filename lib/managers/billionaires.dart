import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';

class BillionairesManager extends ChangeNotifier{

  BillionairesRes? _billionairesRes;
  BillionairesRes? get billionairesRes=> _billionairesRes;
  String? _error;
  Status _status = Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getBillionaires();
  }


  Future getBillionaires() async {
    setStatus(Status.loading);
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
      setStatus(Status.loaded);
    } catch (e) {
      _billionairesRes = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatus(Status.loaded);
    }
  }

  int? selectedScreen;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      }
    }

  List<MarketResData> innerTabs = [
    MarketResData(title: 'TOP BILLIONAIRES'),
    MarketResData(title: 'TOP CEO’S'),

  ];

  int? selectedInnerScreen;
  onScreenChangeInner(index) {
    if (selectedInnerScreen != index) {
      selectedInnerScreen = index;
      notifyListeners();
    }
  }
}