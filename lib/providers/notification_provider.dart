import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/notification_res.dart';
import 'package:stocks_news_new/modals/notification_setting_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
  Status get status => _status;
  NotificationsRes? get data => _data;
//
  bool get canLoadMore => _page < (_data?.lastPage ?? 0);
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isSearching => _status == Status.searching;
  String? get error => _error ?? Const.errSomethingWrong;

  Extra? _extra;
  Extra? get extra => _extra;

  List<NotificationSettingRes>? _settings;
  List<NotificationSettingRes>? get settings => _settings;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getData();
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
        showProgress: showProgress,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        // if (_page == 1 && response.data == []) {
        //   _data = null;
        // } else
        if (_page == 1) {
          _data = NotificationsRes.fromJson(response.data);
          _extra = (response.extra is Extra ? response.extra as Extra : null);
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

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
