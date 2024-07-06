import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';

import '../api/api_response.dart';
import '../api/apis.dart';
import '../modals/membership.dart';
import '../modals/membership_success.dart';
import '../route/my_app.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import 'user_provider.dart';

class MembershipProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  Extra? _extra;
  Extra? get extra => _extra;

  List<MembershipRes>? _data;
  List<MembershipRes>? get data => _data;

  MembershipSuccess? _success;
  MembershipSuccess? get success => _success;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData() async {
    setStatus(Status.loading);

    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.membership,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _data = membershipResFromJson(jsonEncode(response.data));

        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
        _extra = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _extra = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getMembershipSuccess() async {
    notifyListeners();
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.membershipSuccess,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _success = membershipSuccessFromJson(jsonEncode(response.data));
      } else {
        //
      }
      notifyListeners();
    } catch (e) {
      Utils().showLog(e.toString());
      notifyListeners();
    }
  }
}
