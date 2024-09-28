import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/modals/faqs_res.dart';
import 'package:stocks_news_new/modals/msAnalysis/radar_chart.dart';
import 'package:stocks_news_new/route/my_app.dart';
import '../../api/api_response.dart';
import '../../modals/msAnalysis/complete.dart';
import '../../modals/msAnalysis/financials.dart';
import '../../modals/msAnalysis/ms_top_res.dart';
import '../../modals/msAnalysis/news.dart';
import '../../modals/msAnalysis/other_stocks.dart';
import '../../modals/msAnalysis/peer_comparision.dart';
import '../../modals/msAnalysis/price_volatility.dart';
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
    // _showScore = true;
    _showScoreComplete = true;
    selectedTypeIndex = 0;
    selectedPeriodIndex = 0;
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
    // getRadarChartData(symbol: symbol);
    getOtherStocksData(symbol: symbol);
    getPriceVolumeData(symbol: symbol);
    getPriceVolatilityData(symbol: symbol);
    // fetchAllStockHighlightData(symbol: symbol);
    // getTechnicalAnalysisMetricsData(symbol: symbol);
    getFinancialsData(symbol: symbol, type: 'revenue', period: 'annual');
    getPeerComparisonData(symbol: symbol);
    getCompleteData(symbol: symbol);
    getFaqData(symbol: symbol);
    getNewsData(symbol: symbol);
    getEventsData(symbol: symbol);
  }

// Update Top Detail with Socket
  void updateSocket({
    String? price,
    num? priceVal,
    num? change,
    num? changePercentage,
    String? changeString,
  }) {
    if (priceVal != null) {
      _topData?.priceValue = priceVal;
    }

    if (change != null) {
      _topData?.change = change;
    }
    if (price != null && price != '') {
      _topData?.price = price;
    }
    if (changePercentage != null) {
      _topData?.changesPercentage = changePercentage;
    }
    if (changeString != null && changeString != '') {
      _topData?.changeWithCur = changeString;
    }

    notifyListeners();
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
      // "start_date": "2024-08-01",
      // "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msStockTop,
        request: request,
        // baseUrl: Apis.baseUrlLocal, //TODO Remove after this api set to LIVE

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
      Utils().showLog("ERROR in getStockTopData =>$e");
    }
  }

