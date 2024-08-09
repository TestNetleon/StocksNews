import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/third_party_api_requester.dart'
    as third_party_api;
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';
import 'package:stocks_news_new/modals/home_alert_res.dart';
import 'package:stocks_news_new/modals/home_insider_res.dart';
import 'package:stocks_news_new/modals/home_portfolio.dart';
import 'package:stocks_news_new/modals/home_sentiment_res.dart';
import 'package:stocks_news_new/modals/home_slider_res.dart';
import 'package:stocks_news_new/modals/home_top_gainer_res.dart';
import 'package:stocks_news_new/modals/home_top_loser_res.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/modals/ipo_res.dart';
import 'package:stocks_news_new/modals/stock_infocus.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/featured_watchlist.dart';
import '../modals/most_purchased.dart';

class HomeProvider extends ChangeNotifier {
  // HomeRes? _home;
  String? _error;
//
  Status _statusSlider = Status.ideal;
  Status get statusSlider => _statusSlider;

  Status _statusSentiment = Status.ideal;
  Status get statusSentiment => _statusSentiment;

  Status _statusTrending = Status.ideal;
  Status get statusTrending => _statusTrending;

  Status _statusGainers = Status.ideal;
  Status get statusGainers => _statusGainers;

  Status _statusLosers = Status.ideal;
  Status get statusLosers => _statusLosers;

  Status _statusInsider = Status.ideal;
  Status get statusInsider => _statusInsider;

  // Status _statusIpo = Status.ideal;
  // Status get statusIpo => _statusIpo;

  Status _statusBenefits = Status.ideal;
  Status get statusBenefits => _statusBenefits;

  Status _statusHomeAlert = Status.ideal;
  Status get statusHomeAlert => _statusHomeAlert;

  Status _statusFocus = Status.ideal;
  Status get statusFocus => _statusFocus;

  Status _statusPortfolio = Status.ideal;
  Status get statusPortfolio => _statusPortfolio;

  // HomeRes? get data => _home;

  Extra? _extra;
  Extra? get extra => _extra;

  HomeSliderRes? _homeSliderRes;
  HomeSliderRes? get homeSliderRes => _homeSliderRes;

  HomeSentimentRes? _homeSentimentRes;
  HomeSentimentRes? get homeSentimentRes => _homeSentimentRes;

  HomeTrendingRes? _homeTrendingRes;
  HomeTrendingRes? get homeTrendingRes => _homeTrendingRes;

  int _openIndexBenefit = -1;
  int get openIndexbenefit => _openIndexBenefit;

  void setOpenIndexBenefit(index) {
    _openIndexBenefit = index;
    notifyListeners();
  }

  List<String> benefitTabs = [
    'Earn Rewards',
    'Redeem Rewards',
  ];

  BenefitsRes? _benefitRes;
  BenefitsRes? get benefitRes => _benefitRes;

  HomeTopGainerRes? _homeTopGainerRes;
  HomeTopGainerRes? get homeTopGainerRes => _homeTopGainerRes;

  HomeTopLosersRes? _homeTopLosersRes;
  HomeTopLosersRes? get homeTopLosersRes => _homeTopLosersRes;

  HomeInsiderRes? _homeInsiderRes;
  HomeInsiderRes? get homeInsiderRes => _homeInsiderRes;

  HomePortfolioRes? _homePortfolio;
  HomePortfolioRes? get homePortfolio => _homePortfolio;

  List<IpoRes>? _ipoRes;
  List<IpoRes>? get ipoRes => _ipoRes;

  bool get isLoadingSlider => _statusSlider == Status.loading;
  bool get isLoadingSentiment => _statusSentiment == Status.loading;
  bool get isLoadingTrending => _statusTrending == Status.loading;
  bool get isLoadingInsider => _statusInsider == Status.loading;
  // bool get isLoadingIpo => _statusIpo == Status.loading;
  bool get isLoadingBenefits => _statusBenefits == Status.loading;
  bool get isLoadingHomeAlert => _statusHomeAlert == Status.loading;
  bool get isLoadingStockFocus => _statusFocus == Status.loading;
  bool get isLoadingGainers => _statusGainers == Status.loading;
  bool get isLoadingLosers => _statusLosers == Status.loading;
  bool get isLoadingPortfolio => _statusPortfolio == Status.loading;

