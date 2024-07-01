import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/news_datail_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class NewsDetailProvider extends ChangeNotifier with AuthProviderBase {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
//
  NewsDetailDataRes? _data;
  NewsDetailDataRes? get data => _data;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getNewsDetailData({
    showProgress = false,
    String? slug,
    inAppMsgId,
    notificationId,
    pointsDeducted,
  }) async {
    setStatus(Status.loading);
    try {
      Map request = pointsDeducted != null
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "slug": slug ?? "",
              "point_deduction": "$pointsDeducted",
            }
          : {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "slug": slug ?? "",
            };
      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId!});
      }
      if (notificationId != null) {
        request.addAll({"notification_id": notificationId!});
      }
      ApiResponse response = await apiRequest(
        url: Apis.newsDetails,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _data = newsDetailDataResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future requestFeedbackSubmit({
    showProgress = true,
    required id,
    required type,
    required feedbackType,
  }) async {
    // setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "post_id": id,
        "type": type,
        "feedback_type": feedbackType,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sendFeedback,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _data?.feedbackExistMsg = response.message;
        notifyListeners();
      } else {
        popUpAlert(
          title: "Alert",
          message: response.message ?? Const.errSomethingWrong,
        );
      }
      // setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
        title: "Alert",
        message: Const.errSomethingWrong,
      );
      // setStatus(Status.loaded);
    }
  }
}
