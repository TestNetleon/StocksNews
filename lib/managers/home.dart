import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../models/my_home.dart';
import '../models/my_home_premium.dart';
import '../utils/constants.dart';
import '../models/home_watchlist.dart';
import 'user.dart';

class MyHomeManager extends ChangeNotifier {
  //MARK: Clear Data
  void clearAllData() {
    //clear home data
    _data = null;
    //clear home premium data
    _homePremiumData = null;
    //clear watchlist data
    _watchlist = null;

    notifyListeners();
  }

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
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();

      Map request = {
        'token': provider.user?.token ?? '',
      };

      setStatus(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.myHome,
        request: request,
      );
      if (response.status) {
        _data = myHomeResFromJson(jsonEncode(response.data));
        if (_data?.user != null) {
          provider.setUser(data?.user);
        }
        _error = null;

        bool firstTime = await Preference.isFirstOpen();
        if (_data?.loginBox != null && firstTime) {
          Timer(Duration(seconds: 2), () {
            navigatorKey.currentContext!.read<UserManager>().askLoginScreen();
          });
        }
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
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();

      Map request = {
        'token': provider.user?.token ?? '',
      };

      setStatusHomePremium(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.myHomePremium,
        request: request,
      );
      if (response.status) {
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

  //MARK: WATCHLIST
  String? _errorWatchlist;
  String? get errorWatchlist => _errorWatchlist ?? Const.errSomethingWrong;

  Status _statusWatchlist = Status.ideal;
  Status get statusWatchlist => _statusWatchlist;

  bool get isLoadingWatchlist => _statusWatchlist == Status.loading;

  HomeWatchlistRes? _watchlist;
  HomeWatchlistRes? get watchlist => _watchlist;

  setStatusWatchlist(status) {
    _statusWatchlist = status;
    notifyListeners();
  }

  Future getHomeWatchlist() async {
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();

      Map request = {
        'token': provider.user?.token ?? '',
      };

      setStatusWatchlist(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.myHomeWatchlist,
        request: request,
      );
      if (response.status) {
        _watchlist = homeWatchlistResFromJson(jsonEncode(response.data));
        _errorWatchlist = null;
      } else {
        _watchlist = null;
        _errorWatchlist = response.message;
      }
    } catch (e) {
      _watchlist = null;
      _errorWatchlist = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.myHome}: $e');
    } finally {
      setStatusWatchlist(Status.loaded);
    }
  }
}
