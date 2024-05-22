import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/gap_up_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class GapUpDownProvider extends ChangeNotifier with AuthProviderBase {
  GapUpRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  List<GapUpData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusLosers(status) {
    _status = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    // _openIndex = index;
    notifyListeners();
  }

  void setOpenIndexLosers(index) {
    // _openIndexLosers = index;
    notifyListeners();
  }

  // Future getGapDownStocks({showProgress = false, loadMore = false}) async {
  //   if (loadMore) {
  //     _page++;
  //     setStatus(Status.loadingMore);
  //   } else {
  //     _page = 1;
  //     setStatus(Status.loading);
  //   }
  //   try {
  //     Map request = {
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //       "page": "$_page"
  //     };

  //     ApiResponse response = await apiRequest(
  //       url: Apis.latestNews,
  //       request: request,
  //       showProgress: showProgress,
  //     );

  //     if (response.status) {
  //       _error = null;
  //       if (_page == 1) {
  //         _data = gapUpResFromJson(jsonEncode(response.data));
  //       } else {
  //         _data?.data.addAll(gapUpResFromJson(jsonEncode(response.data)).data);
  //       }
  //     } else {
  //       if (_page == 1) {
  //         _data = null;
  //         _error = response.message;
  //         // showErrorMessage(message: response.message);
  //       }
  //     }
  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     _data = null;
  //     log(e.toString());
  //     setStatus(Status.loaded);
  //   }
  // }

  Future getGapUpStocks({showProgress = false, loadMore = false}) async {
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
        url: Apis.gapUpStocks,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = gapUpResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.addAll(gapUpResFromJson(jsonEncode(response.data)).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(
          message: res.message,
        );
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }
}
