import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/third_party_api_requester.dart'
    as third_party_api;
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
    notifyListeners();
  }

  void setTotalsWatchList(int value) {
    totalWatchList = value;
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

  Future refreshData(String? inAppMsgId) async {
    _getLastMarketOpen();
    getHomeSlider();
    getHomeTrendingData();
    getHomeAlerts();

    // getIpoData();
    // getStockInFocus();
    // getHomeSentimentData();
    // getHomeInsiderData(inAppMsgId);
  }

  Future refreshWithCheck() async {
    if (_homeSliderRes == null) {
      getHomeSlider();
    }
    if (_homeTrendingRes == null) {
      getHomeTrendingData();
    }
    if (_homeAlertData == null) {
      getHomeAlerts();
    }
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

  Future getHomeSlider() async {
    // showGlobalProgressDialog();

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
        onRefresh: () => refreshData(null),
      );
      if (response.status) {
        _homeSliderRes = HomeSliderRes.fromJson(response.data);
        totalAlerts = _homeSliderRes?.totalAlerts ?? 0;
        totalWatchList = _homeSliderRes?.totalWatchList ?? 0;
        if (response.extra != null && response.extra is Extra) {
          notificationSeen = (response.extra as Extra).notificationCount == 0;
          _checkForNewVersion(response.extra as Extra);
        }
        notifyListeners();
      } else {
        _homeSliderRes = null;
      }
      _statusSlider = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeSliderRes = null;
      _statusSlider = Status.loaded;
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
        url: Apis.homeTrending,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
      );
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
      );

      if (response.status) {
        _homeAlertData = homeAlertsResFromJson(jsonEncode(response.data));
      } else {
        _homeAlertData = null;
      }
      userAlert = response.extra?.userAlert;
      _statusHomeAlert = Status.loaded;
      notifyListeners();
    } catch (e) {
      _homeAlertData = null;
      _statusHomeAlert = Status.loaded;
      notifyListeners();
    }
    // closeGlobalProgressDialog();
  }

  Future<void> apiIsolate(SendPort sendPort, String apiUrl, Map request) async {
    try {
      ApiResponse response = await apiRequest(
        url: apiUrl,
        request: request,
        showProgress: false,
        onRefresh: () => refreshData(null),
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
        onRefresh: () => refreshData(null),
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
      _statusIpo = Status.loaded;
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

  DateTime? _lastMarketOpen;

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

  bool _isLastOpenToday(DateTime date1, DateTime date2) {
    // Convert both dates to midnight by creating new DateTime objects
    DateTime midnightDate1 = DateTime(date1.year, date1.month, date1.day);
    DateTime midnightDate2 = DateTime(date2.year, date2.month, date2.day);

    // Compare the two dates
    return midnightDate1.isAtSameMomentAs(midnightDate2);
  }

  Future<List<Chart>?> getHomeAlertsGraphData({required String symbol}) async {
    if (_lastMarketOpen == null) {
      await _getLastMarketOpen();
    }

    // // Current time in GMT-4
    DateTime today = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    bool isLastOpenToday = false;
    if (_lastMarketOpen == null) {
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

    // Adjust for GMT-4
    // DateTime today = DateTime.now().toUtc().subtract(const Duration(hours: 4));

    String formattedToday =
        DateFormat('yyyy-MM-dd').format(_lastMarketOpen ?? today);

    try {
      ApiResponse response = await third_party_api.apiRequest(
        url:
            "historical-chart/$interval/$symbol?from=$formattedToday&to=$formattedToday&apikey=5e5573e6668fcd5327987ab3b912ef3e",
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
        return data;
      } else {
        // int weekDay = today.weekday;
        // DateTime adjustedToday;

        // if (weekDay == DateTime.monday) {
        //   adjustedToday = today.subtract(const Duration(days: 3));
        // } else if (weekDay == DateTime.sunday) {
        //   adjustedToday = today.subtract(const Duration(days: 2));
        // } else {
        //   adjustedToday = today.subtract(const Duration(days: 1));
        // }
        // String formattedNewDate =
        //     DateFormat('yyyy-MM-dd').format(adjustedToday);
        // ApiResponse res = await third_party_api.apiRequest(
        //   url:
        //       "historical-chart/15min/$symbol?from=$formattedNewDate&to=$formattedNewDate&apikey=5e5573e6668fcd5327987ab3b912ef3e",
        //   showProgress: false,
        // );

        // if (res.status == true) {
        //   List<Chart> data = res.data == null
        //       ? []
        //       : List<Chart>.from(res.data!.map((x) => Chart.fromJson(x)));
        //   int? index =
        //       _homeAlertData?.indexWhere((element) => element.symbol == symbol);
        //   if (index != null && index >= 0) {
        //     _homeAlertData![index].chart = data;
        //     notifyListeners();
        //   }
        //   return data;
        // }
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Chart>?> getHomeAlertsGraphData1({required String symbol}) async {
    String interval = "15min";

    // Current time in GMT-4
    DateTime currentTime =
        DateTime.now().toUtc().subtract(const Duration(hours: 4));

    // Fixed time 10:30 AM in GMT-4
    DateTime fixedTime = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      10,
      30,
    ).toUtc();

    if (currentTime.isBefore(fixedTime)) {
      interval = '5min';
    }
    // Adjust for GMT-4
    DateTime today =
        DateTime.now().toUtc().subtract(const Duration(hours: 4)).toLocal();
    String formattedToday = DateFormat('yyyy-MM-dd').format(today);

    try {
      ApiResponse response = await third_party_api.apiRequest(
        url:
            "$interval/$symbol?from=$formattedToday&to=$formattedToday&apikey=5e5573e6668fcd5327987ab3b912ef3e",
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
        return data;
      } else {
        int weekDay = today.weekday;
        DateTime adjustedToday;

        if (weekDay == DateTime.monday) {
          adjustedToday = today.subtract(const Duration(days: 3));
        } else if (weekDay == DateTime.sunday) {
          adjustedToday = today.subtract(const Duration(days: 2));
        } else {
          adjustedToday = today.subtract(const Duration(days: 1));
        }
        String formattedNewDate =
            DateFormat('yyyy-MM-dd').format(adjustedToday);
        ApiResponse res = await third_party_api.apiRequest(
          url:
              "15min/$symbol?from=$formattedNewDate&to=$formattedNewDate&apikey=5e5573e6668fcd5327987ab3b912ef3e",
          showProgress: false,
        );

        if (res.status == true) {
          List<Chart> data = res.data == null
              ? []
              : List<Chart>.from(res.data!.map((x) => Chart.fromJson(x)));
          int? index =
              _homeAlertData?.indexWhere((element) => element.symbol == symbol);
          if (index != null && index >= 0) {
            _homeAlertData![index].chart = data;
            notifyListeners();
          }
          return data;
        }
        return null;
      }
    } catch (e) {
      return null;
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

  // void _showUpdateDialog(Extra extra) {
  //   showGeneralDialog(
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionBuilder: (context, a1, a2, widget) {
  //       return SafeArea(
  //         child: Align(
  //           alignment: Alignment.bottomCenter,
  //           child: Transform.scale(
  //             scale: a1.value,
  //             child: Opacity(
  //               opacity: a1.value,
  //               child: Stack(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {},
  //                     child: Container(
  //                       width: double.infinity,
  //                       height: double.infinity,
  //                       color: Colors.transparent,
  //                     ),
  //                   ),
  //                   Dialog(
  //                     insetPadding: EdgeInsets.symmetric(
  //                       horizontal:
  //                           ScreenUtil().screenWidth * (isPhone ? .1 : .2),
  //                     ),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(16.0),
  //                     ),
  //                     elevation: 0,
  //                     backgroundColor: Colors.transparent,
  //                     child: AppUpdateContent(extra: extra),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionDuration: const Duration(milliseconds: 200),
  //     barrierDismissible: true,
  //     barrierLabel: '',
  //     context: navigatorKey.currentContext!,
  //     pageBuilder: (context, animation1, animation2) {
  //       return const SizedBox();
  //     },
  //   );
  // }

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
}
