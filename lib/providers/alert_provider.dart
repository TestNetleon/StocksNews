// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/api/api_requester.dart';
// import 'package:stocks_news_new/api/api_response.dart';
// import 'package:stocks_news_new/api/apis.dart';
// import 'package:stocks_news_new/modals/alerts_res.dart';
// import 'package:stocks_news_new/modals/home_trending_res.dart';
// import 'package:stocks_news_new/providers/auth_provider_base.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// //
// class AlertProvider extends ChangeNotifier with AuthProviderBase {
//   AlertRes? _data;
//   String? _error;
//   Status _status = Status.ideal;
//   int _page = 1;

//   List<AlertData>? get data => _data?.data;
//   bool get canLoadMore => _page < (_data?.lastPage ?? 1);
//   String? get error => _error ?? Const.errSomethingWrong;

//   TextRes? _textRes;
//   TextRes? get textRes => _textRes;

//   Extra? _extra;
//   Extra? get extra => _extra;

//   // int? get page => _page;
//   bool get isLoading => _status == Status.loading;
//   void setStatus(status) {
//     _status = status;
//     notifyListeners();
//   }

//   Future onRefresh() async {
//     _page = 1;
//     getAlerts();
//   }

//   Future getAlerts({showProgress = false, loadMore = false}) async {
//     // Utils().showLog("Can load more $canLoadMore");
//     if (loadMore) {
//       _page++;
//       setStatus(Status.loadingMore);
//     } else {
//       _page = 1;
//       setStatus(Status.loading);
//     }
//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//         "page": "$_page"
//       };
//       ApiResponse response = await apiRequest(
//         url: Apis.alerts,
//         request: request,
//         showProgress: showProgress,
//         onRefresh: onRefresh,
//       );

//       if (response.status) {
//         _error = null;
//         if (_page == 1) {
//           _data = alertResFromJson(jsonEncode(response.data));
//           _extra = (response.extra is Extra ? response.extra as Extra : null);
//           if (_data?.data?.isEmpty == true) {
//             _error = "Your alert list is currently empty.";
//           }
//         } else {
//           _data?.data
//               ?.addAll(alertResFromJson(jsonEncode(response.data)).data ?? []);
//         }
//       } else {
//         if (_page == 1) {
//           _data = null;
//           _error = response.message;
//           // showErrorMessage(message: response.message);
//         }
//       }
//       if (response.extra is! List) {
//         _textRes = response.extra?.text;
//       }
//       setStatus(Status.loaded);
//     } catch (e) {
//       _data = null;

//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }

//   Future deleteItem(String id, String symbol) async {
//     setStatus(Status.loading);

//     try {
//       Map request = {
//         "token":
//             navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
//         "id": id
//       };

//       ApiResponse response = await apiRequest(
//         url: Apis.deleteAlertlist,
//         request: request,
//         showProgress: true,
//       );

//       if (response.status) {
//         _data?.data?.removeWhere((element) => element.id == id);
//         if (_data?.data == null || _data?.data?.isEmpty == true) {
//           _error = "Your alert list is currently empty.";
//         }

//         String? symbl = navigatorKey.currentContext!
//             .read<StockDetailProvider>()
//             .data
//             ?.keyStats
//             ?.symbol;
//         if (symbl == symbol) {
//           navigatorKey.currentContext!
//               .read<StockDetailProvider>()
//               .changeAlert(0);
//         }

//         navigatorKey.currentContext!
//             .read<HomeProvider>()
//             .setTotalsAlerts(response.data['total_alerts']);
//       } else {
//         //
//       }
//       // showErrorMessage(message: response.message, type: SnackbarType.info);

//       setStatus(Status.loaded);
//     } catch (e) {
//       Utils().showLog(e.toString());
//       setStatus(Status.loaded);
//     }
//   }

//   Future logoutUser(request) async {
//     try {
//       ApiResponse res = await apiRequest(
//         url: Apis.logout,
//         request: request,
//         showProgress: true,
//       );
//       if (res.status) {
//         setStatus(Status.loaded);
//         handleSessionOut();
//         // showErrorMessage(message: res.message, type: SnackbarType.info);
//       } else {
//         setStatus(Status.loaded);
//         // showErrorMessage(
//         //   message: res.message,
//         // );
//       }
//     } catch (e) {
//       setStatus(Status.loaded);
//       // showErrorMessage(
//       //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
//       // );
//     }
//   }
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/alerts_res.dart';
import 'package:stocks_news_new/modals/home_trending_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

//
class AlertProvider extends ChangeNotifier with AuthProviderBase {
  AlertRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  List<AlertData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  TextRes? _textRes;
  TextRes? get textRes => _textRes;

  Extra? _extra;
  Extra? get extra => _extra;

  // int? get page => _page;
  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    getAlerts();
  }

  Future getAlerts({showProgress = false, loadMore = false}) async {
    // Utils().showLog("Can load more $canLoadMore");
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_page"
      };
      ApiResponse response = await apiRequest(
        url: Apis.alerts,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = alertResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
          if (_data?.data?.isEmpty == true) {
            _error = "Your alert list is currently empty.";
          }
        } else {
          _data?.data
              ?.addAll(alertResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      if (response.extra is! List) {
        _textRes = response.extra?.text;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future deleteItem(String id, String symbol) async {
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "id": id
      };

      ApiResponse response = await apiRequest(
        url: Apis.deleteAlertlist,
        request: request,
        showProgress: true,
      );

      if (response.status) {
        _data?.data?.removeWhere((element) => element.id == id);
        if (_data?.data == null || _data?.data?.isEmpty == true) {
          _error = "Your alert list is currently empty.";
        }

        String? symbl = navigatorKey.currentContext!
            .read<StockDetailProviderNew>()
            .tabRes
            ?.keyStats
            ?.symbol;
        if (symbl == symbol) {
          navigatorKey.currentContext!
              .read<StockDetailProviderNew>()
              .changeAlert(0);
        }

        navigatorKey.currentContext!
            .read<HomeProvider>()
            .setTotalsAlerts(response.data['total_alerts']);
      } else {
        //
      }
      // showErrorMessage(message: response.message, type: SnackbarType.info);

      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        // showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(
        //   message: res.message,
        // );
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }
}
