import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/modals/membership/membership_info_res.dart';
import 'package:stocks_news_new/modals/plans_res.dart';

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

  MembershipInfoRes? _membershipInfoRes;
  MembershipInfoRes? get membershipInfoRes => _membershipInfoRes;

  PlansRes? _plansRes;
  PlansRes? get plansRes => _plansRes;

  MembershipSuccess? _success;
  MembershipSuccess? get success => _success;

  int _faqOpenIndex = -1;
  int get faqOpenIndex => _faqOpenIndex;

  void setOpenIndex(index) {
    _faqOpenIndex = index;
    notifyListeners();
  }

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

  Future getMembershipSuccess({bool isMembership = false}) async {
    notifyListeners();
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "membership": "$isMembership",
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
        _success = null;
      }
      notifyListeners();
    } catch (e) {
      _success = null;
      Utils().showLog(e.toString());
      notifyListeners();
    }
  }

  Future getPlansDetail() async {
    setStatus(Status.loading);

    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "platform": Platform.operatingSystem,
      });
      ApiResponse response = await apiRequest(
        url: Apis.plansDetail,
        formData: request,
        showProgress: true,
      );
      if (response.status) {
        _plansRes = plansResFromJson(jsonEncode(response.data));
      } else {
        _plansRes = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _plansRes = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getMembershipInfo({
    String? inAppMsgId,
    String? notificationId,
  }) async {
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId});
      }
      if (notificationId != null) {
        request.addAll({"notification_id": notificationId});
      }
      ApiResponse response = await apiRequest(
        url: Apis.membershipInfo,
        request: request,
        showProgress: false,
      );
      //  setStatus(Status.loaded);
      if (response.status) {
        _membershipInfoRes = membershipInfoResFromJson(
          jsonEncode(response.data),
        );
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _membershipInfoRes = null;
        _error = response.message;
        _extra = null;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _membershipInfoRes = null;
      _extra = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
