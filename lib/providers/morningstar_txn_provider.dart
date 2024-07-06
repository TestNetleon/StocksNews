// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morningstar_purchase_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class MorningstarTxnProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;

  Status _statusData = Status.ideal;
  Status get statusData => _statusData;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isLoadingData => _statusData == Status.loading;

  String? get error => _error ?? Const.errSomethingWrong;

  List<MorningStarPurchase>? _data;
  List<MorningStarPurchase>? get data => _data;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getData();
  }

  Future getData({final bool reset = false}) async {
    setStatus(Status.loading);

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.userPurchase,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _data = morningStarPurchaseFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
