import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/referral/referral_points_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class LeaderBoardManager extends ChangeNotifier {
  ReferralPointsRes? _data;
  ReferralPointsRes? get data => _data;

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
        url: Apis.leaderboard,
        request: {},
      );
      if (response.status) {
        _data = referralPointsResFromJson(jsonEncode(response.data));
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
}
