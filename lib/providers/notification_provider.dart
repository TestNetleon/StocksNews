import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/notification_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class NotificationProvider extends ChangeNotifier with AuthProviderBase {
  NotificationsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
  Status get status => _status;
  NotificationsRes? get data => _data;

  bool get canLoadMore => _page < (_data?.lastPage ?? 0);
  bool get isLoading => _status == Status.loading;
  bool get isSearching => _status == Status.searching;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getData({showProgress = false, loadMore = false}) async {
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
        "page": "$_page",
      };
      ApiResponse response = await apiRequest(
          url: Apis.notifications,
          request: request,
          showProgress: showProgress);

      if (response.status) {
        _error = null;
        // if (_page == 1 && response.data == []) {
        //   _data = null;
        // } else
        if (_page == 1) {
          _data = NotificationsRes.fromJson(response.data);
          if ((_data?.data?.isEmpty ?? false) && isSearching) {
            _error = Const.errNoRecord;
          }
        } else {
          _data?.data
              ?.addAll(NotificationsRes.fromJson(response.data).data ?? []);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
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
        showErrorMessage(message: res.message);
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }
}
