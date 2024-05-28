import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FaqProvide extends ChangeNotifier with AuthProviderBase {
  String? _error;
  Status _status = Status.ideal;
  int _openIndex = -1;
  int get openIndex => _openIndex;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
//
  List<FaQsRes>? _data;
  List<FaQsRes>? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void change(int index) {
    _openIndex = index;
    notifyListeners();
    // if (_data?.isNotEmpty == true && index >= 0 && index < _data!.length) {
    //   for (int i = 0; i < _data!.length; i++) {
    //     if (i != index) {
    //       _data![i].open = false;
    //     }
    //   }
    //   _data![index].open = _data![index].open ? true : !_data![index].open;
    //   notifyListeners();
    // }
  }

  Future onRefresh() async {
    getFAQs();
  }

  Future getFAQs() async {
    setStatus(Status.loading);
    Map request = {
      "token":
          navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.faQs,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );
      if (response.status) {
        _data = faQsResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
