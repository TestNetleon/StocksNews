import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../models/my_home.dart';
import '../models/my_home_premium.dart';
import '../utils/constants.dart';

class MyHomeManager extends ChangeNotifier {
  //MARK: Home
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  MyHomeRes? _data;
  MyHomeRes? get data => _data;

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getHomeData() async {
    setPremiumLoaded(false);
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

      Map request = {
        'token': provider.user?.token ?? '',
      };

      setStatus(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.myHome,
        request: request,
      );
      if (response.session) {
        _data = myHomeResFromJson(jsonEncode(response.data));
        _error = null;
        // getHomePremiumData();
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

  //MARK: Home Premium
  String? _errorHomePremium;
  String? get errorHomePremium => _errorHomePremium ?? Const.errSomethingWrong;

  Status _statusHomePremium = Status.ideal;
  Status get statusHomePremium => _statusHomePremium;

  bool get isLoadingHomePremium =>
      _statusHomePremium == Status.loading ||
      _statusHomePremium == Status.ideal;

  MyHomePremiumRes? _homePremiumData;
  MyHomePremiumRes? get homePremiumData => _homePremiumData;

  //home premium visibility
  bool _homePremiumLoaded = false;
  bool get homePremiumLoaded => _homePremiumLoaded;

  setPremiumLoaded(bool loaded) {
    _homePremiumLoaded = loaded;
    if (!loaded) {
      _homePremiumData = null;
      _errorHomePremium = null;
    }
    notifyListeners();
  }

  setStatusHomePremium(status) {
    _statusHomePremium = status;
    notifyListeners();
  }

  Future getHomePremiumData() async {
    try {
      UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

      Map request = {
        'token': provider.user?.token ?? '',
      };

      setStatusHomePremium(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.myHomePremium,
        request: request,
      );
      if (response.session) {
        _homePremiumData = myHomePremiumResFromJson(jsonEncode(response.data));
        _errorHomePremium = null;
      } else {
        _homePremiumData = null;
        _errorHomePremium = response.message;
      }
    } catch (e) {
      _homePremiumData = null;
      _errorHomePremium = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
    } finally {
      setStatusHomePremium(Status.loaded);
    }
  }
}
