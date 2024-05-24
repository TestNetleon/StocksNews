import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/news_res.dart';
import 'package:stocks_news_new/modals/stock_header_news.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../modals/news_tab_category_res.dart';

class NewsProvider extends ChangeNotifier with AuthProviderBase {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future getNews({
    showProgress = false,
    loadMore = false,
  }) async {
    // navigatorKey.currentContext!.read<HeaderNewsProvider>().getHeaderNews();

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
        "page": "$_page"
      };

      ApiResponse response = await apiRequest(
        url: Apis.latestNews,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = newsResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.addAll(newsResFromJson(jsonEncode(response.data)).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
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
}

class FeaturedNewsProvider extends ChangeNotifier with AuthProviderBase {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future getNews({showProgress = false, loadMore = false, inAppMsgId}) async {
    // navigatorKey.currentContext!.read<HeaderNewsProvider>().getHeaderNews();

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
        "page": "$_page"
      };
      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId});
      }

      ApiResponse response = await apiRequest(
        url: Apis.featuredNews,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = newsResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.addAll(newsResFromJson(jsonEncode(response.data)).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
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
}

class HeaderNewsProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading;
  String? get error => _error ?? Const.errSomethingWrong;
  List<StockHeaderNewsRes>? _data;
  List<StockHeaderNewsRes>? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getHeaderNews({showProgress = false}) async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.marketTickers,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        //
        _data = stockHeaderNewsResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        //
        _data = null;
        _error = response.message;
      }

      setStatus(Status.ideal);
    } catch (e) {
      _data = null;
      _error = null;
      log(e.toString());
      setStatus(Status.ideal);
    }
  }
}

class NewsCategoryProvider extends ChangeNotifier with AuthProviderBase {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;

  Status _tabStatus = Status.ideal;

  int _page = 1;
  int selectedIndex = 0;

  List<NesCategoryTabRes>? _tabs;
  List<NesCategoryTabRes>? get tabs => _tabs;

  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading;

  bool get tabLoading => _tabStatus == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  void tabChange(index) {
    // log("Before--> selected index $selectedIndex, index $index ");
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
      String? id = _tabs?[index].id;
      _page = 1;
      _data = null;
      getNews(tabChangeLoading: false, id: id, showProgress: false);
    }
  }

  Future getTabsData({showProgress = false}) async {
    _tabs == null;
    setTabStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.newsTab,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _tabs = nesCategoryTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getNews(id: _tabs?[selectedIndex].id);
        }
      } else {
        _error = response.message;
        _tabs = null;
        // showErrorMessage(message: response.message);
      }
      setTabStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      _tabs = null;

      log(e.toString());
      setTabStatus(Status.loaded);
    }
  }

  void onRefresh() {
    getNews(
      tabChangeLoading: false,
      id: _tabs?[selectedIndex].id,
      showProgress: false,
    );
  }

  Future onLoadMore() async {
    await getNews(loadMore: true, id: _tabs?[selectedIndex].id);
  }

  Future getNews({
    showProgress = false,
    loadMore = false,
    tabChangeLoading = false,
    String? id,
  }) async {
    if (tabChangeLoading) {
      _page = 1;
      setTabStatus(Status.loading);
    } else if (loadMore) {
      _page++;
      setTabStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    log("Refreshing Index $selectedIndex");
    try {
      Map request = id == "latest-news" || id == "featured-news"
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_page",
            }
          : {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_page",
              "category_id": tabs?[selectedIndex].id,
            };

      ApiResponse response = await apiRequest(
        url: id == "featured-news" ? Apis.featuredNews : Apis.latestNews,
        request: request,
        showProgress: false,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = newsResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.addAll(newsResFromJson(jsonEncode(response.data)).data);
        }
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      if (tabChangeLoading) {
        setTabStatus(Status.loaded);
      } else {
        setStatus(Status.loaded);
      }
    } catch (e) {
      _data = null;
      log(e.toString());
      if (tabChangeLoading) {
        setTabStatus(Status.loaded);
      } else {
        setStatus(Status.loaded);
      }
    }
  }
}

class NewsTypeProvider extends ChangeNotifier with AuthProviderBase {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future getNewsTypeData({
    showProgress = false,
    loadMore = false,
    required BlogsType type,
    String? id,
  }) async {
    // navigatorKey.currentContext!.read<HeaderNewsProvider>().getHeaderNews();
    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = type == BlogsType.author
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_page",
              "author_id": id ?? "",
            }
          : type == BlogsType.category
              ? {
                  "token": navigatorKey.currentContext!
                          .read<UserProvider>()
                          .user
                          ?.token ??
                      "",
                  "page": "$_page",
                  "category_id": id ?? "",
                }
              : {
                  "token": navigatorKey.currentContext!
                          .read<UserProvider>()
                          .user
                          ?.token ??
                      "",
                  "page": "$_page",
                  "tag": id ?? "",
                };

      ApiResponse response = await apiRequest(
        url: Apis.latestNews,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = newsResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.addAll(newsResFromJson(jsonEncode(response.data)).data);
        }

        log("in provider  ${_data?.data.length}");
      } else {
        if (_page == 1) {
          _data = null;
          _error = response.message;
          // showErrorMessage(message: response.message);
        }
      }
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
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
}