//Radar Chart----------------------------------------------------------------------------------------

  // String? _errorRadar;
  // String? get errorRadar => _errorRadar ?? Const.errSomethingWrong;
  // Status _statusRadar = Status.ideal;
  // Status get statusRadar => _statusRadar;
  // bool get isLoadingRadar => _statusRadar == Status.loading;
  // Extra? _extra;
  // Extra? get extra => _extra;
  // List<MsRadarChartRes>? _radar;
  // List<MsRadarChartRes>? get radar => _radar;
  // void setStatus(status) {
  //   _statusRadar = status;
  //   notifyListeners();
  // }

  // Future getRadarChartData({required String symbol}) async {
  //   setStatus(Status.loading);
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   Map request = {
  //     "token": provider.user?.token ?? "",
  //     "symbol": symbol,
  //     "start_date": "2024-08-01",
  //     "end_date": "2024-08-21",
  //   };
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.msRadarChart,
  //       request: request,
  //       showProgress: false,
  //       removeForceLogin: true,
  //     );
  //     if (response.status) {
  //       _radar = msRadarChartResFromJson(jsonEncode(response.data));
  //       _errorRadar = null;
  //       _extra = (response.extra is Extra ? response.extra as Extra : null);
  //     } else {
  //       _radar = null;
  //       _errorRadar = response.message;
  //       _extra = null;
  //     }
  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     _radar = null;
  //     _extra = null;
  //     _errorRadar = Const.errSomethingWrong;
  //     setStatus(Status.loaded);
  //     Utils().showLog("ERROR in getRadarChartData =>$e");
  //   }
  // }

// Price Volatility---------------------------------------------------------------------------------------------------

  String? _errorPrice;
  String? get errorPrice => _errorPrice ?? Const.errSomethingWrong;
  Status _statusPrice = Status.ideal;
  Status get statusPrice => _statusPrice;
  bool get isLoadingPrice => _statusPrice == Status.loading;
  MsPriceVolatilityRes? _priceVolatility;
  MsPriceVolatilityRes? get priceVolatility => _priceVolatility;
  // bool _showScore = false;
  // bool get showScore => _showScore;
  void setStatusPrice(status) {
    _statusPrice = status;
    notifyListeners();
  }
  // void onChangeScore(bool value) {
  //   _showScore = value;
  //   notifyListeners();
  // }

  Future getPriceVolatilityData({required String symbol}) async {
    setStatusPrice(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      // "start_date": "2024-08-01",
      // "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        // url: Apis.msPriceVolatility,
        url: Apis.msPriceVolatilityNew,
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
      Utils().showLog("ERROR in getPriceVolatilityData =>$e");
    }
  }

  // Stock Highlights---------------------------------------------------------------------------------------------------

  // Status _statusHighLight = Status.ideal;
  // Status get statusHighLight => _statusHighLight;
  // bool get isLoadingHighLight => _statusHighLight == Status.loading;
  // List<MsStockHighlightsRes>? _stockHighlight;
  // List<MsStockHighlightsRes>? get stockHighlight => _stockHighlight;
  // String? _errorHighlight;
  // String? get errorHighlight => _errorHighlight ?? Const.errSomethingWrong;
  // void setStatusH(status) {
  //   _statusHighLight = status;
  //   notifyListeners();
  // }

  // Future<void> fetchAllStockHighlightData({required String symbol}) async {
  //   setStatusH(Status.loading);
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   final Map<String, dynamic> request = {
  //     "token": provider.user?.token ?? "",
  //     "symbol": symbol,
  //     "start_date": "2024-08-01",
  //     "end_date": "2024-08-21",
  //   };
  //   try {
  //     final futures = [
  //       apiRequest(
  //           url: Apis.msStockHighlight,
  //           request: request,
  //           showProgress: false,
  //           removeForceLogin: true),
  //       apiRequest(
  //           url: Apis.msStockPricing,
  //           request: request,
  //           showProgress: false,
  //           removeForceLogin: true),
  //       apiRequest(
  //           url: Apis.msStockProfit,
  //           request: request,
  //           showProgress: false,
  //           removeForceLogin: true),
  //     ];
  //     final responses = await Future.wait(futures);
  //     List<MsStockHighlightsRes> combinedData = [];
  //     for (var response in responses) {
  //       if (response.status) {
  //         var data = msStockHighlightsResFromJson(jsonEncode(response.data));
  //         combinedData.add(data);
  //         _errorHighlight = null;
  //       } else {
  //         _stockHighlight = null;
  //         _errorHighlight = null;
  //         combinedData = [];
  //       }
  //     }
  //     _stockHighlight = combinedData;
  //     setStatusH(Status.loaded);
  //   } catch (e) {
  //     _stockHighlight = null;
  //     _errorHighlight = null;
  //     setStatusH(Status.loaded);
  //     Utils().showLog("~~~~~~~~~$e");
  //   }
  // }

  // Future getStockHighlightData({required String symbol}) async {
  //   setStatusH(Status.loading);
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   Map request = {
  //     "token": provider.user?.token ?? "",
  //     "symbol": symbol,
  //     "start_date": "2024-08-01",
  //     "end_date": "2024-08-21",
  //   };
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.msStockHighlight,
  //       request: request,
  //       showProgress: false,
  //       removeForceLogin: true,
  //     );
  //     if (response.status) {
  //       //
  //     } else {
  //       //
  //     }
  //     setStatusH(Status.loaded);
  //   } catch (e) {
  //     setStatusH(Status.loaded);
  //     Utils().showLog("ERROR in getStockHighlightData =>$e");
  //   }
  // }

  // Future getStockHighlightPricingData({required String symbol}) async {
  //   setStatusH(Status.loading);
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   Map request = {
  //     "token": provider.user?.token ?? "",
  //     "symbol": symbol,
  //     "start_date": "2024-08-01",
  //     "end_date": "2024-08-21",
  //   };
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.msStockPricing,
  //       request: request,
  //       showProgress: false,
  //       removeForceLogin: true,
  //     );
  //     if (response.status) {
  //       //
  //     } else {
  //       //
  //     }
  //     setStatusH(Status.loaded);
  //   } catch (e) {
  //     setStatusH(Status.loaded);
  //     Utils().showLog("ERROR in getStockHighlightPricingData =>$e");
  //   }
  // }

  // Future getStockHighlightProfitData({required String symbol}) async {
  //   setStatusH(Status.loading);
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
  //   Map request = {
  //     "token": provider.user?.token ?? "",
  //     "symbol": symbol,
  //     "start_date": "2024-08-01",
  //     "end_date": "2024-08-21",
  //   };
  //   try {
  //     ApiResponse response = await apiRequest(
  //       url: Apis.msStockProfit,
  //       request: request,
  //       showProgress: false,
  //       removeForceLogin: true,
  //     );
  //     if (response.status) {
  //       //
  //     } else {
  //       //
  //     }
  //     setStatusH(Status.loaded);
  //   } catch (e) {
  //     setStatusH(Status.loaded);
  //     Utils().showLog("ERROR in getStockHighlightProfitData =>$e");
  //   }
  // }

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

      Utils().showLog("ERROR in getTechnicalAnalysisMetricsData =>$e");
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
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      // "token": "8W9duDkUiWtfIfDUOAypbv3quY9AZC7s",

      "symbol": symbol,
      // "start_date": "2024-08-01",
      // "end_date": "2024-08-21",
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msOtherStock,
        // baseUrl: Apis.baseUrlLocal, //TODO Remove after this api set to LIVE
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
      Utils().showLog("ERROR in getOtherStocksData =>$e");
    }
  }

// Financials ---------------------------------------------------------------------------------------------------

  Status _statusFinancials = Status.ideal;
  Status get statusFinancials => _statusFinancials;

  bool get isLoadingFinancials => _statusFinancials == Status.loading;

  String? _errorFinancials;
  String? get errorFinancials => _errorFinancials ?? Const.errSomethingWrong;

  List<MsFinancialsRes>? _financialsData;
  List<MsFinancialsRes>? get financialsData => _financialsData;

  void setStatusFinancials(status) {
    _statusFinancials = status;
    notifyListeners();
  }

  int selectedTypeIndex = 0;
  int selectedPeriodIndex = 0;

  List<String> typeMenu = [
    'Revenue',
    'Net profit',
  ];

  List<String> periodMenu = [
    'Annual',
    'Quarterly',
  ];

  void onChangeFinancial({
    int? typeIndex,
    int? periodIndex,
  }) {
    if (typeIndex != null) {
      selectedTypeIndex = typeIndex;
    }
    if (periodIndex != null) {
      selectedPeriodIndex = periodIndex;
    }
    notifyListeners();
    getFinancialsData(
      symbol: topData?.symbol ?? "",
      type: selectedTypeIndex == 0 ? 'revenue' : 'profit',
      period: selectedPeriodIndex == 0 ? 'annual' : 'quarter',
    );
  }

  Future getFinancialsData({
    required String symbol,
    required String period,
    required String type,
  }) async {
    setStatusFinancials(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "period": period,
      "type": type,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msFinancials,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _financialsData = msFinancialsResFromJson(jsonEncode(response.data));
        _errorFinancials = null;
      } else {
        _financialsData = null;
        _errorFinancials = null;
      }

      setStatusFinancials(Status.loaded);
    } catch (e) {
      _financialsData = null;
      _errorFinancials = null;
      setStatusFinancials(Status.loaded);
      Utils().showLog("ERROR in getFinancialsData =>$e");
    }
  }

//Peer Comparison ---------------------------------------------------------------------------------------------------

  Status _statusPeer = Status.ideal;
  Status get statusPeer => _statusPeer;

  bool get isLoadingPeer => _statusPeer == Status.loading;

  String? _errorPeer;
  String? get errorPeer => _errorPeer ?? Const.errSomethingWrong;

  MsPeerComparisonRes? _peerData;
  MsPeerComparisonRes? get peerData => _peerData;

  void setStatusPeer(status) {
    _statusPeer = status;
    notifyListeners();
  }

  Future getPeerComparisonData({required String symbol}) async {
    setStatusPeer(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msPeer,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _peerData = msPeerComparisonResFromJson(jsonEncode(response.data));
        _errorPeer = null;
      } else {
        _peerData = null;
        _errorPeer = null;
      }

      setStatusPeer(Status.loaded);
    } catch (e) {
      _peerData = null;
      _errorPeer = null;
      setStatusPeer(Status.loaded);
      Utils().showLog("ERROR in getPeerComparisonData =>$e");
    }
  }

