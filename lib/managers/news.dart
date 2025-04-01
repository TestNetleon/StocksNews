import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../models/lock.dart';
import '../models/news/detail.dart';
import '../models/news/news.dart';
import '../utils/constants.dart';
import 'user.dart';

class NewsManager extends ChangeNotifier {
  //MARK: Clear Data
  void clearAllData() {
    //clear category data
    _categoriesData = null;
    //clear news data
    _newsData = {};
    //clear news detail data
    _newsDetail = null;
    //clear lock info
    _lockInformation = null;
    notifyListeners();
  }

  // MARK: News Categories
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading;

  MarketRes? _categoriesData;
  MarketRes? get categoriesData => _categoriesData;

  int selectedIndex = -1;
  setSelectedIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  void onChangeTab(int index) {
    try {
      if (selectedIndex != index) {
        selectedIndex = index;
        notifyListeners();
        String id = _categoriesData?.data?[index].slug ?? '';

        if (kDebugMode) {
          print('Selected Category ID: $id');
        }
        if (id.isEmpty) return;
        if (_newsData[id]?.data != null || _newsData[id]?.error != null) return;
        getNewsData(id: id);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error on changing tab: $e');
      }
    }
  }

  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getNewsCategoriesData() async {
    selectedIndex = -1;
    notifyListeners();

    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      ApiResponse response = await apiRequest(
        url: Apis.newsCategories,
        request: request,
      );

      if (response.status) {
        _categoriesData = marketResFromJson(jsonEncode(response.data));
        _error = null;
        onChangeTab(0);
      } else {
        _categoriesData = null;
        _error = response.message;
      }
    } catch (e) {
      _categoriesData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.newsCategories}: $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

  // MARK: News
  Map<String, HoldingNews?> _newsData = {};
  Map<String, HoldingNews?> get newsData => _newsData;

  Future onRefresh() async {
    String id = _categoriesData?.data?[selectedIndex].slug ?? '';
    await getNewsData(id: id);
  }

  Future onLoadMore() async {
    String id = _categoriesData?.data?[selectedIndex].slug ?? '';

    await getNewsData(loadMore: true, id: id);
  }

  Future<void> getNewsData({bool loadMore = false, required String id}) async {
    try {
      if (loadMore) {
        _newsData[id] = HoldingNews(
          currentPage: (_newsData[id]?.currentPage ?? 1) + 1,
          data: _newsData[id]?.data,
          error: _newsData[id]?.error,
          loading: false,
        );
      } else {
        _newsData[id] = HoldingNews(
          currentPage: 1,
          data: null,
          error: null,
          loading: true,
        );
      }
      notifyListeners();

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'category_id': '${categoriesData?.data?[selectedIndex].slug}',
        "page": "${(_newsData[id]?.currentPage ?? 1)}",
      };

      ApiResponse response = await apiRequest(
        url: Apis.news,
        request: request,
      );

      if (response.status) {
        var parsedData = newsResFromJson(jsonEncode(response.data));

        if (_newsData[id]?.data == null || _newsData[id]?.currentPage == 1) {
          _newsData[id] = HoldingNews(
            currentPage: _newsData[id]?.currentPage ?? 1,
            data: parsedData,
            error: null,
            loading: false,
          );
        } else {
          NewsRes? newData = _newsData[id]?.data;
          if (newData != null) {
            newData.data?.addAll(parsedData.data ?? []);
            _newsData[id] = HoldingNews(
              currentPage: _newsData[id]?.currentPage ?? 1,
              data: newData,
              error: null,
              loading: false,
            );
          }
        }
      } else {
        _newsData[id] = HoldingNews(
          currentPage: 1,
          data: null,
          error: response.message,
          loading: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching news data: $e");
      }
      _newsData[id] = HoldingNews(
        currentPage: 1,
        data: null,
        error: Const.errSomethingWrong,
        loading: false,
      );
    } finally {
      notifyListeners();
    }
  }

  // MARK: News Detail
  String? _errorDetail;
  String? get errorDetail => _errorDetail ?? Const.errSomethingWrong;

  Status _statusDetail = Status.ideal;
  Status get statusDetail => _statusDetail;

  bool get isLoadingDetail => _statusDetail == Status.loading;

  NewsDetailRes? _newsDetail;
  NewsDetailRes? get newsDetail => _newsDetail;

  int _limitCall = 0;
  int get limitCall => _limitCall;

  void clearLimitCall() {
    _limitCall = 0;
    notifyListeners();
  }

  void setStatusDetail(status) {
    _statusDetail = status;
    notifyListeners();
  }

  BaseLockInfoRes? _lockInformation;
  BaseLockInfoRes? get lockInformation => _lockInformation;

  BaseLockInfoRes? getLockINFO() {
    BaseLockInfoRes? info = _lockInformation;
    return info;
  }

  Future<void> getNewsDetailData(
    String slug, {
    reset = true,
    bool pointsDeducted = false,
    showProgress = false,
  }) async {
    setStatusDetail(Status.loading);

    if (reset) {
      _newsDetail = null;
      clearLimitCall();
    }

    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'slug': slug,
        // 'point_deduction': '$pointsDeducted',
      };

      if (pointsDeducted) {
        request['point_deduction'] = 'true';
      }
      ApiResponse response = await apiRequest(
        url: Apis.newsDetail,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _newsDetail = newsDetailResFromJson(jsonEncode(response.data));
        _errorDetail = null;
        _lockInformation = _newsDetail?.lockInfo;
        BrazeService.eventContentView(screenType: 'article', source: slug);
        setStatusDetail(Status.loaded);
      } else {
        _limitCall++;
        setStatusDetail(Status.loading);

        if (_limitCall < 4) {
          await Future.delayed(Duration(milliseconds: 100));
          getNewsDetailData(slug, reset: false);
        } else {
          _newsDetail = null;
          _errorDetail = response.message;
          setStatusDetail(Status.loaded);
        }
      }
    } catch (e) {
      _limitCall++;
      setStatusDetail(Status.loading);

      if (_limitCall < 4) {
        await Future.delayed(Duration(milliseconds: 100));
        getNewsDetailData(slug, reset: false);
      } else {
        _newsDetail = null;
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
        _newsDetail?.feedback?.existMessage = response.message;
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
    }
  }
}

class HoldingNews {
  NewsRes? data;
  int currentPage;
  String? error;
  bool loading;

  HoldingNews({
    this.data,
    this.currentPage = 1,
    this.loading = true,
    this.error,
  });
}