  bool popularPresent = true;

  int? userAlert;

  int _openIndex = -1;
  int get openIndex => _openIndex;
  bool topLoading = false;
  String? get error => _error ?? Const.errSomethingWrong;

  List<HomeAlertsRes>? _homeAlertData;
  List<HomeAlertsRes>? get homeAlertData => _homeAlertData;

  StockInFocusRes? _focusRes;
  StockInFocusRes? get focusRes => _focusRes;

  // SdBenefitAnalyst? _benefitFocus;
  // SdBenefitAnalyst? get benefitFocus => _benefitFocus;

  bool notificationSeen = false;
  String? loginTxt;
  String? signUpTxt;

  int totalAlerts = 0;
  int totalWatchList = 0;
  final AudioPlayer _player = AudioPlayer();

  void setSheetText({String? loginText, String? signupText}) {
    loginTxt = loginText;
    signUpTxt = signupText;
    notifyListeners();
  }

  void setTotalsAlerts(int value) {
    totalAlerts = value;
    notifyListeners();
  }

  void setTotalsWatchList(int value) {
    totalWatchList = value;
    notifyListeners();
  }

  setNotification(value) {
    notificationSeen = value;
    notifyListeners();
  }

  void open(int index) {
    _openIndex = index;
    notifyListeners();
  }