//FAQs ---------------------------------------------------------------------------------------------------

  Status _statusFaqs = Status.ideal;
  Status get statusFaqs => _statusFaqs;

  bool get isLoadingFaqs => _statusFaqs == Status.loading;

  String? _errorFaqs;
  String? get errorFaqs => _errorFaqs ?? Const.errSomethingWrong;

  List<FaQsRes>? _faqData;
  List<FaQsRes>? get faqData => _faqData;

  void setStatusFaqs(status) {
    _statusFaqs = status;
    notifyListeners();
  }

  Future getFaqData({required String symbol}) async {
    setStatusFaqs(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msFaqs,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _faqData = faQsResFromJson(jsonEncode(response.data));
        _errorFaqs = null;
      } else {
        _faqData = null;
        _errorFaqs = null;
      }

      setStatusFaqs(Status.loaded);
    } catch (e) {
      _faqData = null;
      _errorFaqs = null;
      setStatusFaqs(Status.loaded);
      Utils().showLog("ERROR in getFaqData =>$e");
    }
  }

//Price And Volume ---------------------------------------------------------------------------------------------------

  Status _statusPV = Status.ideal;
  Status get statusPV => _statusPV;

  bool get isLoadingPV => _statusPV == Status.loading;

  String? _errorPV;
  String? get errorPV => _errorPV ?? Const.errSomethingWrong;

  List<MsRadarChartRes>? _pvData;
  List<MsRadarChartRes>? get pvData => _pvData;

  void setStatusPV(status) {
    _statusPV = status;
    notifyListeners();
  }

  Future getPriceVolumeData({required String symbol, selectedIndex = 0}) async {
    setStatusPV(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse response = await apiRequest(
        url: selectedIndex == 0 ? Apis.pastReturn : Apis.postVolume,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _pvData = msRadarChartResFromJson(jsonEncode(response.data));
        _errorPV = null;
      } else {
        _pvData = null;
        _errorPV = null;
      }

      setStatusPV(Status.loaded);
    } catch (e) {
      _pvData = null;
      _errorPV = null;
      setStatusPV(Status.loaded);
      Utils().showLog("ERROR in getPriceVolumeData =>$e");
    }
  }

