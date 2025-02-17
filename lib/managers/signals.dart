import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../api/api_requester.dart';
import '../api/api_response.dart';
import '../api/apis.dart';
import '../models/market/market_res.dart';
import '../models/signals/insiders.dart';
import '../models/signals/politicians.dart';
import '../models/signals/sentiment.dart';
import '../models/signals/stock.dart';
import '../routes/my_app.dart';
import '../utils/constants.dart';
import 'user.dart';

class SignalsManager extends ChangeNotifier {
  //MARK: Signals

  List<MarketResData> tabs = [
    MarketResData(title: 'Stocks'),
    MarketResData(title: 'Sentiment'),
    MarketResData(title: 'Insiders'),
    MarketResData(title: 'Politicians'),
  ];

  int? selectedScreen;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      switch (selectedScreen) {
        case 0:
          getStocksData();
          break;

        case 1:
          getSignalSentimentData();
          break;

        case 2:
          getInsidersData();
          break;

        case 3:
          getPoliticianData();
          break;

        default:
      }
    }
  }

//MARK: Stocks
  String? _errorStocks;
  String? get errorStocks => _errorStocks;

  Status _statusStocks = Status.ideal;
  Status get statusStocks => _statusStocks;

  bool get isLoadingStocks =>
      _statusStocks == Status.loading || _statusStocks == Status.ideal;

  SignalSocksRes? _signalSocksData;
  SignalSocksRes? get signalSocksData => _signalSocksData;

  int _page = 1;
  bool get canLoadMoreStocks => _page <= (_signalSocksData?.totalPages ?? 1);

  setStatusStocks(status) {
    _statusStocks = status;
    notifyListeners();
  }

  Future getStocksData({bool loadMore = false}) async {
    if (loadMore) {
      _page++;
      setStatusStocks(Status.loadingMore);
    } else {
      _page = 1;
      setStatusStocks(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_page',
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalStocks,
        request: request,
      );
      if (response.status) {
        if (_page == 1) {
          _signalSocksData = signalSocksResFromJson(jsonEncode(response.data));
          _errorStocks = null;
        } else {
          _signalSocksData?.data?.addAll(
              signalSocksResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_page == 1) {
          _signalSocksData = null;
          _errorStocks = response.message;
        }
      }
    } catch (e) {
      _signalSocksData = null;
      _errorStocks = Const.errSomethingWrong;
    } finally {
      setStatusStocks(Status.loaded);
    }
  }

//MARK: Sentiment
  String? _errorSentiment;
  String? get errorSentiment => _errorSentiment;

  Status _statusSentiment = Status.ideal;
  Status get statusSentiment => _statusSentiment;

  bool get isLoadingSentiment => _statusSentiment == Status.loading;

  SignalSentimentRes? _signalSentimentData;
  SignalSentimentRes? get signalSentimentData => _signalSentimentData;

  setStatusSentiment(status) {
    _statusSentiment = status;
    notifyListeners();
  }

  Future getSignalSentimentData({
    int dataAll = 1,
    num days = 1,
    bool loadFull = true,
  }) async {
    try {
      if (loadFull) setStatusSentiment(Status.loading);

      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
      };

      request['all_data'] = '$dataAll';
      request['days'] = '$days';

      ApiResponse response = await apiRequest(
        url: Apis.signalSentiment,
        request: request,
        showProgress: !loadFull,
      );
      if (response.status) {
        if (dataAll == 1) {
          _signalSentimentData =
              signalSentimentResFromJson(jsonEncode(response.data));
        } else {
          _signalSentimentData?.mostMentions?.data =
              signalSentimentResFromJson(jsonEncode(response.data))
                  .mostMentions
                  ?.data;
        }

        _errorSentiment = null;
      } else {
        _signalSentimentData = null;
        _errorSentiment = response.message;
      }
    } catch (e) {
      _signalSentimentData = null;
      _errorSentiment = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.signalSentiment}: $e');
    } finally {
      if (loadFull) {
        setStatusSentiment(Status.loaded);
      } else {
        notifyListeners();
      }
    }
  }

  //MARK: Insiders
  String? _errorInsiders;
  String? get errorInsiders => _errorInsiders;

  Status _statusInsiders = Status.ideal;
  Status get statusInsiders => _statusInsiders;

  int _pageInsiders = 1;
  bool get canLoadMoreInsiders =>
      _pageInsiders <= (_signalInsidersData?.totalPages ?? 1);

  bool get isLoadingInsiders =>
      _statusInsiders == Status.loading || _statusInsiders == Status.ideal;

  SignalInsidersRes? _signalInsidersData;
  SignalInsidersRes? get signalInsidersData => _signalInsidersData;

  int _openIndex = -1;
  int get openIndex => _openIndex;

  void openMore(index) {
    _openIndex = index;
    notifyListeners();
  }

  setStatusInsiders(status) {
    _statusInsiders = status;
    notifyListeners();
  }

  Future getInsidersData({bool loadMore = false}) async {
    if (loadMore) {
      _pageInsiders++;
      setStatusInsiders(Status.loadingMore);
    } else {
      _pageInsiders = 1;
      openMore(-1);
      setStatusInsiders(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pageInsiders',
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalInsiders,
        request: request,
      );
      if (response.status) {
        if (_pageInsiders == 1) {
          _signalInsidersData =
              signalInsidersResFromJson(jsonEncode(response.data));
          _errorInsiders = null;
        } else {
          _signalInsidersData?.data?.addAll(
              signalInsidersResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_pageInsiders == 1) {
          _signalInsidersData = null;
          _errorInsiders = response.message;
        }
      }
    } catch (e) {
      _pageInsiders = 1;
      _signalInsidersData = null;
      _errorInsiders = Const.errSomethingWrong;
    } finally {
      setStatusInsiders(Status.loaded);
    }
  }

  //MARK: Insiders: Company

  String? _errorInsidersCompany;
  String? get errorInsidersCompany => _errorInsidersCompany;

  Status _statusInsidersCompany = Status.ideal;
  Status get statusInsidersCompany => _statusInsidersCompany;

  int _pageInsidersCompany = 1;
  bool get canLoadMoreInsidersCompany =>
      _pageInsidersCompany <= (_signalInsidersCompanyData?.totalPages ?? 1);

  bool get isLoadingInsidersCompany =>
      _statusInsidersCompany == Status.loading ||
      _statusInsidersCompany == Status.ideal;

  SignalInsidersRes? _signalInsidersCompanyData;
  SignalInsidersRes? get signalInsidersCompanyData =>
      _signalInsidersCompanyData;

  int _openIndexCompany = -1;
  int get openIndexCompany => _openIndexCompany;

  void openMoreCompany(index) {
    _openIndexCompany = index;
    notifyListeners();
  }

  setStatusInsidersCompany(status) {
    _statusInsidersCompany = status;
    notifyListeners();
  }

  Future getInsidersCompanyData(
      {bool loadMore = false, required String cik}) async {
    if (loadMore) {
      _pageInsidersCompany++;
      setStatusInsidersCompany(Status.loadingMore);
    } else {
      _pageInsidersCompany = 1;
      openMoreCompany(-1);
      setStatusInsidersCompany(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pageInsidersCompany',
        'companyCik': cik,
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalInsiders,
        request: request,
      );
      if (response.status) {
        if (_pageInsidersCompany == 1) {
          _signalInsidersCompanyData =
              signalInsidersResFromJson(jsonEncode(response.data));
          _errorInsidersCompany = null;
        } else {
          _signalInsidersCompanyData?.data?.addAll(
              signalInsidersResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_pageInsidersCompany == 1) {
          _signalInsidersCompanyData = null;
          _errorInsidersCompany = response.message;
        }
      }
    } catch (e) {
      _pageInsidersCompany = 1;
      _signalInsidersCompanyData = null;
      _errorInsidersCompany = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalInsiders}: $e');
    } finally {
      setStatusInsidersCompany(Status.loaded);
    }
  }

  //MARK: Insiders: Reporting

  String? _errorInsidersReporting;
  String? get errorInsidersReporting => _errorInsidersReporting;

  Status _statusInsidersReporting = Status.ideal;
  Status get statusInsidersReporting => _statusInsidersReporting;

  int _pageInsidersReporting = 1;
  bool get canLoadMoreInsidersReporting =>
      _pageInsidersReporting <= (_signalInsidersReportingData?.totalPages ?? 1);

  bool get isLoadingInsidersReporting =>
      _statusInsidersReporting == Status.loading ||
      _statusInsidersReporting == Status.ideal;

  SignalInsidersRes? _signalInsidersReportingData;
  SignalInsidersRes? get signalInsidersReportingData =>
      _signalInsidersReportingData;

  int _openIndexReporting = -1;
  int get openIndexReporting => _openIndexReporting;

  void openMoreReporting(index) {
    _openIndexReporting = index;
    notifyListeners();
  }

  setStatusInsidersReporting(status) {
    _statusInsidersReporting = status;
    notifyListeners();
  }

  Future getInsidersReportingData(
      {bool loadMore = false, required String cik}) async {
    if (loadMore) {
      _pageInsidersReporting++;
      setStatusInsidersReporting(Status.loadingMore);
    } else {
      _pageInsidersReporting = 1;
      openMoreReporting(-1);
      setStatusInsidersReporting(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pageInsidersReporting',
        'reportingCik': cik,
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalInsiders,
        request: request,
      );
      if (response.status) {
        if (_pageInsidersReporting == 1) {
          _signalInsidersReportingData =
              signalInsidersResFromJson(jsonEncode(response.data));
          _errorInsidersReporting = null;
        } else {
          _signalInsidersReportingData?.data?.addAll(
              signalInsidersResFromJson(jsonEncode(response.data)).data ?? []);
        }
      } else {
        if (_pageInsidersReporting == 1) {
          _signalInsidersReportingData = null;
          _errorInsidersReporting = response.message;
        }
      }
    } catch (e) {
      _pageInsidersReporting = 1;
      _signalInsidersReportingData = null;
      _errorInsidersReporting = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalInsiders}: $e');
    } finally {
      setStatusInsidersReporting(Status.loaded);
    }
  }

  //MARK: Politicians

  String? _errorPolitician;
  String? get errorPolitician => _errorPolitician;

  Status _statusPolitician = Status.ideal;
  Status get statusPolitician => _statusPolitician;

  int _pagePolitician = 1;
  bool get canLoadMorePolitician =>
      _pagePolitician <= (_signalPoliticianData?.totalPages ?? 1);

  bool get isLoadingPolitician =>
      _statusPolitician == Status.loading || _statusPolitician == Status.ideal;

  SignalPoliticiansRes? _signalPoliticianData;
  SignalPoliticiansRes? get signalPoliticianData => _signalPoliticianData;

  setStatusPolitician(status) {
    _statusPolitician = status;
    notifyListeners();
  }

  int _openIndexPolitician = -1;
  int get openIndexPolitician => _openIndexPolitician;

  void openMorePolitician(index) {
    _openIndexPolitician = index;
    notifyListeners();
  }

  Future getPoliticianData({bool loadMore = false}) async {
    if (loadMore) {
      _pagePolitician++;
      setStatusPolitician(Status.loadingMore);
    } else {
      _pagePolitician = 1;
      openMorePolitician(-1);

      setStatusPolitician(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pagePolitician',
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalPoliticians,
        request: request,
      );
      if (response.status) {
        if (_pagePolitician == 1) {
          _signalPoliticianData =
              signalPoliticiansResFromJson(jsonEncode(response.data));
          _errorPolitician = null;
        } else {
          _signalPoliticianData?.data?.addAll(
              signalPoliticiansResFromJson(jsonEncode(response.data)).data ??
                  []);
        }
      } else {
        if (_pagePolitician == 1) {
          _signalPoliticianData = null;
          _errorPolitician = response.message;
        }
      }
    } catch (e) {
      _pagePolitician = 1;
      _signalPoliticianData = null;
      _errorPolitician = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalPoliticians}: $e');
    } finally {
      setStatusPolitician(Status.loaded);
    }
  }

  //MARK: Politicians: Detail

  String? _errorPoliticianDetail;
  String? get errorPoliticianDetail => _errorPoliticianDetail;

  Status _statusPoliticianDetail = Status.ideal;
  Status get statusPoliticianDetail => _statusPoliticianDetail;

  int _pagePoliticianDetail = 1;
  bool get canLoadMorePoliticianDetail =>
      _pagePoliticianDetail <= (_signalPoliticianDetailData?.totalPages ?? 1);

  bool get isLoadingPoliticianDetail =>
      _statusPoliticianDetail == Status.loading ||
      _statusPoliticianDetail == Status.ideal;

  SignalPoliticiansRes? _signalPoliticianDetailData;
  SignalPoliticiansRes? get signalPoliticianDetailData =>
      _signalPoliticianDetailData;

  setStatusPoliticianDetail(status) {
    _statusPoliticianDetail = status;
    notifyListeners();
  }

  int _openIndexPoliticianDetail = -1;
  int get openIndexPoliticianDetail => _openIndexPoliticianDetail;

  void openMorePoliticianDetail(index) {
    _openIndexPoliticianDetail = index;
    notifyListeners();
  }

  Future getPoliticianDetailData({
    bool loadMore = false,
    required String userSlug,
  }) async {
    if (loadMore) {
      _pagePoliticianDetail++;
      setStatusPoliticianDetail(Status.loadingMore);
    } else {
      _pagePoliticianDetail = 1;
      openMorePoliticianDetail(-1);
      setStatusPoliticianDetail(Status.loading);
    }
    try {
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'page': '$_pagePoliticianDetail',
        'user_slug': userSlug,
      };

      ApiResponse response = await apiRequest(
        url: Apis.signalPoliticians,
        request: request,
      );
      if (response.status) {
        if (_pagePoliticianDetail == 1) {
          _signalPoliticianDetailData =
              signalPoliticiansResFromJson(jsonEncode(response.data));
          _errorPoliticianDetail = null;
        } else {
          _signalPoliticianDetailData?.data?.addAll(
              signalPoliticiansResFromJson(jsonEncode(response.data)).data ??
                  []);
        }
      } else {
        if (_pagePoliticianDetail == 1) {
          _signalPoliticianDetailData = null;
          _errorPoliticianDetail = response.message;
        }
      }
    } catch (e) {
      _pagePoliticianDetail = 1;
      _signalPoliticianDetailData = null;
      _errorPoliticianDetail = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.signalPoliticians}: $e');
    } finally {
      setStatusPoliticianDetail(Status.loaded);
    }
  }
}
