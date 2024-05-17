import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/blog_detail_res.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/providers/auth_provider_base.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

//
class BlogProvider extends ChangeNotifier with AuthProviderBase {
  BlogsRes? _data;

  String? _error;
  Status _status = Status.ideal;

  Status _statusDetail = Status.ideal;

  int _page = 1;
  BlogsRes? blogRes;
  BlogsRes? authorRes;
  BlogsRes? categoryRes;
  BlogsRes? tagsRes;

  List<BlogItemRes>? blogData;
  List<BlogItemRes>? authorsData;
  List<BlogItemRes>? categoryData;
  List<BlogItemRes>? tagsData;

  bool get canLoadMore => _page < (_data?.data.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;
  // int? get page => _page;

  BlogsDetailRes? _blogsDetail;
  BlogsDetailRes? get blogsDetail => _blogsDetail;

  bool get isLoading => _status == Status.loading;
  bool get isLoadingDetail => _statusDetail == Status.loading;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void clearSearch() {
    _status = Status.ideal;
    _data = null;
    notifyListeners();
  }

  Future getData({
    showProgress = false,
    loadMore = false,
    BlogsType type = BlogsType.blog,
    String id = "",
  }) async {
    log("TYPE IS ===> ${type.name}");

    if (loadMore) {
      _page++;
      setStatus(Status.loadingMore);
    } else {
      _page = 1;
      setStatus(Status.loading);
    }
    try {
      Map request = type == BlogsType.tag
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "page": "$_page",
              "tag": id,
            }
          : type == BlogsType.category
              ? {
                  "token": navigatorKey.currentContext!
                          .read<UserProvider>()
                          .user
                          ?.token ??
                      "",
                  "page": "$_page",
                  "category_id": id,
                }
              : type == BlogsType.author
                  ? {
                      "token": navigatorKey.currentContext!
                              .read<UserProvider>()
                              .user
                              ?.token ??
                          "",
                      "page": "$_page",
                      "author_id": id,
                    }
                  : {
                      "token": navigatorKey.currentContext!
                              .read<UserProvider>()
                              .user
                              ?.token ??
                          "",
                      "page": "$_page",
                    };

      ApiResponse response = await apiRequest(
        url: Apis.blogs,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = blogsResFromJson(jsonEncode(response.data));
        } else {
          _data?.data.data
              .addAll(blogsResFromJson(jsonEncode(response.data)).data.data);
        }

        if (type == BlogsType.author) {
          log("data is for author");

          authorRes = _data;
          authorsData = _data?.data.data;
        } else if (type == BlogsType.category) {
          log("data is for category");

          categoryRes = _data;
          categoryData = _data?.data.data;
        } else if (type == BlogsType.tag) {
          log("data is for tag");

          tagsRes = _data;
          tagsData = _data?.data.data;
        } else {
          log("data is for blog");

          blogRes = _data;
          blogData = _data?.data.data;
        }
      } else {
        _data = null;
        _error = response.message;
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
      );
      if (res.status) {
        setStatus(Status.loaded);
        handleSessionOut();
        showErrorMessage(message: res.message, type: SnackbarType.info);
      } else {
        setStatus(Status.loaded);
        showErrorMessage(
          message: res.message,
        );
      }
    } catch (e) {
      setStatus(Status.loaded);
      showErrorMessage(
        message: kDebugMode ? e.toString() : Const.errSomethingWrong,
      );
    }
  }

  Future getBlogDetailData({required String blogId, String? slug}) async {
    // setStatus(Status.loading);
    _statusDetail = Status.loading;
    notifyListeners();
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "blog_id": blogId,
        "slug": slug ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.blogDetails,
        request: request,
        showProgress: false,
      );
      if (response.status) {
        _blogsDetail = BlogsDetailRes.fromJson(response.data);
      } else {
        _blogsDetail = null;
        _error = response.message;
        showErrorMessage(message: response.message);
      }
      // setStatus(Status.loaded);
      _statusDetail = Status.loaded;
      notifyListeners();
    } catch (e) {
      _blogsDetail = null;

      log(e.toString());
      // setStatus(Status.loaded);
      _statusDetail = Status.loaded;
      notifyListeners();
    }
  }
}
