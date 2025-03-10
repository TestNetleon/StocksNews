import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/routes/my_app.dart';

import '../models/morningstar_report.dart';
import '../utils/constants.dart';
import 'user.dart';

class MorningStarReportsManager extends ChangeNotifier {
  //MARK: Reports
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  MorningStarReportsRes? _data;
  MorningStarReportsRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getMorningStarReports() async {
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.morningStarReports,
        request: request,
      );
      if (response.status) {
        _data = morningStarReportsResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
    } finally {
      setStatus(Status.loaded);
    }
  }
}
