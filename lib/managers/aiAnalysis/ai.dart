import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../models/stockDetail/financial.dart';
import '../../models/stockDetail/price_volume.dart';
import '../../utils/constants.dart';
import '../user.dart';

class AIManager extends ChangeNotifier {
  clearAllData() {
    _data = null;
    _financialsData = null;
    selectedTypeIndex = 0;
    selectedPeriodIndex = 0;
    _selectedTicker = null;
    _dataPV = null;
    notifyListeners();
  }

  //MARK: AI
  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  Status _status = Status.ideal;
  Status get status => _status;

  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  AIRes? _data;
  AIRes? get data => _data;

  String? _selectedTicker;
  String? get selectedTicker => _selectedTicker;

  bool _navigatedFromSD = false;
  bool get navigatedFromSD => _navigatedFromSD;

  setNavigatedFrom(value) {
    _navigatedFromSD = value;
    notifyListeners();
  }

  setStatus(status) {
    _status = status;
    notifyListeners();
  }

  Future getAIData(String symbol) async {
    clearAllData();
    _selectedTicker = symbol;
    try {
      setStatus(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': symbol,
      };

      ApiResponse response = await apiRequest(
        url: Apis.aiAnalysis,
        request: request,
      );
      if (response.status) {
        _data = AIResFromJson(jsonEncode(response.data));
        _error = null;
      } else {
        _data = null;
        _error = response.message;
      }
    } catch (e) {
      _data = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.aiAnalysis} $e');
    } finally {
      setStatus(Status.loaded);
    }
  }

//MARK: Financial
  Status _statusFinancials = Status.ideal;
  Status get statusFinancials => _statusFinancials;

  bool get isLoadingFinancials =>
      _statusFinancials == Status.loading || _statusFinancials == Status.ideal;

  String? _errorFinancials;
  String? get errorFinancials => _errorFinancials;

  AiFinancialRes? _financialsData;
  AiFinancialRes? get financialsData => _financialsData;

  void setStatusFinancials(status) {
    _statusFinancials = status;
    notifyListeners();
  }

  int selectedTypeIndex = 0;
  int selectedPeriodIndex = 0;

  List<MarketResData> typeMenu = [
    MarketResData(title: 'Revenue', slug: 'revenue'),
    MarketResData(title: 'Net Profit', slug: 'profit'),
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
      symbol: _selectedTicker ?? '',
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
    UserManager provider = navigatorKey.currentContext!.read<UserManager>();

    Map request = {
      "token": provider.user?.token ?? "",
      "symbol": symbol,
      "period": period,
      "type": type,
    };
    try {
      ApiResponse response = await apiRequest(
        url: Apis.aiFinancials,
        request: request,
        showProgress: false,
        removeForceLogin: true,
      );
      if (response.status) {
        _financialsData = aiFinancialResFromJson(jsonEncode(response.data));
        _errorFinancials = null;
      } else {
        _financialsData = null;
        _errorFinancials = response.message;
      }

      setStatusFinancials(Status.loaded);
    } catch (e) {
      _financialsData = null;
      _errorFinancials = null;
      setStatusFinancials(Status.loaded);
      Utils().showLog("ERROR in getFinancialsData =>$e");
    }
  }

  //MARK: Price Volume
  String? _errorPV;
  String? get errorPV => _errorPV ?? Const.errSomethingWrong;

  Status _statusPV = Status.ideal;
  Status get statusPV => _statusPV;

  bool get isLoadingPV =>
      _statusPV == Status.loading || _status == Status.ideal;

  AIPriceVolumeRes? _dataPV;
  AIPriceVolumeRes? get dataPV => _dataPV;

  setStatusPV(status) {
    _statusPV = status;
    notifyListeners();
  }

  Future getAiPvData({int selectedIndex = 0}) async {
    _dataPV = null;
    try {
      setStatusPV(Status.loading);
      UserManager provider = navigatorKey.currentContext!.read<UserManager>();
      Map request = {
        'token': provider.user?.token ?? '',
        'symbol': _selectedTicker,
      };

      ApiResponse response = await apiRequest(
        url: selectedIndex == 0 ? Apis.aiPR : Apis.aiPV,
        request: request,
      );
      if (response.status) {
        _dataPV = AIPriceVolumeResFromJson(jsonEncode(response.data));
        _errorPV = null;
      } else {
        _dataPV = null;
        _errorPV = response.message;
      }
    } catch (e) {
      _dataPV = null;
      _errorPV = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.aiAnalysis} $e');
    } finally {
      setStatusPV(Status.loaded);
    }
  }
}
