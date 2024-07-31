import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/notification_setting_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class NotificationsSettingProvider extends ChangeNotifier {
  bool allOn = true;

  Status _status = Status.ideal;
  Status get status => _status;

  Status _statusUpdate = Status.ideal;
  Status get statusUpdate => _statusUpdate;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isUpdating => _statusUpdate == Status.loading;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  int? _updatingIndex;
  int? get updatingIndex => _updatingIndex;

  List<NotificationSettingRes>? _settings;
  List<NotificationSettingRes>? get settings => _settings;

  // final List<NotificationTurn> data = [
  //   NotificationTurn(
  //     label: "Alerts",
  //     isOn: true,
  //   ),
  //   NotificationTurn(
  //     label: "Watchlist",
  //     isOn: true,
  //   ),
  //   NotificationTurn(
  //     label: "Spike",
  //     isOn: true,
  //   ),
  //   NotificationTurn(
  //     label: "Blog",
  //     isOn: true,
  //   ),
  //   NotificationTurn(
  //     label: "News",
  //     isOn: true,
  //   ),
  //   NotificationTurn(
  //     label: "General Notification",
  //     isOn: true,
  //   ),
  // ];

  void open(int index) {
    // data[index].isOn = !data[index].isOn;
    setUpdatingIndex(index);
    settings?[index].selected = settings?[index].selected == 1 ? 0 : 1;
    notifyListeners();
    _updateAllOnStatus();
  }

  void changeAll() {
    setUpdatingIndex(-1);
    allOn = !allOn;
    for (var notification in settings!) {
      notification.selected = allOn ? 1 : 0;
    }
    notifyListeners();
  }

  void _updateAllOnStatus() {
    allOn = settings!.every((notification) => notification.selected == 1);
    notifyListeners();
  }

  Extra? _extra;
  Extra? get extra => _extra;

  // List<NotificationSettingRes>? _settings;
  // List<NotificationSettingRes>? get settings => _settings;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusUpdate(status) {
    _statusUpdate = status;
    notifyListeners();
  }

  void setUpdatingIndex(index) {
    _updatingIndex = index;
    notifyListeners();
  }

  Future getSettings({showProgress = false}) async {
    setStatus(Status.loading);

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.notificationSettings,
        request: request,
        showProgress: showProgress,
        // onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        _settings = notificationSettingResFromJson(jsonEncode(response.data));
        _updateAllOnStatus();
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _settings = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _settings = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future updateSettings({showProgress = false, slug, value, index}) async {
    setStatusUpdate(Status.loading);

    if (index == -1) {
      changeAll();
    } else {
      open(index);
    }
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "slug": slug,
        "value": "$value"
      };
      // showGlobalProgressDialog();

      ApiResponse response = await apiRequest(
        url: Apis.updateNotificationSettings,
        request: request,
        showProgress: showProgress,
        // onRefresh: onRefresh,
      );
      // closeGlobalProgressDialog();
      if (response.status) {
        // if (index == -1) {
        //   changeAll();
        // } else {
        //   open(index);
        // }
      } else {
        // _settings = null;
        // _error = response.message;
      }
      setStatusUpdate(Status.loaded);
    } catch (e) {
      _settings = null;
      Utils().showLog(e.toString());
      setStatusUpdate(Status.loaded);
    }
  }
}
