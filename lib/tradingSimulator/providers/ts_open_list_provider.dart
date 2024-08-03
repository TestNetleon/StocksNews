import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_open_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
class TsOpenListProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<TsOpenListRes>? _data;
  List<TsOpenListRes>? get data => _data;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  // Extra? _extra;
  // Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "mssql_id":
            "${navigatorKey.currentContext!.read<TsPortfolioProvider>().userData?.sqlId}",
      };
      ApiResponse response = await apiRequest(
        url: Apis.tsOrderList,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _data = tsOpenListResFromJson(jsonEncode(response.data));
        // _extra = (response.extra is Extra ? response.extra as Extra : null);
        _error = null;
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
