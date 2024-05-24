import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/modals/top_search_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../modals/search_new.dart';

//
class SearchProvider extends ChangeNotifier with AuthProviderBase {
  List<SearchRes>? _data;
  List<TopSearch>? _topSearch;
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  List<SearchRes>? get data => _data;
  List<TopSearch>? get topSearch => _topSearch;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  final FocusNode searchFocusNode = FocusNode();

  SearchNewRes? _dataNew;
  SearchNewRes? get dataNew => _dataNew;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    _dataNew = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    searchFocusNode.dispose();
  }

  Future searchSymbols(request, {showProgress = false}) async {
    setStatus(Status.loading);
    try {
      // Map request = {
      //   "token": navigatorKey.currentContext!.read<UserProvider>().user?.token??""
      // };
      ApiResponse response = await apiRequest(
        url: Apis.search,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _data = searchResFromJson(jsonEncode(response.data));
      } else {
        _data = null;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future searchSymbolsAndNews(request, {showProgress = false}) async {
    setStatus(Status.loading);
    try {
      // Map request = {
      //   "token": navigatorKey.currentContext!.read<UserProvider>().user?.token??""
      // };
      ApiResponse response = await apiRequest(
        url: Apis.searchWithNews,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchNewResFromJson(jsonEncode(response.data));
      } else {
        _dataNew = null;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.loaded);
    } catch (e) {
      log(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future logoutUser(request) async {
    try {
      ApiResponse res = await apiRequest(
        url: Apis.logout,
        request: request,
        showProgress: true,
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        // showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        // showErrorMessage(
        //   message: res.message,
        // );
      }
    } catch (e) {
      setStatus(Status.loaded);
      // showErrorMessage(
      //   message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      // );
    }
  }

  Future getSearchDefaults() async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? ""
      };

      ApiResponse response = await apiRequest(
        url: Apis.getMostSearch,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _topSearch = topSearchFromJson(jsonEncode(response.data));
        FocusScope.of(navigatorKey.currentContext!)
            .requestFocus(searchFocusNode);
      } else {
        // _data = null;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.ideal);
    } catch (e) {
      log(e.toString());
      setStatus(Status.ideal);
    }
  }
}
