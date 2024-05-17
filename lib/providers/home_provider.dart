import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/home_sentiment_res.dart';
import 'package:stocks_news_new/modals/home_slider_res.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/ipo_res.dart';
import 'package:stocks_news_new/modals/stock_infocus.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/preference.dart';

class HomeProvider extends ChangeNotifier with AuthProviderBase {
  // HomeRes? _home;
  String? _error;
//
  Status _statusSlider = Status.ideal;
  Status get statusSlider => _statusSlider;

  Status _statusSentiment = Status.ideal;
  Status get statusSentiment => _statusSentiment;

  Status _statusTrending = Status.ideal;
  Status get statusTrending => _statusTrending;

  Status _statusInsider = Status.ideal;
  Status get statusInsider => _statusInsider;

  Status _statusIpo = Status.ideal;
  Status get statusIpo => _statusIpo;

  Status _statusHomeAlert = Status.ideal;
  Status get statusHomeAlert => _statusHomeAlert;

  Status _statusFocus = Status.ideal;
  Status get statusFocus => _statusFocus;

  // HomeRes? get data => _home;

  HomeSliderRes? _homeSliderRes;
  HomeSliderRes? get homeSliderRes => _homeSliderRes;

  HomeSentimentRes? _homeSentimentRes;
  HomeSentimentRes? get homeSentimentRes => _homeSentimentRes;

  HomeTrendingRes? _homeTrendingRes;
  HomeTrendingRes? get homeTrendingRes => _homeTrendingRes;

  HomeInsiderRes? _homeInsiderRes;
  HomeInsiderRes? get homeInsiderRes => _homeInsiderRes;

  List<IpoRes>? _ipoRes;
  List<IpoRes>? get ipoRes => _ipoRes;

  bool get isLoadingSlider => _statusSlider == Status.loading;
  bool get isLoadingSentiment => _statusSentiment == Status.loading;
  bool get isLoadingTrending => _statusTrending == Status.loading;
  bool get isLoadingInsider => _statusInsider == Status.loading;
  bool get isLoadingIpo => _statusIpo == Status.loading;
  bool get isLoadingHomeAlert => _statusHomeAlert == Status.loading;
  bool get isLoadingStockFocus => _statusFocus == Status.loading;

  int? userAlert;

  int _openIndex = -1;
  int get openIndex => _openIndex;
  bool topLoading = false;
  String? get error => _error ?? Const.errSomethingWrong;

  List<HomeAlertsRes>? _homeAlertData;
  List<HomeAlertsRes>? get homeAlertData => _homeAlertData;

  StockInFocusRes? _focusRes;
  StockInFocusRes? get focusRes => _focusRes;

  bool notificationSeen = false;

  int totalAlerts = 0;
  int totalWatchList = 0;

  void setTotalsAlerts(int value) {
    totalAlerts = value;
    log("TOTAL ALERTS => $totalAlerts");

    notifyListeners();
  }

  void setTotalsWatchList(int value) {
    totalWatchList = value;
    log("TOTAL WATCHLIST => $totalWatchList");
    notifyListeners();
  }

  // void setStatus(status) {
  //   _status = status;
  //   notifyListeners();
  // }

  setNotification(value) {
    notificationSeen = value;
    notifyListeners();
  }

  void open(int index) {
    _openIndex = index;
    notifyListeners();
  }

  Future refreshData() async {
    getHomeSlider();
    // getIpoData();
    getStockInFocus();
    getHomeSentimentData();
    getHomeTrendingData();
    getHomeAlerts();

    getHomeInsiderData();
  }

  Future refreshWithCheck() async {
    if (_homeSliderRes == null) {
      getHomeSlider();
    }

    // if (_ipoRes == null) {
    //   getIpoData();
    // }
    if (_homeSentimentRes == null) {
      getHomeSentimentData();
    }
    if (_focusRes == null) {
      getStockInFocus();
    }
    if (_homeTrendingRes == null) {
      getHomeTrendingData();
    }
    if (_homeAlertData == null) {
      getHomeAlerts();
    }
    if (_homeInsiderRes == null) {
      getHomeInsiderData();
    }
  }

