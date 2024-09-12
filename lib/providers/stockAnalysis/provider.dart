import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/route/my_app.dart';
import '../../api/api_response.dart';
import '../../modals/msAnalysis/ms_top_res.dart';
import '../../modals/msAnalysis/other_stocks.dart';
import '../../modals/msAnalysis/price_volatility.dart';
import '../../modals/msAnalysis/radar_chart.dart';
import '../../modals/msAnalysis/stock_highlights.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../user_provider.dart';

enum MsProviderKeys {
  performance,
  fundamentals,
  priceVolume,
  financials,
  shareHoldings
}

class MSAnalysisProvider extends ChangeNotifier {
  final Map<MsProviderKeys, bool> _states = {
    MsProviderKeys.performance: true,
    MsProviderKeys.fundamentals: true,
    MsProviderKeys.priceVolume: true,
    MsProviderKeys.financials: true,
    MsProviderKeys.shareHoldings: true,
  };

  void clearAll() {
    _states.forEach((key, _) {
      _states[key] = true;
    });
    _showScore = true;
    notifyListeners();
  }

  bool getState(MsProviderKeys key) => _states[key] ?? true;

  void setState(MsProviderKeys key, bool value) {
    if (_states.containsKey(key)) {
      _states[key] = value;
      notifyListeners();
    }
  }

  void toggleState(MsProviderKeys key) {
    if (_states.containsKey(key)) {
      setState(key, !(_states[key] ?? true));
    }
  }

  bool get openPerformance => getState(MsProviderKeys.performance);
  bool get openFundamentals => getState(MsProviderKeys.fundamentals);
  bool get openPriceVolume => getState(MsProviderKeys.priceVolume);
  bool get openFinancials => getState(MsProviderKeys.financials);
  bool get openShareholdings => getState(MsProviderKeys.shareHoldings);

//---------------------------------------------------------------------------------------------------
  callAPIs({required String symbol}) {
    clearAll();
    getStockTopData(symbol: symbol);
    getRadarChartData(symbol: symbol);
    getOtherStocksData(symbol: symbol);
    getPriceVolatilityData(symbol: symbol);
    fetchAllStockHighlightData(symbol: symbol);
    getTechnicalAnalysisMetricsData(symbol: symbol);
  }
// My Other Stocks---------------------------------------------------------------------------------------------------

  String? _errorTop;
  String? get errorTop => _errorTop ?? Const.errSomethingWrong;

  Status _statusTop = Status.ideal;
  Status get statusTop => _statusTop;

  bool get isLoadingTop => _statusTop == Status.loading;

  Extra? _extraTop;
  Extra? get extraTop => _extraTop;

  MsStockTopRes? _topData;
  MsStockTopRes? get topData => _topData;

  void setStatusTop(status) {
    _statusTop = status;
    notifyListeners();
  }

  Future getStockTopData({required String symbol}) async {
    setStatusTop(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msStockTop,
        request: request,
        baseUrl: Apis.baseUrlLocal, //TODO Remove after this api set to LIVE

        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _topData = msStockTopResFromJson(jsonEncode(response.data));
        _errorTop = null;
        _extraTop = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _topData = null;
        _errorTop = response.message;
        _extraTop = null;
      }

      setStatusTop(Status.loaded);
    } catch (e) {
      _topData = null;

      _extraTop = null;
      _errorTop = Const.errSomethingWrong;
      setStatusTop(Status.loaded);
      Utils().showLog(e.toString());
    }
  }

//Radar Chart----------------------------------------------------------------------------------------
  String? _errorRadar;
  String? get errorRadar => _errorRadar ?? Const.errSomethingWrong;

  Status _statusRadar = Status.ideal;
  Status get statusRadar => _statusRadar;

  bool get isLoadingRadar => _statusRadar == Status.loading;

  Extra? _extra;
  Extra? get extra => _extra;

  List<MsRadarChartRes>? _radar;
  List<MsRadarChartRes>? get radar => _radar;

  void setStatus(status) {
    _statusRadar = status;
    notifyListeners();
  }

  Future getRadarChartData({required String symbol}) async {
    setStatus(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msRadarChart,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _radar = msRadarChartResFromJson(jsonEncode(response.data));
        _errorRadar = null;
        _extra = (response.extra is Extra ? response.extra as Extra : null);
      } else {
        _radar = null;
        _errorRadar = response.message;
        _extra = null;
      }

      setStatus(Status.loaded);
    } catch (e) {
      _radar = null;
      _extra = null;
      _errorRadar = Const.errSomethingWrong;
      setStatus(Status.loaded);
      Utils().showLog(e.toString());
    }
  }

