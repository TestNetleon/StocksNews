import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class ContactUsProvider extends ChangeNotifier with AuthProviderBase {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future contactUS({
    required TextEditingController name,
    required TextEditingController email,
    required TextEditingController message,
  }) async {
    setStatus(Status.loading);
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "name": name.text,
      "email": email.text,
      "message": message.text,
    };
    try {
      ApiResponse response =
          await apiRequest(url: Apis.contactUs, request: request);
      showErrorMessage(
        message: response.message,
        type: response.status ? SnackbarType.info : SnackbarType.error,
      );
      if (response.status) {
        name.clear();
        email.clear();
        message.clear();
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }
}
