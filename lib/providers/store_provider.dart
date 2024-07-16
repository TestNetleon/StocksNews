import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/store_info_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class StoreProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  Status get status => _status;

  StoreInfoRes? _data;
  StoreInfoRes? get data => _data;

  String? _error;
  String? get error => _error;

  Extra? _extra;
  Extra? get extra => _extra;

  bool get isLoading => _status == Status.loading;

  int _faqOpenIndex = -1;
  int get faqOpenIndex => _faqOpenIndex;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _faqOpenIndex = index;
    notifyListeners();
  }

  Future getStoreInfo() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.storeInfo,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );

      setStatus(Status.loaded);
      if (response.status) {
        _data = storeInfoResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message ?? Const.errSomethingWrong;
      }
    } catch (e) {
      Utils().showLog(e.toString());
      _error = Const.errSomethingWrong;
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF);
      setStatus(Status.loaded);
    }
  }
}
