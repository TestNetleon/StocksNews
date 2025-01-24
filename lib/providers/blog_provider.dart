import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/blog_detail_res.dart';
import 'package:stocks_news_new/modals/blogs_res.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

import '../service/braze/service.dart';

//
class BlogProvider extends ChangeNotifier {
  BlogsRes? _data;

  String? _error;
  Status _status = Status.ideal;

  Status _statusDetail = Status.ideal;

  int _page = 1;
  BlogsRes? blogRes;
  BlogsRes? authorRes;

  List<BlogItemRes>? blogData;
  List<BlogItemRes>? authorsData;

  bool get canLoadMore => _page < (_data?.data.lastPage ?? 1);
  String? get error => _error ?? Const.errSomethingWrong;

  BlogsDetailRes? _blogsDetail;
  BlogsDetailRes? get blogsDetail => _blogsDetail;

  Extra? _extra;
  Extra? get extra => _extra;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;
  bool get isLoadingDetail =>
      _statusDetail == Status.loading || _statusDetail == Status.ideal;

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
    inAppMsgId,
    notificationId,
  }) async {
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

      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId!});
      }
      if (notificationId != null) {
        request.addAll({"notification_id": notificationId!});
      }

      ApiResponse response = await apiRequest(
        url: Apis.blogs,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        if (_page == 1) {
          _data = blogsResFromJson(jsonEncode(response.data));
          _extra = (response.extra is Extra ? response.extra as Extra : null);
        } else {
          _data?.data.data
              .addAll(blogsResFromJson(jsonEncode(response.data)).data.data);
        }

        if (type == BlogsType.author) {
          authorRes = _data;
          authorsData = _data?.data.data;
        }

        //  else if (type == BlogsType.category) {
        //   categoryRes = _data;
        //   categoryData = _data?.data.data;
        // } else if (type == BlogsType.tag) {
        //   tagsRes = _data;
        //   tagsData = _data?.data.data;
        // }

        else {
          blogRes = _data;
          blogData = _data?.data.data;
        }
      } else {
        blogRes = null;
        blogData = null;
        _data = null;
        authorRes = null;
        authorsData = null;
        _error = response.message;
      }
      _extra = (response.extra is Extra ? response.extra as Extra : null);
      setStatus(Status.loaded);
    } catch (e) {
      _data = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  Future getBlogDetailData({
    String? slug,
    inAppMsgId,
    notificationId,
    pointsDeducted,
  }) async {
    _statusDetail = Status.loading;
    notifyListeners();
    try {
      Map request = pointsDeducted != null
          ? {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              // "blog_id": blogId,
              "slug": slug ?? "",
              "point_deduction": "$pointsDeducted",
            }
          : {
              "token": navigatorKey.currentContext!
                      .read<UserProvider>()
                      .user
                      ?.token ??
                  "",
              "slug": slug ?? "",
            };

      if (inAppMsgId != null) {
        request.addAll({"in_app_id": inAppMsgId!});
      }

      ApiResponse response = await apiRequest(
        url: Apis.blogDetails,
        request: request,
        showProgress: false,
        updateDatabase: true,
      );
      if (response.status) {
        _blogsDetail = BlogsDetailRes.fromJson(response.data);
        _extra = (response.extra is Extra ? response.extra as Extra : null);
        Preference.saveReferInput(_extra?.affiliateInput == 1);
        BrazeService.eventContentView(
          screenType: 'article',
          source: _blogsDetail?.slug ?? '',
        );
      } else {
        _blogsDetail = null;
        _error = response.message;
        // showErrorMessage(message: response.message);
      }
      // setStatus(Status.loaded);
      _statusDetail = Status.loaded;
      notifyListeners();
    } catch (e) {
      _blogsDetail = null;

      Utils().showLog('error there $e');
      // setStatus(Status.loaded);
      _statusDetail = Status.loading;
      notifyListeners();
    }
  }

  Future requestFeedbackSubmit({
    showProgress = true,
    required id,
    required type,
    required feedbackType,
  }) async {
    // setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
        "post_id": id,
        "type": type,
        "feedback_type": feedbackType,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sendFeedback,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _blogsDetail?.feedbackExistMsg = response.message;
        notifyListeners();
      } else {
        popUpAlert(
          title: "Alert",
          message: response.message ?? Const.errSomethingWrong,
        );
      }
      // setStatus(Status.loaded);
    } catch (e) {
      Utils().showLog(e.toString());
      popUpAlert(
        title: "Alert",
        message: Const.errSomethingWrong,
      );
      // setStatus(Status.loaded);
    }
  }
}