  Future createAlertSend({
    required String alertName,
    required String symbol,
    required int index,
    bool selectedOne = false,
    bool selectedTwo = false,
    type,
  }) async {
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol,
      "alert_name": alertName,
      "sentiment_spike": selectedOne ? "yes" : "no",
      "mention_spike": selectedTwo ? "yes" : "no",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.createAlert,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        if (type == "homeTrending") {
          _homeTrendingRes?.trending[index].isAlertAdded = 1;
          notifyListeners();
        } else if (type == "homeTopGainers") {
          _homeTopGainerRes?.gainers?[index].isAlertAdded = 1;
          notifyListeners();
        } else if (type == "homeTopLosers") {
          _homeTopLosersRes?.losers?[index].isAlertAdded = 1;
        } else if (type == "homeMostBoughtMembers") {
          _mostPurchasedView?[index].isAlertAdded = 1;
        }

        _extra = (response.extra is Extra ? response.extra as Extra : null);

        Utils().showLog("Inside API ${_extra == null}");
        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsAlerts(response.data['total_alerts']);
        notifyListeners();
      }
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.pop(navigatorKey.currentContext!);
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
      );
      return ApiResponse(status: response.status);
    } catch (e) {
      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future addToWishList({
    required String symbol,
    required bool up,
    required int index,
    type,
  }) async {
    showGlobalProgressDialog();

    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "symbol": symbol
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.addWatchlist,
        request: request,
        showProgress: true,
        removeForceLogin: true,
      );
      if (response.status) {
        //
        if (type == "homeTrending") {
          _homeTrendingRes?.trending[index].isWatchlistAdded = 1;
          notifyListeners();
        } else if (type == "homeTopGainers") {
          _homeTopGainerRes?.gainers?[index].isWatchlistAdded = 1;
          notifyListeners();
        } else if (type == "homeTopLosers") {
          _homeTopLosersRes?.losers?[index].isWatchlistAdded = 1;
        } else if (type == "homeMostBoughtMembers") {
          _mostPurchasedView?[index].isWatchlistAdded = 1;
        }

        // _homeTrendingRes?.trending[index].isWatchlistAdded = 1;

        await _player.play(AssetSource(AudioFiles.alertWeathlist));

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsWatchList(response.data['total_watchlist']);
      }
      showErrorMessage(
          message: response.message,
          type: response.status ? SnackbarType.info : SnackbarType.error);

      closeGlobalProgressDialog();
      return ApiResponse(status: response.status);
    } catch (e) {
      closeGlobalProgressDialog();

      Utils().showLog(e.toString());
      // showErrorMessage(message: Const.errSomethingWrong);
    }
  }

  Future refreshData(String? inAppMsgId) async {
    notifySnackbar = await openNotificationsSettings();

    retryCount = 0;
    showAdd = true;

    getHomePortfolio();
    // _getLastMarketOpen();
    _getLastMarketOpenFW();

    getHomeSlider();
    getFeaturedWatchlist();
    // getHomeAlerts();
    getMostPurchased(home: "home");
    getHomeTrendingData();
    // getBenefitsDetails();

    //ADD AGAIN AFTER BACKEND MERGING
    _homeTopGainerRes = null;
    _homeTopLosersRes = null;
    // getIpoData();
    // getStockInFocus();
    // getHomeSentimentData();
    // getHomeInsiderData(inAppMsgId);
  }

  Future refreshWithCheck() async {
    if (_homeSliderRes == null) {
      getHomeSlider();
    }
    if (_homeAlertData == null) {
      getHomeAlerts();
    }
    if (_homeTrendingRes == null) {
      getHomeTrendingData();
    }
    // if (_benefitRes == null) {
    //   getBenefitsDetails();
    // }
    // if (_ipoRes == null) {
    //   getIpoData();
    // }
    // if (_homeSentimentRes == null) {
    //   getHomeSentimentData();
    // }
    // if (_focusRes == null) {
    //   getStockInFocus();
    // }
    // if (_homeInsiderRes == null) {
    //   getHomeInsiderData(null);
    // }
  }

  updateReferShare(text) {
    _extra?.referral?.shareText = text;
    notifyListeners();
  }

  // PurchasesConfiguration? _configuration;

  // void _configureRevenueCat() async {
  //   Utils().showLog("---CONFIGURE START----");
  //   try {
  //     UserRes? user = navigatorKey.currentContext!.read<UserProvider>().user;
  //     RevenueCatKeyRes? keys = _extra?.revenueCatKeys;
  //     if (Platform.isAndroid) {
  //       _configuration = PurchasesConfiguration(
  //           keys?.playStore ?? "goog_KXHVJRLChlyjoOamWsqCWQSJZfI")
  //         ..appUserID = user?.userId ?? "";
  //     } else if (Platform.isIOS) {
  //       _configuration = PurchasesConfiguration(
  //           keys?.appStore ?? "appl_kHwXNrngqMNktkEZJqYhEgLjbcC")
  //         ..appUserID = user?.userId ?? "";
  //     }
  //     if (_configuration != null) {
  //       try {
  //         await Purchases.configure(_configuration!);
  //       } catch (e) {
  //         await Purchases.configure(_configuration!);
  //       }
  //     }
  //   } catch (e) {
  //     //
  //   }
  // }

  Future getHomeSlider({showProgress = false, String? addId}) async {
    _statusSlider = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    String? fcmToken = await Preference.getFcmToken();
    bool granted = await Permission.notification.isGranted;

    try {
      fcmToken ??= await FirebaseMessaging.instance.getToken();
      Map request = {
        "token": provider.user?.token ?? "",
        "fcm_token": fcmToken ?? "",
        "fcm_permission": "$granted",
        "platform": Platform.operatingSystem,
      };
      if (addId != null) {
        request.addAll({"ad_id": addId});
      }
      ApiResponse response = await apiRequest(
        url: Apis.homeSlider,
        request: request,
        showProgress: showProgress,
        updateDatabase: true,
        onAddClick: () async {
          getHomeSlider(addId: _extra?.adManager?.adId);
        },
        onRefresh: () => refreshData(null),
      );

      if (response.status) {
        //...........PLAID KEYS SET............
        // String basePlaidUrl = "https://sandbox.plaid.com";
        // clientId = "665336b8bff5c6001ce3aafc";
        // secret = "7181521c1dd4c3353ea995024697ef";
        // createAPI = "$basePlaidUrl/link/token/create";
        // exchangeAPI = "$basePlaidUrl/item/public_token/exchange";
        // holdingsAPI = "$basePlaidUrl/investments/holdings/get";
        //.....................................
        _homeSliderRes = HomeSliderRes.fromJson(response.data);
        Utils().showLog("-----!!${_homeSliderRes?.rating?.description}");
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        Preference.saveReferInput(_extra?.affiliateInput == 1);
        loginTxt = _extra?.loginText;
        signUpTxt = _extra?.signUpText;
        totalAlerts = _homeSliderRes?.totalAlerts ?? 0;
        totalWatchList = _homeSliderRes?.totalWatchList ?? 0;
        if (_extra?.messageObject != null) {
          Preference.saveLocalDataBase(_extra?.messageObject);
        }
        if (_extra?.messageObject?.error != null) {
          Const.errSomethingWrong = _extra?.messageObject?.error ?? "";
          Const.loadingMessage = _extra?.messageObject?.loading ?? "";
          if (_extra?.user != null) {
            navigatorKey.currentContext!
                .read<UserProvider>()
                .setUser(_extra!.user!);
          }
        }

        if (_extra != null) {
          notificationSeen = (response.extra as Extra).notificationCount == 0;
          showMembership = (response.extra as Extra).showMembership == true;
        }
        // _configureRevenueCat();

        notifyListeners();
      } else {
        _homeSliderRes = null;
      }
      _statusSlider = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeSliderRes = null;
      _statusSlider = Status.loaded;
      Utils().showLog("-----$e-------");
      notifyListeners();
    }
  }

  Extra? _trendingExtra;
  Extra? get trendingExtra => _trendingExtra;

  Future getHomeTrendingData() async {
    topLoading = true;
    // popularPresent = true;
    _statusTrending = Status.loading;
    notifyListeners();

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {"token": provider.user?.token ?? ""};
      ApiResponse response = await apiRequest(
        url: Apis.homeTrending,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
        removeForceLogin: true,
      );
      if (response.status) {
        _homeTrendingRes = HomeTrendingRes.fromJson(response.data);
        // if (_homeTrendingRes?.popular.isEmpty == true ||
        //     _homeTrendingRes?.popular == null ||
        //     _homeTrendingRes == null) {
        //   popularPresent = false;
        //   notifyListeners();
        // }
      } else {
        _homeTrendingRes = null;
        _error = "Data not found";
      }
      _trendingExtra =
          (response.extra is Extra ? response.extra as Extra : null);

      topLoading = false;
      _statusTrending = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeTrendingRes = null;
      _error = Const.errSomethingWrong;
      topLoading = false;
      _statusTrending = Status.loaded;
      Utils().showLog(e);
      notifyListeners();
    }
  }

  Future getHomeTopGainerData() async {
    // popularPresent = true;
    _statusGainers = Status.loading;
    notifyListeners();

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
        "type": "gainers",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeTopGainerLoser,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
        removeForceLogin: true,
      );

      if (response.status) {
        _homeTopGainerRes = HomeTopGainerRes.fromJson(response.data);
        // if (_homeTrendingRes?.popular.isEmpty == true ||
        //     _homeTrendingRes?.popular == null ||
        //     _homeTrendingRes == null) {
        //   popularPresent = false;
        //   notifyListeners();
        // }
      } else {
        _homeTopGainerRes = null;
        _error = "Data not found";
      }
      _statusGainers = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeTopGainerRes = null;
      _error = Const.errSomethingWrong;
      _statusGainers = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeTopLoserData() async {
    // popularPresent = true;
    _statusLosers = Status.loading;
    notifyListeners();

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
        "type": "losers",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeTopGainerLoser,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
        removeForceLogin: true,
      );
      if (response.status) {
        _homeTopLosersRes = HomeTopLosersRes.fromJson(response.data);
        // if (_homeTrendingRes?.popular.isEmpty == true ||
        //     _homeTrendingRes?.popular == null ||
        //     _homeTrendingRes == null) {
        //   popularPresent = false;
        //   notifyListeners();
        // }
      } else {
        _homeTopLosersRes = null;
        _error = "Data not found";
      }
      _statusLosers = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeTopLosersRes = null;
      _error = Const.errSomethingWrong;
      _statusLosers = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomePortfolio() async {
    _statusPortfolio = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homePortfolio,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
        removeForceLogin: true,
      );

      if (response.status) {
        _homePortfolio = homePortfolioResFromJson(jsonEncode(response.data));

        if (kDebugMode) {
          // _homePortfolio = HomePortfolioRes(
          //     top: _homePortfolio?.top,
          //     bottom: _homePortfolio?.bottom,
          //     keys: PortfolioKeys(
          //       plaidSecret: "7181521c1dd4c3353ea995024697ef",
          //       plaidClient: "665336b8bff5c6001ce3aafc",
          //       plaidEnv: "sandbox",
          //     ));
        }
      } else {
        _homePortfolio = null;
        //
      }
      _statusPortfolio = Status.loaded;
      notifyListeners();

      return ApiResponse(status: true, data: response.data);
    } catch (e) {
      _homePortfolio = null;
      _statusPortfolio = Status.loaded;
      notifyListeners();
      return ApiResponse(status: false);
    }
    // closeGlobalProgressDialog();
  }

