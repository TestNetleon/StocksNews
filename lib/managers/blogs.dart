import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/lock.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../models/news/detail.dart';
import '../models/news/news.dart';
import '../utils/constants.dart';
import 'user.dart';

class BlogsManager extends ChangeNotifier {
  //MARK: Clear Data
  void clearAllData() {
    //clear blogs data
    _blogs = null;
    //clear blog detail data
    _blogsDetail = null;
    _lockInformation = null;
    notifyListeners();
  }

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

//setting up lock for common lock
  BaseLockInfoRes? _lockInformation;
  BaseLockInfoRes? get lockInformation => _lockInformation;

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _lockInformation;
    return info;
  }

  int _limitCall = 0;
  int get limitCall => _limitCall;

  void clearLimitCall() {
    _limitCall = 0;
    notifyListeners();
  }

  Future<void> getBlogsDetailData(
    String slug, {
    reset = true,
    bool pointsDeducted = false,
    showProgress = false,
  }) async {
    if (reset) {
      _blogsDetail = null;
      clearLimitCall();
    }
    try {
      setStatusDetail(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'slug': slug,
      };

      if (pointsDeducted) {
        request['point_deduction'] = 'true';
      }

      ApiResponse response = await apiRequest(
        url: Apis.secureBlogDetail,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _blogsDetail = newsDetailResFromJson(jsonEncode(response.data));
        _errorDetail = null;
        _lockInformation = _blogsDetail?.lockInfo;
        BrazeService.eventContentView(screenType: 'article', source: slug);

        setStatusDetail(Status.loaded);
      } else {
        _limitCall++;
        setStatusDetail(Status.loading);

        if (_limitCall < 4) {
          await Future.delayed(Duration(milliseconds: 100));
          getBlogsDetailData(slug, reset: false);
        } else {
          _blogsDetail = null;
          _errorDetail = response.message;
          setStatusDetail(Status.loaded);
        }
      }
    } catch (e) {
      _limitCall++;
      setStatusDetail(Status.loading);

      if (_limitCall < 4) {
        await Future.delayed(Duration(milliseconds: 100));
        getBlogsDetailData(slug, reset: false);
      } else {
        _blogsDetail = null;
        _errorDetail = Const.errSomethingWrong;
        setStatusDetail(Status.loaded);
      }

      Utils().showLog('Error in ${Apis.newsDetail}: $e');
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
        notifyListeners();
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
