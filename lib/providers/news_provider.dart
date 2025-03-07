// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/news_res.dart';
import 'package:stocks_news_new/modals/stock_header_news.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../modals/news_tab_category_res.dart';

class NewsProvider extends ChangeNotifier {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;
//
  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    getNews();
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
        onRefresh: onRefresh,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = newsResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
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
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

class FeaturedNewsProvider extends ChangeNotifier {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future onRefresh() async {
    _page = 1;
    getNews();
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
        onRefresh: onRefresh,
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
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}

class HeaderNewsProvider extends ChangeNotifier {
  String? _error;
  Status _status = Status.ideal;
  Status get status => _status;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  List<StockHeaderNewsRes>? _data;
  List<StockHeaderNewsRes>? get data => _data;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future onRefresh() async {
    getHeaderNews();
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
        onRefresh: onRefresh,
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
      Utils().showLog(e.toString());
      setStatus(Status.ideal);
    }
  }
}

class NewsCategoryProvider extends ChangeNotifier {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;

  Status _tabStatus = Status.ideal;

  int _page = 1;
  int selectedIndex = 0;

  List<NewsTabsRes>? _tabs;
  List<NewsTabsRes>? get tabs => _tabs;

  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  bool get isLoading => _status == Status.loading;
  bool get tabLoading => _tabStatus == Status.loading;

  Map<String, TabsNewsHolder?> _newsData = {};
  Map<String, TabsNewsHolder?> get newsData => _newsData;

  Extra? _extra;
  Extra? get extra => _extra;
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

  void tabChange(int? index, String? id) {
    if (selectedIndex != index) {
      selectedIndex = index ?? 0;
      notifyListeners();
      if (id == null) return;
      if (_newsData[id]?.data != null || _newsData[id]?.error != null) return;
      getNewsData(id: id);
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
        removeForceLogin: true,
      );
      if (response.status) {
        _tabs = newsCategoryTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getNewsData(id: _tabs?[selectedIndex].id);
        }
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _error = response.message;
        _tabs = null;
      }
      setTabStatus(Status.loaded);
    } catch (e) {
      _error = Const.errSomethingWrong;
      _tabs = null;

      Utils().showLog(e.toString());
      setTabStatus(Status.loaded);
    }
  }

  Future onRefresh() async {
    await getNewsData(id: _tabs?[selectedIndex].id, refreshing: true);
  }

  Future onLoadMore() async {
    await getNewsData(loadMore: true, id: _tabs?[selectedIndex].id);
  }

  Future getNewsData(
      {loadMore = false,
      refreshing = false,
      String? id = "featured-news"}) async {
    if (_newsData[id]?.data == null || refreshing) {
      _newsData[id!] = TabsNewsHolder(
        currentPage: 1,
        data: null,
        error: null,
        loading: true,
      );
    } else {
      _newsData[id!] = TabsNewsHolder(
        currentPage: (_newsData[id]?.currentPage ?? 1) + 1,
        data: _newsData[id]?.data,
        error: _newsData[id]?.error,
        loading: false,
      );
    }
    notifyListeners();

    try {
      Map request = id == "latest-news" || id == "featured-news"
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "${(_newsData[id]?.currentPage ?? 1)}",
            }
          : {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "${(_newsData[id]?.currentPage ?? 1)}",
              "category_id": tabs?[selectedIndex].id,
            };

      ApiResponse response = await apiRequest(
        url: id == "featured-news" ? Apis.featuredNews : Apis.latestNews,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        if (_newsData[id]?.data == null || _newsData[id]?.currentPage == 1) {
          _newsData[id] = TabsNewsHolder(
            currentPage: _newsData[id]?.currentPage ?? 1,
            data: newsResFromJson(jsonEncode(response.data)),
            error: null,
            loading: false,
          );
        } else {
          final newData = _newsData[id]?.data;
          newData!.data.addAll(newsResFromJson(jsonEncode(response.data)).data);

          _newsData[id] = TabsNewsHolder(
            currentPage: _newsData[id]?.currentPage ?? 1,
            data: newData,
            error: null,
            loading: false,
          );
        }
      } else {
        if (_newsData[id]?.data == null || _newsData[id]?.currentPage == 1) {
          _newsData[id] = TabsNewsHolder(
            currentPage: 1,
            data: null,
            error: response.message,
            loading: false,
          );
        }
      }

      // if (tabChangeLoading) {
      //   setTabStatus(Status.loaded);
      // } else {
      setStatus(Status.loaded);
      // }
    } catch (e) {
      // _data = null;
      Utils().showLog(e.toString());
      // if (tabChangeLoading) {
      //   setTabStatus(Status.loaded);
      // } else {
      setStatus(Status.loaded);
      // }
    }
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
      Utils().showLog(e.toString());
      if (tabChangeLoading) {
        setTabStatus(Status.loaded);
      } else {
        setStatus(Status.loaded);
      }
    }
  }
}

class NewsTypeProvider extends ChangeNotifier {
  NewsRes? _data;
  String? _error;
  Status _status = Status.ideal;
  int _page = 1;

  List<NewsData>? get data => _data?.data;
  bool get canLoadMore => _page < (_data?.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;
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
      _data = null;
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
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }
}
