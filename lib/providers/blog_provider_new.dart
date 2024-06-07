import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/blogs/blog_tab_res.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

class BlogProviderNew extends ChangeNotifier {
  BlogsRes? _data;
  String? _error;
  Status _status = Status.ideal;

  Status _tabStatus = Status.ideal;

  final int _page = 1;
  int selectedIndex = 0;

  List<BlogTabRes>? _tabs;
  List<BlogTabRes>? get tabs => _tabs;
  // List<String>? _tabs;
  // List<String>? get tabs => _tabs;

  List<BlogItemRes>? get data => _data?.data.data;
  bool get canLoadMore => _page < (_data?.data.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  bool get isLoading => _status == Status.loading;
  bool get tabLoading => _tabStatus == Status.loading;

  final Map<String, BlogTabHolder?> _blogData = {};
  Map<String, BlogTabHolder?> get blogData => _blogData;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setTabStatus(status) {
    _tabStatus = status;
    notifyListeners();
  }

  void tabChange(index, String? id) {
    if (selectedIndex != index) {
      selectedIndex = index;
      notifyListeners();
      if (id == null) return;
      if (_blogData[id]?.data != null || _blogData[id]?.error != null) return;
      getBlogData(id: id);
    }
  }

  Future getTabsData({showProgress = false}) async {
    _tabs == null;
    selectedIndex = 0;
    setTabStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.blogCategory,
        request: request,
        showProgress: showProgress,
      );
      if (response.status) {
        _tabs = blogTabResFromJson(jsonEncode(response.data));
        if (_tabs != null) {
          getBlogData(id: _tabs?[selectedIndex].id);
        }
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
    await getBlogData(id: _tabs?[selectedIndex].id, refreshing: true);
  }

  Future onLoadMore() async {
    await getBlogData(loadMore: true, id: _tabs?[selectedIndex].id);
  }

  Future getBlogData({
    loadMore = false,
    refreshing = false,
    String? id,
  }) async {
    Utils().showLog("---ID => $id");
    if (_blogData[id]?.data == null || refreshing) {
      _blogData[id!] = BlogTabHolder(
        currentPage: 1,
        data: null,
        error: null,
        loading: true,
      );
    } else {
      _blogData[id!] = BlogTabHolder(
        currentPage: (_blogData[id]?.currentPage ?? 1) + 1,
        data: _blogData[id]?.data,
        error: _blogData[id]?.error,
        loading: false,
      );
    }
    notifyListeners();

    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "page": "${(_blogData[id]?.currentPage ?? 1)}",
        "category_id": id,
      };

      ApiResponse response = await apiRequest(
        url: Apis.blogs,
        request: request,
        showProgress: false,
        onRefresh: onRefresh,
      );

      if (response.status) {
        if (_blogData[id]?.data == null || _blogData[id]?.currentPage == 1) {
          _blogData[id] = BlogTabHolder(
            currentPage: _blogData[id]?.currentPage ?? 1,
            data: blogsResFromJson(jsonEncode(response.data)).data,
            error: null,
            loading: false,
          );
        } else {
          final newData = _blogData[id]?.data;
          newData!.data
              .addAll(blogsResFromJson(jsonEncode(response.data)).data.data);

          _blogData[id] = BlogTabHolder(
            currentPage: _blogData[id]?.currentPage ?? 1,
            data: newData,
            error: null,
            loading: false,
          );
        }
      } else {
        if (_blogData[id]?.data == null || _blogData[id]?.currentPage == 1) {
          _blogData[id] = BlogTabHolder(
            currentPage: 1,
            data: null,
            error: response.message,
            loading: false,
          );
        }
      }

      setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());

      setStatus(Status.loaded);
    }
  }
}

class BlogTabHolder {
  BlogDataRes? data;
  int currentPage;
  String? error;
  bool loading;

  BlogTabHolder({
    this.data,
    this.currentPage = 1,
    this.loading = true,
    this.error,
  });
}
