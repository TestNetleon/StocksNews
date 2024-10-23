import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  Extra? _extraNew;
  Extra? get extraNew => _extraNew;

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
      UserProvider userProvider =
          Provider.of(navigatorKey.currentContext!, listen: false);
      userProvider.updateBalance(_extra?.balance ?? 0);
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0));
      } else {
        popUpAlert(
            message: response.message ?? "",
            title: "Alert",
            icon: Images.alertPopGIF,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0));
      }
    } catch (e) {
      Utils().showLog("$e");
      popUpAlert(
          message: Const.errSomethingWrong,
          title: "Alert",
          icon: Images.alertPopGIF,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0));
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

  // Transaction
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
        _extraNew = response.extra is Extra ? response.extra : null;
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

//Separate Points Transaction
  Extra? _extraDetail;
  Extra? get extraDetail => _extraDetail;

  String? _errorDetail;
  String? get errorDetail => _errorDetail ?? Const.errSomethingWrong;

  Status _statusDetail = Status.ideal;
  Status get statusDetail => _statusDetail;

  bool get isLoadingDetail => _statusDetail == Status.loading;

  List<AffiliateTransactionRes>? _dataDetail;
  List<AffiliateTransactionRes>? get dataDetail => _dataDetail;

  int _page = 1;

  bool get canLoadMore => _page < (_extraDetail?.totalPages ?? 1);
  // bool get canLoadMore => _page < 5;

  void setStatusSeparate(status) {
    _statusDetail = status;
    notifyListeners();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
    required String type,
  }) async {
    if (loadMore) {
      _page++;
      setStatusSeparate(Status.loadingMore);
    } else {
      _page = 1;
      _dataDetail = null;
      setStatusSeparate(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page",
        "txn_type": type,
      };

      ApiResponse response = await apiRequest(
        url: Apis.affiliateTnxList,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _errorDetail = null;
        if (_page == 1) {
          _dataDetail =
              affiliateTransactionResFromJson(jsonEncode(response.data));
          _extraDetail =
              (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _dataDetail?.addAll(
              affiliateTransactionResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _errorDetail = response.message;
          _dataDetail = null;
        }
      }
      setStatusSeparate(Status.loaded);
    } catch (e) {
      _dataDetail = null;
      _errorDetail = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusSeparate(Status.loaded);
    }
  }

  // Claim Points
  Extra? _extraClaim;
  Extra? get extraClaim => _extraClaim;

  String? _errorClaim;
  String? get errorClaim => _errorClaim ?? Const.errSomethingWrong;

  Status _statusClaim = Status.ideal;
  Status get statusClaim => _statusClaim;

  bool get isLoadingClaim => _statusClaim == Status.loading;

  List<AffiliateTransactionRes>? _dataClaim;
  List<AffiliateTransactionRes>? get dataClaim => _dataClaim;

  int _pageClaim = 1;

  bool get canLoadMoreClaim => _pageClaim < (_extraClaim?.totalPages ?? 1);

  void setStatusClaim(status) {
    _statusClaim = status;
    notifyListeners();
  }

  Future getUnclaimedData({
    showProgress = false,
    loadMore = false,
    required String type,
    id,
  }) async {
    Utils().showLog('HI');
    if (loadMore) {
      _pageClaim++;
      setStatusClaim(Status.loadingMore);
    } else {
      _pageClaim = 1;
      _dataClaim = null;
      setStatusClaim(Status.loading);
    }

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_pageClaim",
        "txn_type": type,
      };
      if (id != null) {
        request['id'] = "$id";
      }

      ApiResponse response = await apiRequest(
        url: id == null ? Apis.pointClaimLog : Apis.claimPointLog,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _errorClaim = null;
        if (_pageClaim == 1) {
          _dataClaim =
              affiliateTransactionResFromJson(jsonEncode(response.data));
          _extraClaim =
              (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _dataClaim?.addAll(
              affiliateTransactionResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_page == 1) {
          _errorClaim = response.message;
          _dataClaim = null;
        }
      }
      setStatusClaim(Status.loaded);
    } catch (e) {
      _dataClaim = null;
      _errorClaim = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusClaim(Status.loaded);
    }
  }
}
