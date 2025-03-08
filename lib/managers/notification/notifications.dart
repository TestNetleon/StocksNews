import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/notification_res.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';

class NotificationsManager extends ChangeNotifier{
  NotificationRes? _data;
  NotificationRes? get notificationData=> _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  bool get canLoadMore => _page < (_data?.totalPages ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;



  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    getNotifications();
  }

  Future getNotifications({showProgress = false, loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = {
        "page": "$_page"
      };
      ApiResponse response = await apiRequest(
        url: Apis.notifications,
        request: request,
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        if (_page == 1) {
          if (response.data != null) {
            _data = notificationResFromJson(jsonEncode(response.data));
          } else {
            _data = null;
          }
          _error = response.message;
         // _data = notificationResFromJson(jsonEncode(response.data));
        }
        else {
          _data?.notifications?.addAll(notificationResFromJson(jsonEncode(response.data)).notifications ?? []);
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
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatus(Status.loaded);
    }
  }
}