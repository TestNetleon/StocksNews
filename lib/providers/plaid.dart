import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/plaid_data_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../widgets/custom/alert_popup.dart';
import 'user_provider.dart';

class PlaidProvider extends ChangeNotifier {
//Send Plaid PortFolio
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;

  //Get Plaid PortFolio
  String? _errorG;
  String? get errorG => _errorG ?? Const.errSomethingWrong;
  Status _statusG = Status.ideal;
  Status get statusG => _statusG;
  bool get isLoadingG => _statusG == Status.loading;

  List<PlaidDataRes>? _data;
  List<PlaidDataRes>? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusG(status) {
    _statusG = status;
    notifyListeners();
  }

  Future sendPlaidPortfolio({showProgress = true, List<dynamic>? data}) async {
    List<dynamic>? jsonArray = data;

    setStatus(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "securities": jsonArray ?? [],
      });
      ApiResponse response = await apiRequest(
        url: Apis.savePlaidPortfolio,
        formData: request,
        showProgress: showProgress,
      );
      if (response.status) {
        // getPlaidPortfolioData();
        popUpAlert(
          message: response.message ?? "Data fetched successfully.",
          title: "Alert",
          icon: Images.alertPopGIF,
        );
      } else {
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getPlaidPortfolioData({showProgress = true}) async {
    setStatusG(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.plaidPortfolio,
        formData: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _data = plaidDataResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _errorG = response.message;
      }
      setStatusG(Status.loaded);
    } catch (e) {
      _data = null;
      _errorG = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusG(Status.loaded);
    }
  }
}