// Featured Watchlist Data

  Status _statusFW = Status.ideal;
  Status get statusFW => _statusFW;

  Extra? _extraFW;
  Extra? get extraFW => _extraFW;

  bool get isLoadinFW => _statusFW == Status.loading;

  setStatusFW(Status value) {
    _statusFW = value;
    notifyListeners();
  }

  FeaturedWatchlistRes? _fwData;
  FeaturedWatchlistRes? get fwData => _fwData;

  Future getFeaturedWatchlist({bool userAvail = true}) async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    // _fwData = null;
    setStatusFW(Status.loading);
    try {
      Map request = {
        "token": userAvail ? provider.user?.token ?? "" : "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.featuredWatchlist,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
        removeForceLogin: true,
      );
      setStatusFW(Status.loading);

      if (response.status) {
        _extraFW = (response.extra is Extra ? response.extra as Extra : null);
        _fwData = featuredWatchlistResFromJson(jsonEncode(response.data));
      } else {
        _fwData = null;
      }
      apiKeyFMP = response.extra?.apiKeyFMP;
      _updateFeaturedChartData();
    } catch (e) {
      _fwData = null;
      setStatusFW(Status.loading);
      Utils().showLog("ERROR $e");
    }
  }

  Future getHomeAlerts({bool userAvail = true}) async {
    _statusHomeAlert = Status.loading;
    _homeAlertData = null;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": userAvail ? provider.user?.token ?? "" : "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeAlert,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
        removeForceLogin: true,
      );

      if (response.status) {
        _homeAlertData = homeAlertsResFromJson(jsonEncode(response.data));
      } else {
        _homeAlertData = null;
      }
      apiKeyFMP = response.extra?.apiKeyFMP;
      userAlert = response.extra?.userAlert;
      _statusHomeAlert = Status.loaded;
      notifyListeners();
      _updateChartData();
    } catch (e) {
      _homeAlertData = null;
      _statusHomeAlert = Status.loaded;
      notifyListeners();
    }
    // closeGlobalProgressDialog();
  }

  Future getBenefitsDetails() async {
    _statusBenefits = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.benefitAnalysis,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
      );
      if (response.status) {
        _benefitRes = benefitsResFromJson(jsonEncode(response.data));
      } else {
        _benefitRes = null;
      }
      _statusBenefits = Status.loaded;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _benefitRes = null;
      _statusBenefits = Status.loaded;
      notifyListeners();
    }
  }

  // Future<void> apiIsolate(SendPort sendPort, String apiUrl, Map request) async {
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: apiUrl,
  //       request: request,
  //       showProgress: false,
  //       onRefresh: () => refreshData(null),
  //     );
  //     sendPort.send(response);
  //   } catch (e) {
  //     sendPort.send(e);
  //   }
  // }

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
        onRefresh: () => refreshData(null),
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
      _statusFocus = Status.loaded;
      notifyListeners();
    }
  }

  // Future getIpoData() async {
  //   _statusIpo = Status.loading;
  //   notifyListeners();
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   try {
  //     Map request = {
  //       "token": provider.user?.token ?? "",
  //     };
  //     ApiResponse response = await apiRequest(
  //       url: Apis.ipoCalendar,
  //       request: request,
  //       showProgress: false,
  //       onRefresh: () => refreshData(null),
  //     );
  //     if (response.status) {
  //       _ipoRes = ipoResFromJson(jsonEncode(response.data));
  //     } else {
  //       _ipoRes = null;
  //     }
  //     _statusIpo = Status.loaded;
  //     notifyListeners();
  //   } catch (e) {
  //     _ipoRes = null;
  //     _statusIpo = Status.loaded;
  //     notifyListeners();
  //   }
  // }

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
        onRefresh: () => refreshData(null),
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
      _statusSentiment = Status.loaded;
      notifyListeners();
    }
  }

  Future getHomeInsiderData(inAppMsgId) async {
    _statusInsider = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
      };
      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId});
      }
      ApiResponse response = await apiRequest(
        url: Apis.homeInsider,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
      );
      if (response.status) {
        _homeInsiderRes = HomeInsiderRes.fromJson(response.data);
      } else {
        _homeInsiderRes = null;
        // showErrorMessage(message: response.message);
      }
      _statusInsider = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeInsiderRes = null;
      _statusInsider = Status.loaded;
      notifyListeners();
    }
  }

  Future checkMaintenanceMode() async {
    _statusSlider = Status.loading;
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    String? fcmToken = await Preference.getFcmToken();
    bool granted = await Permission.notification.isGranted;

    try {
      fcmToken ??= await FirebaseMessaging.instance.getToken();
      Map request = {
        "token": provider.user?.token ?? "",
        "fcm_token": fcmToken ?? "",
        "fcm_permission": "$granted",
      };
      ApiResponse response = await apiRequest(
        url: Apis.homeSlider,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
      );
      _statusSlider = Status.loaded;
      notifyListeners();
      if (response.status) {
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        if (_extra?.messageObject != null) {
          Preference.saveLocalDataBase(_extra?.messageObject);
        }
        if (_extra?.messageObject?.error != null) {
          Const.errSomethingWrong = _extra?.messageObject?.error ?? "";
          Const.loadingMessage = _extra?.messageObject?.loading ?? "";
        }
        MessageRes? localDataBase = await Preference.getLocalDataBase();
        Utils().showLog("localDataBase  =========${localDataBase?.error}");

        if ((response.extra as Extra).maintenance != null) return true;
      }
      return false;
    } catch (e) {
      _statusSlider = Status.loaded;
      notifyListeners();
      return false;
    }
  }

  // -------------  Start Update Chart data on HomePage ------------
  int retryCountFW = 0;
  void _updateFeaturedChartData() async {
    if (_fwData == null ||
        (_fwData?.featuredTickers == null ||
            _fwData?.featuredTickers?.isEmpty == true)) return;
    for (var item in _fwData!.featuredTickers!) {
      if (item.chart == null || (item.chart?.isEmpty ?? true)) {
        await getHomeAlertsGraphDataFW(symbol: item.symbol);
      }
    }

    bool callAgain = false;
    for (var item in _fwData!.featuredTickers!) {
      if (item.chart == null || (item.chart?.isEmpty ?? true)) {
        callAgain = true;
        break;
      }
    }
    if (callAgain && retryCountFW < 1) {
      retryCountFW++;
      _updateFeaturedChartData();
    }
  }

  int retryCount = 0;
  void _updateChartData() async {
    if (_homeAlertData == null || (_homeAlertData?.isEmpty ?? true)) return;
    for (var item in _homeAlertData!) {
      if (item.chart == null || (item.chart?.isEmpty ?? true)) {
        await getHomeAlertsGraphData(symbol: item.symbol);
      }
    }

    bool callAgain = false;
    for (var item in _homeAlertData!) {
      if (item.chart == null || (item.chart?.isEmpty ?? true)) {
        callAgain = true;
        break;
      }
    }
    if (callAgain && retryCount < 1) {
      retryCount++;
      _updateChartData();
    }
  }

  DateTime? _lastMarketOpen;
  DateTime? _lastMarketOpenFW;

  Future _getLastMarketOpen() async {
    ApiResponse response = await third_party_api.apiRequest(
      url: "quote/AAPL?apikey=5e5573e6668fcd5327987ab3b912ef3e",
      showProgress: false,
    );

    if (response.status == true) {
      var timeStamp = response.data[0]['timestamp'];
      _lastMarketOpen = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      _lastMarketOpen =
          _lastMarketOpen!.toUtc().subtract(const Duration(hours: 4));
    }
  }

  Future _getLastMarketOpenFW() async {
    ApiResponse response = await third_party_api.apiRequest(
      url: "quote/AAPL?apikey=5e5573e6668fcd5327987ab3b912ef3e",
      showProgress: false,
    );

    if (response.status == true) {
      var timeStamp = response.data[0]['timestamp'];
      _lastMarketOpenFW = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
      _lastMarketOpenFW =
          _lastMarketOpenFW!.toUtc().subtract(const Duration(hours: 4));
    }
  }

  bool _isLastOpenToday(DateTime date1, DateTime date2) {
    // Convert both dates to midnight by creating new DateTime objects
    DateTime midnightDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime midnightDate2 = DateTime(date2.year, date2.month, date2.day);
    // Compare the two dates
    return midnightDate1.isAtSameMomentAs(midnightDate2);
  }

  Future getHomeAlertsGraphDataFW({required String symbol}) async {
    if (_lastMarketOpenFW == null) {
      Utils().showLog("_lastMarketOpenFW is null");
      await _getLastMarketOpenFW();
    }

    // // Current time in GMT-4
    DateTime today = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    bool isLastOpenToday = false;

    if (_lastMarketOpenFW != null) {
      isLastOpenToday = _isLastOpenToday(_lastMarketOpenFW!, today);
    }

    String interval = "15min";

    // Fixed time 10:30 AM in GMT-4
    DateTime fixedTime = DateTime.utc(
      DateTime.now().toUtc().year,
      DateTime.now().toUtc().month,
      DateTime.now().toUtc().day,
      10,
      30,
    ).toUtc();

    if (today.isBefore(fixedTime) && isLastOpenToday) {
      // if (currentTime.isBefore(fixedTime)) {
      interval = '5min';
    }

    String formattedToday =
        DateFormat('yyyy-MM-dd').format(_lastMarketOpenFW ?? today);

    try {
      ApiResponse response = await third_party_api.apiRequest(
        url:
            // "historical-chart/$interval/$symbol?from=$formattedToday&to=$formattedToday&apikey=5e5573e6668fcd5327987ab3b912ef3e",
            "historical-chart/$interval/$symbol?from=$formattedToday&to=$formattedToday&apikey=$apiKeyFMP",
        showProgress: false,
      );

      if (response.status == true) {
        List<Chart> data = response.data == null
            ? []
            : List<Chart>.from(response.data!.map((x) => Chart.fromJson(x)));
        int? index = _fwData?.featuredTickers
            ?.indexWhere((element) => element.symbol == symbol);
        if (index != null && index >= 0) {
          _fwData?.featuredTickers?[index].chart = data;
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  Future getHomeAlertsGraphData({required String symbol}) async {
    if (_lastMarketOpen == null) {
      await _getLastMarketOpen();
    }

    // // Current time in GMT-4
    DateTime today = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    bool isLastOpenToday = false;

    if (_lastMarketOpen != null) {
      isLastOpenToday = _isLastOpenToday(_lastMarketOpen!, today);
    }

    String interval = "15min";

    // Fixed time 10:30 AM in GMT-4
    DateTime fixedTime = DateTime.utc(
      DateTime.now().toUtc().year,
      DateTime.now().toUtc().month,
      DateTime.now().toUtc().day,
      10,
      30,
    ).toUtc();

    if (today.isBefore(fixedTime) && isLastOpenToday) {
      // if (currentTime.isBefore(fixedTime)) {
      interval = '5min';
    }

    String formattedToday =
        DateFormat('yyyy-MM-dd').format(_lastMarketOpen ?? today);

    try {
      ApiResponse response = await third_party_api.apiRequest(
        url:
            // "historical-chart/$interval/$symbol?from=$formattedToday&to=$formattedToday&apikey=5e5573e6668fcd5327987ab3b912ef3e",
            "historical-chart/$interval/$symbol?from=$formattedToday&to=$formattedToday&apikey=$apiKeyFMP",
        showProgress: false,
      );

      if (response.status == true) {
        List<Chart> data = response.data == null
            ? []
            : List<Chart>.from(response.data!.map((x) => Chart.fromJson(x)));
        int? index =
            _homeAlertData?.indexWhere((element) => element.symbol == symbol);
        if (index != null && index >= 0) {
          _homeAlertData![index].chart = data;
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

  // -------------  End Update Chart data on HomePage ------------

  void _checkForNewVersion(Extra extra) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String versionName = packageInfo.version;
    String buildCode = packageInfo.buildNumber;
    if (Platform.isAndroid &&
        (extra.androidBuildCode ?? 0) > int.parse(buildCode)) {
      showAppUpdateDialog(extra);
    } else if (Platform.isIOS &&
        (extra.iOSBuildCode ?? 0) > int.parse(buildCode)) {
      showAppUpdateDialog(extra);
    }
  }

  Future updateInAppMsgStatus(id) async {
    notifyListeners();
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    String? fcmToken = await Preference.getFcmToken();
    try {
      Map request = {
        "token": provider.user?.token ?? "",
        "fcmToken": fcmToken,
        "id": id,
      };
      await apiRequest(
        url: Apis.updateInAppCount,
        request: request,
        showProgress: false,
      );
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }

//Most Purchased Stocks

  String? _errorMostPurchased;
  String? get errorMostPurchased =>
      _errorMostPurchased ?? Const.errSomethingWrong;

  Status _statusMostPurchased = Status.ideal;
  Status get status => _statusMostPurchased;

  bool get isLoadingMostPurchased =>
      _statusMostPurchased == Status.loading ||
      _statusMostPurchased == Status.ideal;

  Extra? _extraMostPopular;
  Extra? get extraMostPopular => _extraMostPopular;

  List<MostPurchasedRes>? _mostPurchased;
  List<MostPurchasedRes>? get mostPurchased => _mostPurchased;

  List<MostPurchasedRes>? _mostPurchasedView;
  List<MostPurchasedRes>? get mostPurchasedView => _mostPurchasedView;

  void setStatusMostPurchased(status) {
    _statusMostPurchased = status;
    notifyListeners();
  }

  Future getMostPurchased({String? home}) async {
    setStatusMostPurchased(Status.loading);

    try {
      FormData request = FormData.fromMap({
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "type": home ?? ""
      });
      ApiResponse response = await apiRequest(
        url: Apis.mostPurchased,
        formData: request,
        showProgress: false,
      );
      if (response.status) {
        if (home != null) {
          _mostPurchased = mostPurchasedResFromJson(jsonEncode(response.data));
        } else {
          _mostPurchasedView =
              mostPurchasedResFromJson(jsonEncode(response.data));
        }
      } else {
        if (home != null) {
          _mostPurchased = null;
        } else {
          _mostPurchasedView = null;
        }

        _errorMostPurchased = response.message;
      }
      _extraMostPopular =
          (response.extra is Extra ? response.extra as Extra : null);

      setStatusMostPurchased(Status.loaded);
    } catch (e) {
      if (home != null) {
        _mostPurchased = null;
      } else {
        _mostPurchasedView = null;
      }

      _errorMostPurchased = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatusMostPurchased(Status.loaded);
    }
  }
}
