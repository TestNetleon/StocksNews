import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/route/my_app.dart';

import '../../api/api_response.dart';
import '../../modals/msAnalysis/price_volatility.dart';
import '../../modals/msAnalysis/radar_chart.dart';
import '../../modals/msAnalysis/stock_highlights.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../user_provider.dart';
import '../watchlist_provider.dart';

class MSAnalysisProvider extends ChangeNotifier {
  // Clear Data
  clearAll() {
    _openFinancials = false;
    _openFundamentals = false;
    _openPerformance = false;
    _openPriceVolume = false;
    _openShareholdings = false;
    notifyListeners();
  }

  // OPEN performance
  bool _openPerformance = false;
  bool get openPerformance => _openPerformance;

  openPerformanceStatus(value) {
    _openPerformance = value;
    notifyListeners();
  }

  // OPEN fundamentals
  bool _openFundamentals = false;
  bool get openFundamentals => _openFundamentals;

  openFundamentalsStatus(value) {
    _openFundamentals = value;
    notifyListeners();
  }

  // OPEN priceVolume
  bool _openPriceVolume = false;
  bool get openPriceVolume => _openPriceVolume;

  openPriceVolumeStatus(value) {
    _openPriceVolume = value;
    notifyListeners();
  }

  // OPEN financials
  bool _openFinancials = false;
  bool get openFinancials => _openFinancials;

  openFinancialsStatus(value) {
    _openFinancials = value;
    notifyListeners();
  }

  // OPEN shareholdings
  bool _openShareholdings = false;
  bool get openShareholdings => _openShareholdings;

  openShareholdingsStatus(value) {
    _openShareholdings = value;
    notifyListeners();
  }

//---------------------------------------------------------------------------------------------------
  callAPIs() {
    clearAll();
    getRadarChartData();
    navigatorKey.currentContext!.read<WatchlistProvider>().getData(
          loadMore: false,
          showProgress: false,
        );
    getPriceVolatilityData();
    fetchAllStockHighlightData();
    getTechnicalAnalysisMetricsData();
  }

//---------------------------------------------------------------------------------------------------
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

  Future getRadarChartData() async {
    setStatus(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
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

  void setStatusPrice(status) {
    _statusPrice = status;
    notifyListeners();
  }

  Future getPriceVolatilityData() async {
    setStatusPrice(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
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

  Future<void> fetchAllStockHighlightData() async {
    setStatusH(Status.loading);

    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();

    final Map<String, dynamic> request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
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

  Future getStockHighlightData() async {
    setStatusH(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
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

  Future getStockHighlightPricingData() async {
    setStatusH(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
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

  Future getStockHighlightProfitData() async {
    setStatusH(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    StockDetailProviderNew detailProvider =
        navigatorKey.currentContext!.read<StockDetailProviderNew>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": detailProvider.tabRes?.keyStats?.symbol ?? "",
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
  bool scoreOn = false;
  num stockScore = 0.5;
  onChangeScore(value) {
    scoreOn = value;
    scoreOn ? stockScore = .8 : stockScore = 0.5;
    notifyListeners();
  }

// Technical Analysis Metrics

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

  Future getTechnicalAnalysisMetricsData() async {
    try {
      List<TechAnalysisMetricsRes>? _data;

      _data = [
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

      _metrics = _data;
      notifyListeners();
    } catch (e) {
      _errorMetrics = Const.errSomethingWrong;
      setStatus(Status.loaded);
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
