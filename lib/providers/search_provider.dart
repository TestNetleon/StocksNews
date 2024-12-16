import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/search_res.dart';
import 'package:stocks_news_new/modals/top_search_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/search_new.dart';

//
class SearchProvider extends ChangeNotifier {
  List<SearchRes>? _data;
  List<SearchRes>? get data => _data;

  List<TopSearch>? _topSearch;
  List<TopSearch>? get topSearch => _topSearch;

  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  final FocusNode searchFocusNode = FocusNode();

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _statusS = Status.ideal;
  Status get statusS => _statusS;
  bool get isLoadingS => _statusS == Status.loading;

  SearchNewRes? _dataNew;
  SearchNewRes? get dataNew => _dataNew;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusS(status) {
    _statusS = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _statusS = Status.ideal;
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
      ApiResponse response = await apiRequest(
        url: Apis.search,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _data = searchResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _data = null;
        notifyListeners();
      }
      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future searchSymbolsAndNews(request, {showProgress = false}) async {
    setStatusS(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.searchWithNews,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _dataNew = searchNewResFromJson(jsonEncode(response.data));
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _dataNew = null;
      }
      setStatusS(Status.loaded);
      Utils().showLog("STATUS => $_statusS");
    } catch (e) {
      Utils().showLog(e.toString());
      setStatusS(Status.loaded);
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
        _extra = (response.extra is Extra ? response.extra as Extra : null);

        _topSearch = topSearchFromJson(jsonEncode(response.data));
        FocusScope.of(navigatorKey.currentContext!)
            .requestFocus(searchFocusNode);
      } else {
        // _data = null;
        // showErrorMessage(message: response.message);
      }
      setStatus(Status.ideal);
    } catch (e) {
      Utils().showLog(e.toString());
      setStatus(Status.ideal);
    }
  }
}