  Future<void> apiIsolate(SendPort sendPort, String apiUrl, Map request) async {
    try {
      ApiResponse response = await apiRequest(
        url: apiUrl,
        request: request,
        showProgress: false,
      );
      sendPort.send(response);
    } catch (e) {
      sendPort.send(e);
    }
  }

  Future getStockInFocus() async {
    _statusFocus = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.stockFocus,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _focusRes = stockInFocusResFromJson(jsonEncode(response.data));
      } else {
        _focusRes = null;
      }
      _statusFocus = Status.loaded;
      notifyListeners();
    } catch (e) {
      _focusRes = null;

      log(e.toString());
      _statusFocus = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeAlerts() async {
    _statusHomeAlert = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeAlert,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _homeAlertData = homeAlertsResFromJson(jsonEncode(response.data));
      } else {
        _homeAlertData = null;
      }
      userAlert = response.extra.userAlert;
      _statusHomeAlert = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeAlertData = null;
      log(e.toString());
      _statusHomeAlert = Status.loaded;
      notifyListeners();
    }
  }

  Future getIpoData() async {
    _statusIpo = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.ipoCalendar,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _ipoRes = ipoResFromJson(jsonEncode(response.data));
      } else {
        _ipoRes = null;
      }
      _statusIpo = Status.loaded;
      notifyListeners();
    } catch (e) {
      _ipoRes = null;
      log(e.toString());
      _statusIpo = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeSlider() async {
    _statusSlider = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    String? fcmToken = await Preference.getFcmToken();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
        "fcm_token": fcmToken ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeSlider,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _homeSliderRes = HomeSliderRes.fromJson(response.data);
        // UserProvider provider =
        //     navigatorKey.currentContext!.read<UserProvider>();
        notificationSeen = response.extra.notificationCount == 0;
        totalAlerts = _homeSliderRes?.totalAlerts ?? 0;
        totalWatchList = _homeSliderRes?.totalWatchList ?? 0;

        notifyListeners();
      } else {
        _homeSliderRes = null;
      }
      _statusSlider = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeSliderRes = null;
      log(e.toString());
      _statusSlider = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeSentimentData() async {
    _statusSentiment = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeSentiment,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _homeSentimentRes = HomeSentimentRes.fromJson(response.data);
      } else {
        _homeSentimentRes = null;
      }

      _statusSentiment = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeSentimentRes = null;
      log(e.toString());
      _statusSentiment = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeTrendingData() async {
    topLoading = true;

    _statusTrending = Status.loading;
    notifyListeners();

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
          url: Apis.homeTrending, request: request, showProgress: false);
      if (response.status) {
        _homeTrendingRes = HomeTrendingRes.fromJson(response.data);
      } else {
        _homeTrendingRes = null;
        _error = "Data not found";
      }
      topLoading = false;
      _statusTrending = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeTrendingRes = null;
      _error = Const.errSomethingWrong;
      topLoading = false;
      _statusTrending = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeInsiderData() async {
    _statusInsider = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeInsider,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _homeInsiderRes = HomeInsiderRes.fromJson(response.data);
      } else {
        _homeInsiderRes = null;
        showErrorMessage(message: response.message);
      }
      _statusInsider = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeInsiderRes = null;
      log(e.toString());
      _statusInsider = Status.loaded;
      notifyListeners();
    }
  }

  // Future logoutUser(request) async {
  //   try {
  //     ApiResponse res = await apiRequest(
  //       url: Apis.logout,
  //       request: request,
  //     );
  //     if (res.status) {
  //       // setStatus(Status.loaded);
  //       handleSessionOut();
  //       showErrorMessage(message: res.message, type: SnackbarType.info);
  //     } else {
  //       setStatus(Status.loaded);
  //       showErrorMessage(
  //         message: res.message,
  //       );
  //     }
  //   } catch (e) {
  //     // setStatus(Status.loaded);
  //     showErrorMessage(
  //       message: kDebugMode ? e.toString() : Const.errSomethingWrong,
  //     );
  //   }
  // }
}
