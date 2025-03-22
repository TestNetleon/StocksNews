import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/referral/referral_points_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class PointsClaimManager extends ChangeNotifier {
  ReferralPointsRes? _data;
  ReferralPointsRes? get data => _data;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int _page = 1;
  bool get canLoadMore => (_data?.totalPages ?? 0) >= _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({loadMore = false, type, id}) async {
    if (loadMore == false) {
      _page = 1;
    }

    try {
      _error = null;
      setStatus(loadMore ? Status.loadingMore : Status.loading);
      final request = id == null
          ? {"page": "$_page", "type": type ?? ""}
          : {"page": "$_page", "id": "$id"};
      ApiResponse response = await apiRequest(
        url: Apis.pointClaimLog,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _data = referralPointsResFromJson(jsonEncode(response.data));
        } else {
          _data!.data!.addAll(
            referralPointsResFromJson(jsonEncode(response.data)).data!,
          );
        }
        _page++;
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
