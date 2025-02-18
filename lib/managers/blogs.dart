import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../models/news/detail.dart';
import '../models/news/news.dart';
import '../utils/constants.dart';
import 'user.dart';

class BlogsManager extends ChangeNotifier {
  // MARK: Blogs
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  NewsRes? _blogs;
  NewsRes? get blogs => _blogs;

  int _page = 1;
  bool get canLoadMoreStocks => _page <= (_blogs?.totalPages ?? 1);

  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getBlogsData({bool loadMore = false}) async {
    try {
      if (loadMore) {
        _page++;
        setStatus(Status.loadingMore);
      } else {
        _page = 1;
        _error = null;
        _blogs = null;
        setStatus(Status.loading);
      }

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        "page": "$_page",
      };

      ApiResponse response = await apiRequest(
        url: Apis.secureBlogs,
        request: request,
      );

      if (response.status) {
        if (_page == 1) {
          _blogs = newsResFromJson(jsonEncode(response.data));
          _error = null;
        } else {
          _blogs?.data
              ?.addAll(newsResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_page == 1) {
          _blogs = null;
          _error = response.message;
        }
      }
    } catch (e) {
      if (_page == 1) {
        _blogs = null;
        _error = Const.errSomethingWrong;
      }
      if (kDebugMode) {
        print("Error fetching news data: $e");
      }
    } finally {
      setStatus(Status.loaded);
    }
  }

  // MARK: Blogs Detail
  String? _errorDetail;
  String? get errorDetail => _errorDetail ?? Const.errSomethingWrong;

  Status _statusDetail = Status.ideal;
  Status get statusDetail => _statusDetail;

  bool get isLoadingDetail => _statusDetail == Status.loading;

  NewsDetailRes? _blogsDetail;
  NewsDetailRes? get blogsDetail => _blogsDetail;

  void setStatusDetail(status) {
    _statusDetail = status;
    notifyListeners();
  }

  Future<void> getBlogsDetailData(String slug, {reset = true}) async {
    if (reset) {
      _blogsDetail = null;
    }
    try {
      setStatusDetail(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'slug': slug,
      };

      ApiResponse response = await apiRequest(
        url: Apis.secureBlogDetail,
        request: request,
      );

      if (response.status) {
        _blogsDetail = newsDetailResFromJson(jsonEncode(response.data));
        _errorDetail = null;
      } else {
        _blogsDetail = null;
        _errorDetail = response.message;
      }
    } catch (e) {
      _blogsDetail = null;
      _errorDetail = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.newsDetail}: $e');
    } finally {
      setStatusDetail(Status.loaded);
    }
  }

//MARK: Feedback
  Future sendFeedback({
    required String id,
    required String pageType,
    required String type,
  }) async {
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();

      Map request = {
        "token": provider.user?.token ?? "",
        "post_id": id,
        "type": type,
        "page_type": pageType,
      };

      ApiResponse response = await apiRequest(
        url: Apis.sendFeedback,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        _blogsDetail?.feedback?.existMessage = response.message;
      }
      TopSnackbar.show(
        message: response.message ?? '',
        type: response.status ? ToasterEnum.success : ToasterEnum.error,
      );
    } catch (e) {
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    } finally {
      notifyListeners();
    }
  }
}
