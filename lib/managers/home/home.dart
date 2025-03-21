import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/managers/home/home_tabs.dart';
import 'package:stocks_news_new/models/home_view_more.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../models/lock.dart';
import '../../models/my_home.dart';
import '../../models/my_home_premium.dart';
import '../../utils/constants.dart';
import '../../models/home_watchlist.dart';
import '../user.dart';

class MyHomeManager extends ChangeNotifier {
  //MARK: Clear Data
  void clearAllData() {
    //clear home data
    _data = null;
    //clear home premium data
    _homePremiumData = null;
    //clear watchlist data
    _watchlist = null;
    _setNUm = -1;
    navigatorKey.currentContext!.read<HomeTabsManager>().clearAllData();
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

//MARK: setting up lock
  BaseLockInfoRes? _lockStocksInsider;
  BaseLockInfoRes? get lockStocksInsider => _lockStocksInsider;

  BaseLockInfoRes? _lockStocksPoliticians;
  BaseLockInfoRes? get lockStocksPoliticians => _lockStocksPoliticians;

  num _setNUm = -1;
  setNumValue(value) {
    _setNUm = value;
    notifyListeners();
  }

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info;

    switch (_setNUm) {
      case 1:
        info = _lockStocksInsider;
        break;

      case 2:
        info = _lockStocksPoliticians;
        break;

      case 3:
        info = _data?.scannerPort?.lockInfo;
        break;

      default:
    }

    return info;
  }

  Future getHomeData({bool fromAdvertiserID = false}) async {
    setPremiumLoaded(false);
    navigatorKey.currentContext!
        .read<HomeTabsManager>()
        .setTrendingLoaded(false);

    try {
      String? fcmToken = await Preference.getFcmToken();
      String? address = await Preference.getLocation();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionName = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();

      Map request = {
        'token': provider.user?.token ?? '',
        "platform": Platform.operatingSystem,
        "build_version": versionName,
        "build_code": buildNumber,
      };

      if (appsFlyerUID != null && appsFlyerUID != '') {
        request['appsflyer_id'] = appsFlyerUID;
      }
      if (memCODE != null && memCODE != '') {
        request['distributor_code'] = memCODE;
      }
      if (fromAdvertiserID) {
        request['advertiser_id'] = _data?.loginBox?.id ?? '';
      }

      if (address != null && address != '') {
        request['address'] = address;
      }

      if (fcmToken != null && fcmToken != '') {
        request['fcm_token'] = fcmToken;
      }

      setStatus(Status.loading);
      ApiResponse response = await apiRequest(
        url: Apis.myHome,
        request: request,
      );
      if (response.status) {
        _data = myHomeResFromJson(jsonEncode(response.data));
        if (_data?.user != null) {
          provider.setUser(data?.user);
          BrazeService.brazeUserEvent();
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

        if (_homePremiumData?.insiderTrading != null) {
          _lockStocksInsider = _homePremiumData?.insiderTrading?.lockInfo;
        }

        if (_homePremiumData?.congressionalStocks != null) {
          _lockStocksPoliticians =
              _homePremiumData?.congressionalStocks?.lockInfo;
        }
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

//MARK: View More
  String? _errorViewMore;
  String? get errorViewMore => _errorViewMore;

  Status _statusViewMore = Status.ideal;
  Status get statusViewMore => _statusViewMore;

  bool get isLoadingViewMore =>
      _statusViewMore == Status.loading || _statusViewMore == Status.ideal;

  HomeViewMoreTickersRes? _homeViewMore;
  HomeViewMoreTickersRes? get homeViewMore => _homeViewMore;

  int _page = 1;
  bool get canLoadMoreViewMore => _page <= (_homeViewMore?.totalPages ?? 1);

  setStatusViewMore(status) {
    _statusViewMore = status;
    notifyListeners();
  }

  Future getViewMoreData({
    required String apiUrl,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      _page++;
      setStatusViewMore(Status.loadingMore);
    } else {
      _page = 1;
      setStatusViewMore(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_page',
      };

      ApiResponse response = await apiRequest(
        url: apiUrl,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _homeViewMore =
              homeViewMoreTickersResFromJson(jsonEncode(response.data));
          _errorViewMore = null;
        } else {
          _homeViewMore?.data?.addAll(
              homeViewMoreTickersResFromJson(jsonEncode(response.data)).data ??
                  []);
        }
      } else {
        if (_page == 1) {
          _homeViewMore = null;
          _errorViewMore = response.message;
        }
      }
    } catch (e) {
      _homeViewMore = null;
      _errorViewMore = Const.errSomethingWrong;
    } finally {
      setStatusViewMore(Status.loaded);
    }
  }

  Future checkMaintenanceMode() async {
    notifyListeners();

    try {
      ApiResponse response = await apiRequest(
        url: Apis.checkServer,
        baseUrl: Apis.baseUrlLocal,
        showProgress: false,
      );

      if (response.status) {
        Extra? newExtra =
            (response.extra is Extra ? response.extra as Extra : null);

        if (newExtra?.messageObject != null) {
          Preference.saveLocalDataBase(newExtra?.messageObject);
        }
        if (newExtra?.messageObject?.error != null) {
          Const.errSomethingWrong = newExtra?.messageObject?.error ?? "";
          Const.loadingMessage = newExtra?.messageObject?.loading ?? "";
        }
        MessageRes? localDataBase = await Preference.getLocalDataBase();
        Utils().showLog("localDataBase  =========${localDataBase?.error}");
        notifyListeners();
      }

      return response.status ? false : true;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }
}
