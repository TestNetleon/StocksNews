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
  int _openIndex = -1;
  int? get openIndex => _openIndex;

  // ************* GAP Up **************** //
  Status _statusUp = Status.ideal;
  List<GapUpRes>? _dataUp;
  String? _errorUp;
  int _pageUp = 1;
  Extra? _extraUp;

  List<GapUpRes>? get dataUp => _dataUp;
  Extra? get extraUp => _extraUp;
  bool get canLoadMoreUp => _pageUp < (_extraUp?.totalPages ?? 1);
  String? get errorUp => _errorUp ?? Const.errSomethingWrong;
  bool get isLoadingUp => _statusUp == Status.loading;

  // ************* GAP DOWN **************** //
  Status _statusDown = Status.ideal;
  List<GapUpRes>? _dataDown;
  String? _errorDown;
  int _pageDown = 1;
  // int? _totalPageDown;
  Extra? _extraDown;

  List<GapUpRes>? get dataDown => _dataDown;
  bool get canLoadMoreDown => _pageDown < (_extraDown?.totalPages ?? 1);
  String? get errorDown => _errorDown ?? Const.errSomethingWrong;
  bool get isLoadingDown => _statusDown == Status.loading;

  void setStatus(status) {
    _statusUp = status;
    _statusDown = status;
    notifyListeners();
  }

  void setStatusUp(status) {
    _statusUp = status;
    notifyListeners();
  }

  void setStatusDown(status) {
    _statusDown = status;
    notifyListeners();
  }

  void setOpenIndex(index) {
    _openIndex = index;
    notifyListeners();
  }

  Future getGapUpStocks({loadMore = false}) async {
    if (loadMore) {
      _pageUp++;
      setStatusUp(Status.loadingMore);
    } else {
      _pageUp = 1;
      setStatusUp(Status.loading);
    }
    _openIndex = -1;
    // _extraDown = null;
    // _extraUp = null;

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_pageUp"
      };

      ApiResponse response = await apiRequest(
        url: Apis.gapUpStocks,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _errorUp = null;
        if (_pageUp == 1) {
          _dataUp = gapUpResFromJson(jsonEncode(response.data));
          _extraUp = response.extra is Extra ? response.extra : null;
        } else {
          _dataUp?.addAll(gapUpResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_pageUp == 1) {
          _dataUp = null;
          _errorUp = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatusUp(Status.loaded);
    } catch (e) {
      _dataUp = null;
      log(e.toString());
      setStatusUp(Status.loaded);
    }
  }

  Future getGapDownStocks({loadMore = false}) async {
    if (loadMore) {
      _pageDown++;
      setStatusDown(Status.loadingMore);
    } else {
      _pageDown = 1;
      setStatusDown(Status.loading);
    }
    _openIndex = -1;
    // _extraUp = null;
    // _extraDown = null;
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "$_pageDown"
      };

      ApiResponse response = await apiRequest(
        url: Apis.gapDownStocks,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _errorDown = null;
        if (_pageDown == 1) {
          _dataDown = gapUpResFromJson(jsonEncode(response.data));
          _extraDown = response.extra is Extra ? response.extra : null;
        } else {
          _dataDown?.addAll(gapUpResFromJson(jsonEncode(response.data)));
        }
      } else {
        if (_pageDown == 1) {
          _dataDown = null;
          _errorDown = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatusDown(Status.loaded);
    } catch (e) {
      _dataDown = null;
      log(e.toString());
      setStatusDown(Status.loaded);
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