//Latest News ---------------------------------------------------------------------------------------------------

  Status _statusNews = Status.ideal;
  Status get statusNews => _statusNews;

  bool get isLoadingNews => _statusNews == Status.loading;

  String? _errorNews;
  String? get errorNews => _errorNews ?? Const.errSomethingWrong;

  List<MsNewsRes>? _msNews;
  List<MsNewsRes>? get msNews => _msNews;

  void setStatusNews(status) {
    _statusNews = status;
    notifyListeners();
  }

  Future getNewsData({required String symbol}) async {
    setStatusNews(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msNews,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _msNews = msNewsResFromJson(jsonEncode(response.data));
        _errorNews = null;
      } else {
        _msNews = null;
        _errorNews = null;
      }

      setStatusNews(Status.loaded);
    } catch (e) {
      _msNews = null;
      _errorNews = null;
      setStatusNews(Status.loaded);
      Utils().showLog("ERROR in getNewsData =>$e");
    }
  }

//Events ---------------------------------------------------------------------------------------------------

  Status _statusEvents = Status.ideal;
  Status get statusEvents => _statusEvents;

  bool get isLoadingEvents => _statusEvents == Status.loading;

  String? _errorEvents;
  String? get errorEvents => _errorEvents ?? Const.errSomethingWrong;

  List<MsRadarChartRes>? _msEvents;
  List<MsRadarChartRes>? get msEvents => _msEvents;

  void setStatusEvents(status) {
    _statusEvents = status;
    notifyListeners();
  }

  Future getEventsData({required String symbol}) async {
    setStatusEvents(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msEvents,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _msEvents = msRadarChartResFromJson(jsonEncode(response.data));
        _errorEvents = null;
      } else {
        _msEvents = null;
        _errorEvents = null;
      }

      setStatusEvents(Status.loaded);
    } catch (e) {
      _msEvents = null;
      _errorEvents = null;
      setStatusEvents(Status.loaded);
      Utils().showLog("ERROR in getEventsData =>$e");
    }
  }

//Complete Data ---------------------------------------------------------------------------------------------------

  Status _statusComplete = Status.ideal;
  Status get statusComplete => _statusComplete;

  bool get isLoadingComplete => _statusComplete == Status.loading;

  String? _errorComplete;
  String? get errorComplete => _errorComplete ?? Const.errSomethingWrong;

  MsCompleteRes? _completeData;
  MsCompleteRes? get completeData => _completeData;

  void setStatusComplete(status) {
    _statusComplete = status;
    notifyListeners();
  }

  bool _showScoreComplete = false;
  bool get showScoreComplete => _showScoreComplete;

  void onChangeCompleteScore(bool value) {
    _showScoreComplete = value;
    notifyListeners();
  }

  Future getCompleteData({required String symbol}) async {
    setStatusComplete(Status.loading);
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.msComplete,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _completeData = msCompleteResFromJson(jsonEncode(response.data));
        _errorComplete = null;
      } else {
        _completeData = null;
        _errorComplete = null;
      }

      setStatusComplete(Status.loaded);
    } catch (e) {
      _completeData = null;
      _errorComplete = null;
      setStatusComplete(Status.loaded);
      Utils().showLog("ERROR in getCompleteData =>$e");
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


// class FinancialChartDataHolder{
//   int typeIndex;
//   int periodIndex;
//   List<MsFinancialsRes>? data;
//   FinancialChartDataHolder({required this.data});
// }