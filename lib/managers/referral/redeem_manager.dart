import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/referral/leader_board.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class RedeemManager extends ChangeNotifier {
  LeaderBoardRes? _data;
  LeaderBoardRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({loadMore = false}) async {
    try {
      _error = null;
      setStatus(loadMore ? Status.loadingMore : Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.redeemList,
        request: {},
      );
      if (response.status) {
        _data = leaderBoardResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      _data = null;
      _error = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
  }

  Future requestClaimReward({loadMore = false, type = ""}) async {
    try {
      _error = null;
      setStatus(loadMore ? Status.loadingMore : Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.pointClaim,
        request: {"type": type},
      );
      if (response.status) {
        // _data = leaderBoardResFromJson(jsonEncode(response.data));
      } else {
        //
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog("Error => $e");
      //
      setStatus(Status.loaded);
    }
  }
}
