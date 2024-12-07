import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/terms_policy_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class TermsAndPolicyProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
//
  TermsPolicyRes? _data;
  TermsPolicyRes? get data => _data;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getTermsPolicy({
    required String slug,
  }) async {
    setStatus(Status.loading);
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      "slug": slug,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.infoPage,
        request: request,
      );

      if (response.status) {
        _data = termsPolicyResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        _error = response.message;
      }

      setStatus(Status.loaded);
      return ApiResponse(status: response.status);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;

      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
