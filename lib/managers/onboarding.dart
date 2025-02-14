import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/onboarding.dart';
import 'package:stocks_news_new/routes/my_app.dart';

import '../utils/constants.dart';
import 'user.dart';

class OnboardingManager extends ChangeNotifier {
  //MARK: Onboarding
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  OnboardingRes? _data;
  OnboardingRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getOnBoardingData() async {
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.onBoarding,
        request: request,
      );
      if (response.status) {
        _data = onboardingResFromJson(jsonEncode(response.data));
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
