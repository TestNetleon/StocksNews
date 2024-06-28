import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';

import '../api/api_response.dart';
import '../api/apis.dart';
import '../modals/affiliate/refer_friend_res.dart';
import '../modals/affiliate/transaction.dart';
import '../route/my_app.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/custom/alert_popup.dart';
import 'user_provider.dart';

class LeaderBoardProvider extends ChangeNotifier {
//Refer Friend
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  List<AffiliateReferRes>? _data;
  List<AffiliateReferRes>? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

//LeaderBoard
  String? _errorL;
  String? get errorL => _errorL ?? Const.errSomethingWrong;

  Status _statusL = Status.ideal;
  Status get statusL => _statusL;

  bool get isLoadingL => _statusL == Status.loading;

  Extra? _extraL;
  Extra? get extraL => _extraL;

  List<AffiliateReferRes>? _leaderBoard;
  List<AffiliateReferRes>? get leaderBoard => _leaderBoard;

  num verified = 0;
  num unVerified = 0;

  // void startNudgeTimer(int index) {
  //   _data?[index].timer = 60;
  //   notifyListeners();
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if ((_data?[index].timer ?? 0) > 0) {
  //       _data?[index].timer--;
  //       Utils().showLog("---Timer ----${_data?[index].timer}");
  //       notifyListeners();
  //     } else {
  //       timer.cancel();
  //       Utils().showLog("Cancel Timer");
  //     }
  //   });
  // }

  void setStatusL(status) {
    _statusL = status;
    notifyListeners();
  }

  void clearData() {
    _leaderBoard = null;
    _data = null;
    notifyListeners();
  }

  getUserType() {
    if (_data != null) {
      for (var user in _data!) {
        if (user.status == 1) {
          verified++;
        } else if (user.status == 0) {
          unVerified++;
        }
      }
    }
    log("$verified, $unVerified");
    notifyListeners();
  }

  Future getReferData({checkAppUpdate = true}) async {
    verified = 0;
    unVerified = 0;
    setStatus(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.referralList,
        formData: request,
        showProgress: false,
        checkAppUpdate: checkAppUpdate,
      );
      if (response.status) {
        _data = affiliateReferResFromJson(jsonEncode(response.data));
        getUserType();
      } else {
        _data = null;
        _error = response.message;
      }
      _extra = (response.extra is Extra ? response.extra as Extra : null);

      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future nudgeAPI({String? email, required int dbId}) async {
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "email": email,
        "db_id": dbId,
      });

      ApiResponse response = await apiRequest(
        url: Apis.nudgeFriend,
        formData: request,
        showProgress: true,
      );
      if (response.status) {
        popUpAlert(
            message: response.message ?? "",
            title: "Success",
            icon: Images.otpSuccessGIT,
            padding: EdgeInsets.fromLTRB(10.sp, 10, 10.sp, 0));
      } else {
        popUpAlert(
            message: response.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF,
            padding: EdgeInsets.fromLTRB(10.sp, 10, 10.sp, 0));
      }
    } catch (e) {
      Utils().showLog("$e");
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
          padding: EdgeInsets.fromLTRB(10.sp, 10, 10.sp, 0));
    }
  }

  Future getLeaderBoardData() async {
    setStatusL(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.referralLeaderBoard,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _leaderBoard = affiliateReferResFromJson(jsonEncode(response.data));
      } else {
        _leaderBoard = null;
        _errorL = response.message;
      }
      setStatusL(Status.loaded);
    } catch (e) {
      _leaderBoard = null;
      _errorL = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusL(Status.loaded);
    }
  }

//Transaction
  String? _errorT;
  String? get errorT => _errorT ?? Const.errSomethingWrong;

  Status _statusT = Status.ideal;
  Status get statusT => _statusT;

  bool get isLoadingT => _statusT == Status.loading;

  Extra? _extraT;
  Extra? get extraT => _extraT;
  List<AffiliateTransactionRes>? _tnxData;
  List<AffiliateTransactionRes>? get tnxData => _tnxData;

  void setStatusT(status) {
    _statusT = status;
    notifyListeners();
  }

  Future getTransactionData() async {
    _tnxData = null;
    setStatusT(Status.loading);
    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      });
      ApiResponse response = await apiRequest(
        url: Apis.affiliateTnx,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        _tnxData = affiliateTransactionResFromJson(jsonEncode(response.data));
        _errorT = null;
      } else {
        _errorT = response.message;
        _tnxData = null;
      }
      setStatusT(Status.loaded);
    } catch (e) {
      _tnxData = null;
      _errorT = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusT(Status.loaded);
    }
  }
}
