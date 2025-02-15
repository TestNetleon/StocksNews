import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../models/search.dart';
import '../routes/my_app.dart';
import '../utils/constants.dart';
import 'user.dart';

class SearchManager extends ChangeNotifier {
  Status _statusSearch = Status.ideal;
  Status get statusSearch => _statusSearch;

  bool get isLoadingSearch => _statusSearch == Status.loading;

  BaseSearchRes? _searchData;
  BaseSearchRes? get searchData => _searchData;

  String? _errorSearch;
  String? get errorSearch => _errorSearch;

  setStatusSearch(status) {
    _statusSearch = status;
    notifyListeners();
  }

  clearSearchData() {
    _searchData = null;
    _errorSearch = null;
    _errorRecentSearch = null;
    _recentSearchData = null;
    notifyListeners();
  }

  getBaseSearchData({bool searchWithNews = true, required String term}) async {
    setStatusSearch(Status.loading);
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'term': term,
      };

      ApiResponse response = await apiRequest(
        url: searchWithNews ? Apis.searchWithNews : Apis.search,
        request: request,
      );
      if (response.status) {
        if (response.data != null) {
          _searchData = baseSearchResFromJson(jsonEncode(response.data));
        } else {
          _searchData = null;
        }
        _errorSearch = response.message;
      } else {
        _searchData = null;
        _errorSearch = null;
      }
    } catch (e) {
      _searchData = null;
      _errorSearch = Const.errSomethingWrong;
      Utils().showLog(
          '----Error ${searchWithNews ? Apis.searchWithNews : Apis.search}: $e');
    } finally {
      setStatusSearch(Status.loaded);
    }
  }

//MARK: Recent Search Data
  String? _errorRecentSearch;
  String? get errorRecentSearch => _errorRecentSearch;

  Status _statusRecentSearch = Status.ideal;
  Status get statusRecentSearch => _statusRecentSearch;

  bool get isLoadingRecentSearch => _statusRecentSearch == Status.loading;

  BaseSearchRes? _recentSearchData;
  BaseSearchRes? get recentSearchData => _recentSearchData;

  setStatusRecentSearch(status) {
    _statusRecentSearch = status;
    notifyListeners();
  }

  Future getRecentSearchData() async {
    try {
      setStatusRecentSearch(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.recentSearch,
        request: request,
      );
      if (response.status) {
        _recentSearchData = baseSearchResFromJson(jsonEncode(response.data));
        _errorRecentSearch = null;
      } else {
        _recentSearchData = null;
        _errorRecentSearch = response.message;
      }
    } catch (e) {
      _recentSearchData = null;
      _errorRecentSearch = Const.errSomethingWrong;
    } finally {
      setStatusRecentSearch(Status.loaded);
    }
  }
}