// Price Volatility---------------------------------------------------------------------------------------------------

  String? _errorPrice;
  String? get errorPrice => _errorPrice ?? Const.errSomethingWrong;

  Status _statusPrice = Status.ideal;
  Status get statusPrice => _statusPrice;

  bool get isLoadingPrice => _statusPrice == Status.loading;

  MsPriceVolatilityRes? _priceVolatility;
  MsPriceVolatilityRes? get priceVolatility => _priceVolatility;

  bool _showScore = false;
  bool get showScore => _showScore;

  void setStatusPrice(status) {
    _statusPrice = status;
    notifyListeners();
  }

  void onChangeScore(bool value) {
    // for (var i = 0; i < (_priceVolatility?.score?.length ?? 0); i++) {
    //   _priceVolatility?.score?[i].selected = false;
    // }
    // _priceVolatility?.score?[index].selected = true;

    _showScore = value;
    notifyListeners();
  }

  Future getPriceVolatilityData({required String symbol}) async {
    setStatusPrice(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msPriceVolatility,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _priceVolatility =
            msPriceVolatilityResFromJson(jsonEncode(response.data));
        _errorPrice = null;
      } else {
        _priceVolatility = null;
        _errorPrice = response.message;
      }

      setStatusPrice(Status.loaded);
    } catch (e) {
      _priceVolatility = null;
      _errorPrice = Const.errSomethingWrong;
      setStatusPrice(Status.loaded);
      Utils().showLog(e.toString());
    }
  }

  // Stock Highlights---------------------------------------------------------------------------------------------------

  Status _statusHighLight = Status.ideal;
  Status get statusHighLight => _statusHighLight;

  bool get isLoadingHighLight => _statusHighLight == Status.loading;

  List<MsStockHighlightsRes>? _stockHighlight;
  List<MsStockHighlightsRes>? get stockHighlight => _stockHighlight;

  String? _errorHighlight;
  String? get errorHighlight => _errorHighlight ?? Const.errSomethingWrong;

  void setStatusH(status) {
    _statusHighLight = status;
    notifyListeners();
  }

  Future<void> fetchAllStockHighlightData({required String symbol}) async {
    setStatusH(Status.loading);

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    final Map<String, dynamic> request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };

    try {
      final futures = [
        apiRequest(
            url: Apis.msStockHighlight,
            request: request,
            showProgress: false,
            removeForceLogin: true),
        apiRequest(
            url: Apis.msStockPricing,
            request: request,
            showProgress: false,
            removeForceLogin: true),
        apiRequest(
            url: Apis.msStockProfit,
            request: request,
            showProgress: false,
            removeForceLogin: true),
      ];

      final responses = await Future.wait(futures);

      List<MsStockHighlightsRes> combinedData = [];

      for (var response in responses) {
        if (response.status) {
          var data = msStockHighlightsResFromJson(jsonEncode(response.data));
          combinedData.add(data);
          _errorHighlight = null;
        } else {
          _stockHighlight = null;
          _errorHighlight = null;
          combinedData = [];
        }
      }
      _stockHighlight = combinedData;

      setStatusH(Status.loaded);
    } catch (e) {
      _stockHighlight = null;
      _errorHighlight = null;
      setStatusH(Status.loaded);
      Utils().showLog("~~~~~~~~~$e");
    }
  }

  Future getStockHighlightData({required String symbol}) async {
    setStatusH(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msStockHighlight,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        //
      } else {
        //
      }

      setStatusH(Status.loaded);
    } catch (e) {
      setStatusH(Status.loaded);
      Utils().showLog(e.toString());
    }
  }

  Future getStockHighlightPricingData({required String symbol}) async {
    setStatusH(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msStockPricing,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        //
      } else {
        //
      }

      setStatusH(Status.loaded);
    } catch (e) {
      setStatusH(Status.loaded);
      Utils().showLog(e.toString());
    }
  }

  Future getStockHighlightProfitData({required String symbol}) async {
    setStatusH(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msStockProfit,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        //
      } else {
        //
      }

      setStatusH(Status.loaded);
    } catch (e) {
      setStatusH(Status.loaded);
      Utils().showLog(e.toString());
    }
  }

  // Stock Score---------------------------------------------------------------------------------------------------

