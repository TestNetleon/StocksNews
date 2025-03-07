import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class ReferralManager extends ChangeNotifier {
  //
  ReferralRes? _data;
  ReferralRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({showProgress = false}) async {
    try {
      _error = null;
      setStatus(Status.loading);

      ApiResponse response = await apiRequest(
        url: Apis.referral,
        request: {},
        showProgress: showProgress,
      );

      if (response.status) {
        _data = referralResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      Utils().showLog("Error $e");
      _data = null;
      _error = Const.errSomethingWrong;
    } finally {
      setStatus(Status.loaded);
    }
  }
}
