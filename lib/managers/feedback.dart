import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/feedback_send_res.dart';
import 'package:stocks_news_new/models/news/detail.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';

class FeedbackManager extends ChangeNotifier {
  FeedbackRes? _data;
  FeedbackRes? get feedbackData => _data;

  FeedbackSendRes? _dataSend;
  FeedbackSendRes? get dataSend => _dataSend;

  Status _status = Status.ideal;
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getFeedback() async {
    setStatus(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.feedback,
        request: request,
      );

      if (response.status) {
        _data = feedbackResFromMap(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
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

  Future sendFeedback({String? type, String? comment}) async {
    //setStatus(Status.loading);
    try {
      Map request = {
        "type": type,
        "comment": comment,
      };

      ApiResponse response = await apiRequest(
        url: Apis.shareFeedback,
        request: request,
        showProgress: true,
      );

      if (response.status) {
        _dataSend = feedbackSendResFromMap(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
      }
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
      return response.status;
      // setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      return false;
      // setStatus(Status.loaded);
    }
  }
}
