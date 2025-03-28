import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../models/faq.dart';

class FaqManager extends ChangeNotifier {
  BaseFaqRes? _data;
  BaseFaqRes? get faqData => _data;
  String? _error;
  Status _status = Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  int _openIndex = -1;
  int get openIndex => _openIndex;

  String? _errorSearch;
  String? get errorSearch => _errorSearch;

  void change(int index) {
    _openIndex = index;
    notifyListeners();
  }

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getFaq();
  }

  void clearSearch() {
    _errorSearch = "";
    notifyListeners();
  }

  Future getFaq({String? search, bool? isRest = false}) async {
    clearSearch();
    setStatus(Status.loading);
    try {
      Map request = {"search": search ?? ""};
      ApiResponse response = await apiRequest(
        url: Apis.faqs,
        showProgress: false,
        request: request,
        onRefresh: onRefresh,
      );

      if (response.status) {
        _data = baseFaqResFromJson(jsonEncode(response.data));
        if (isRest == true) {
          _errorSearch = response.message;
        }
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
}
