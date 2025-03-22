import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

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

  Future nudgeAPI({String? email, required int dbId}) async {
    try {
      final request = {
        "email": email,
        "db_id": "$dbId",
      };

      ApiResponse response = await apiRequest(
        url: Apis.nudgeFriend,
        request: request,
        showProgress: true,
      );

      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );

      // if (response.status) {
      //   popUpAlert(
      //       message: response.message ?? "",
      //       title: "Success",
      //       icon: Images.otpSuccessGIT,
      //       padding: EdgeInsets.fromLTRB(10, 10, 10, 0));
      // } else {
      //   popUpAlert(
      //       message: response.message ?? "",
      //       title: "Alert",
      //       icon: Images.alertPopGIF,
      //       padding: EdgeInsets.fromLTRB(10, 10, 10, 0));
      // }
    } catch (e) {
      Utils().showLog("$e");
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0));
    }
  }
}