// Technical Analysis Metrics---------------------------------------------------------------------------------------------------

  Status _statusMetrics = Status.ideal;
  Status get statusMetrics => _statusMetrics;

  bool get isLoadingMetrics => _statusMetrics == Status.loading;

  String? _errorMetrics;
  String? get errorMetrics => _errorMetrics ?? Const.errSomethingWrong;

  void setStatusMetrics(status) {
    _statusMetrics = status;
    notifyListeners();
  }

  List<TechAnalysisMetricsRes>? _metrics;
  List<TechAnalysisMetricsRes>? get metrics => _metrics;

  Future getTechnicalAnalysisMetricsData({required String symbol}) async {
    try {
      List<TechAnalysisMetricsRes>? data;

      data = [
        TechAnalysisMetricsRes(
          title: "Moving Averages (MA)",
          subTitle: "Total contract value of bookings on a quarterly",
          revenueOf: "Total Revenue of 2024",
          revenue: "50.91M",
          image: Images.graphBG3,
        ),
        TechAnalysisMetricsRes(
          title: "Relative Strength Index (RSI)",
          subTitle: "Total contract value of bookings on a quarterly",
          revenueOf: "Total Revenue of 2024",
          revenue: "50.91M",
          image: Images.graphBG3,
        ),
        TechAnalysisMetricsRes(
          title: "Bollinger Bands",
          subTitle: "Total contract value of bookings on a quarterly",
          revenueOf: "Total Revenue of 2024",
          revenue: "50.91M",
          image: Images.graphBG3,
        ),
        TechAnalysisMetricsRes(
          title: "MACD (Moving Average Convergence Divergence)",
          subTitle: "Total contract value of bookings on a quarterly",
          revenueOf: "Total Revenue of 2024",
          revenue: "50.91M",
          image: Images.graphBG3,
        ),
      ];

      _metrics = data;
      notifyListeners();
    } catch (e) {
      _errorMetrics = Const.errSomethingWrong;
      setStatus(Status.loaded);
    }
  }

// My Other Stocks---------------------------------------------------------------------------------------------------

  Status _statusOtherStock = Status.ideal;
  Status get statusOtherStock => _statusOtherStock;

  bool get isLoadingOtherStock => _statusOtherStock == Status.loading;

  String? _errorOtherStock;
  String? get errorOtherStock => _errorOtherStock ?? Const.errSomethingWrong;

  List<MsMyOtherStockRes>? _otherStocks;
  List<MsMyOtherStockRes>? get otherStocks => _otherStocks;

  void setStatusOtherStock(status) {
    _statusOtherStock = status;
    notifyListeners();
  }

  Future getOtherStocksData({required String symbol}) async {
    setStatusOtherStock(Status.loading);
    // UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      // "token": provider.user?.token ?? "",
      "token": "8W9duDkUiWtfIfDUOAypbv3quY9AZC7s",

      "symbol": symbol,
      "start_date": "2024-08-01",
      "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msOtherStock,
        baseUrl: Apis.baseUrlLocal, //TODO Remove after this api set to LIVE
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _otherStocks = msMyOtherStockResFromJson(jsonEncode(response.data));
        _errorOtherStock = null;
      } else {
        _otherStocks = null;
        _errorOtherStock = null;
      }

      setStatusOtherStock(Status.loaded);
    } catch (e) {
      _otherStocks = null;
      _errorOtherStock = null;
      setStatusOtherStock(Status.loaded);
      Utils().showLog(e.toString());
    }
  }
}

class TechAnalysisMetricsRes {
  final String title;
  final String subTitle;
  final String revenueOf;
  final String revenue;
  final String image;
  TechAnalysisMetricsRes({
    required this.title,
    required this.subTitle,
    required this.revenueOf,
    required this.revenue,
    required this.image,
  });
}

class TechAnalysisSummaryRes {
  final String label;
  final num value;
  TechAnalysisSummaryRes({
    required this.label,
    required this.value,
  });
}
