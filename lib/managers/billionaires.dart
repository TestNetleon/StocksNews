import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_detail.dart';
import 'package:stocks_news_new/models/crypto_models/billionaires_res.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_detail_res.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_fiat_res.dart';
import 'package:stocks_news_new/models/crypto_models/crypto_watchlist_res.dart';
import 'package:stocks_news_new/models/crypto_models/recent_tweet_res.dart';
import 'package:stocks_news_new/models/stockDetail/historical_chart.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';

class BillionairesManager extends ChangeNotifier{

  List<String> titleArray =[];
  BillionairesRes? _billionairesRes;
  BillionairesRes? get billionairesRes=> _billionairesRes;

  BillionairesDetailRes? _billionairesDetailRes;
  BillionairesDetailRes? get billionairesDetailRes=> _billionairesDetailRes;

  CryptoDetailRes? _cryptoDetailRes;
  CryptoDetailRes? get cryptoDetailRes=> _cryptoDetailRes;


  BaseKeyValueRes? _categoriesData;
  BaseKeyValueRes? get categoriesData => _categoriesData;

  String? _error;
  Status _status = Status.ideal;
  String? get error => _error ?? Const.errSomethingWrong;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  Status _statusCrypto = Status.ideal;
  bool get isLoadingCrypto => _statusCrypto == Status.loading || _statusCrypto == Status.ideal;


  CryptoWatchRes? _cryptoWatchRes;
  CryptoWatchRes? get cryptoWatchRes=> _cryptoWatchRes;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void setStatusCrypto(status) {
    _statusCrypto = status;
    notifyListeners();
  }


  Future<void> getTabs() async {
    try {
      setStatus(Status.loading);
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoTabs,
        request: request,
      );

      if (response.status) {
        _categoriesData = baseResDataFromJson(jsonEncode(response.data));
        _error = null;
        onScreenChange(0);
      } else {
        _categoriesData = null;
        _error = response.message;
      }
    } catch (e) {
      _categoriesData = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error on ${Apis.cryptoTabs}: $e');

    } finally {
      setStatus(Status.loaded);
    }
  }


  Future getCryptoCurrencies() async {
    setStatusCrypto(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoHome,
        showProgress: false,
        request: request,
      );

      if (response.status) {
        _billionairesRes = billionairesResFromJson(jsonEncode(response.data));
      }
      else {
        _billionairesRes = null;
        _error = response.message;
      }
      setStatusCrypto(Status.loaded);
    } catch (e) {
      _billionairesRes = null;
      _error = Const.errSomethingWrong;
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusCrypto(Status.loaded);
    }
  }

  RecentTweetRes? _recentTweetRes;
  RecentTweetRes? get recentTweetRes=> _recentTweetRes;

  Status _tweetStatus = Status.ideal;
  Status get tweetStatus => _tweetStatus;
  bool get isTweetLoading => _tweetStatus == Status.loading || _tweetStatus == Status.ideal;

  void setTweetStatus(Status status) {
    _tweetStatus = status;
    notifyListeners();
  }


  Future getBillionaireTweets({String? tName}) async {
    setTweetStatus(Status.loading);
    try {
      Map request = {
        "twitter_name":tName ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.billionaireTweets,
        request: request,
      );

      if (response.status) {
        _recentTweetRes = recentTweetResFromJson(jsonEncode(response.data));
      }
      else {
        _recentTweetRes = null;
        _error = response.message;
      }
      setTweetStatus(Status.loaded);
    } catch (e) {
      _recentTweetRes = null;
      _error = Const.errSomethingWrong;
      setTweetStatus(Status.loaded);
    }
  }

  BillionairesRes? _viewBillRes;
  BillionairesRes? get viewBillRes=> _viewBillRes;

  Status _viewStatus = Status.ideal;
  Status get viewStatus => _viewStatus;
  bool get isViewLoading => _viewStatus == Status.loading || _viewStatus == Status.ideal;

  void setViewStatus(Status status) {
    _viewStatus = status;
    notifyListeners();
  }

  Future getAllBills() async {
    setViewStatus(Status.loading);
    try {
      Map request = {

      };
      ApiResponse response = await apiRequest(
        url: Apis.viewAll,
        request: request,
      );

      if (response.status) {
        _viewBillRes = billionairesResFromJson(jsonEncode(response.data));
      }
      else {
        _viewBillRes = null;
        _error = response.message;
      }
      setViewStatus(Status.loaded);
    } catch (e) {
      _viewBillRes = null;
      _error = Const.errSomethingWrong;
      setViewStatus(Status.loaded);
    }
  }

  Status _statusBDetail = Status.ideal;
  bool get isLoadingBDetail => _statusBDetail == Status.loading || _statusBDetail == Status.ideal;

  void setStatusBDetail(status) {
    _statusBDetail = status;
    notifyListeners();
  }

  Future getBilDetail(String slug) async {
    setStatusBDetail(Status.loading);
    try {
      Map request = {
        'slug':slug
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoBillionaireDetails,
        showProgress: false,
        request: request,
      );

      if (response.status) {
        _billionairesDetailRes = billionairesDetailResFromJson(jsonEncode(response.data));
      }
      else {
        _billionairesDetailRes = null;
        _error = response.message;
      }
      setStatusBDetail(Status.loaded);
    } catch (e) {
      _billionairesDetailRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoBillionaireDetails}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusBDetail(Status.loaded);
    }
  }

  Status _statusCDetail = Status.ideal;
  bool get isLoadingCDetail => _statusCDetail == Status.loading || _statusCDetail == Status.ideal;

  void setStatusCDetail(status) {
    _statusCDetail = status;
    notifyListeners();
  }
  Future getCryptoDetail(String symbol,{String? currency}) async {
    clearValues();
    setStatusCDetail(Status.loading);
    try {
      Map request = {
        'symbol': symbol,
        'currency': currency??"",
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoDetails,
        showProgress: false,
        request: request,
      );
      if (response.status) {
        try{
          _cryptoDetailRes = cryptoWatchResFromJson(jsonEncode(response.data));
          if(_cryptoDetailRes?.cryptoData?.cryptoSymbol!=null && _cryptoDetailRes?.cryptoData?.cryptoSymbol?.isNotEmpty==true){
            selectedSymbol=_cryptoDetailRes?.cryptoData?.cryptoSymbol?.isNotEmpty==true?
            _cryptoDetailRes?.cryptoData?.cryptoSymbol?.firstWhere((symbols) => symbols.symbol == symbol):
            // _cryptoDetailRes?.cryptoData?.cryptoSymbol?.first:
            null;
          }
          if( _cryptoDetailRes?.cryptoData?.rates!=null &&  _cryptoDetailRes?.cryptoData?.rates?.isNotEmpty==true){
            selectedItem= _cryptoDetailRes?.cryptoData?.rates?.isNotEmpty==true?
            currency!=null?
            _cryptoDetailRes?.cryptoData?.rates?.firstWhere((rate) => rate.currency == currency):
            _cryptoDetailRes?.cryptoData?.rates?.first:null;
          }
          usdController.text = (((selectedSymbol?.price??0)*(selectedItem?.price??0)) * double.parse(btcController.text)).toStringAsFixed(2);
        }
        catch(e){
          Utils().showLog('Error $e');
        }
      }
      else {
        _cryptoDetailRes = null;
        _error = response.message;
      }
      setStatusCDetail(Status.loaded);
    } catch (e) {
      _cryptoDetailRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoDetails}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusCDetail(Status.loaded);
    }
  }


  String? _errorHistoricalC;
  String? get errorHistoricalC => _errorHistoricalC ?? Const.errSomethingWrong;

  Status _statusHistoricalC = Status.ideal;
  Status get statusHistoricalC => _statusHistoricalC;

  bool get isLoadingHistoricalC => _statusHistoricalC == Status.loading;

  List<HistoricalChartRes>? _dataHistoricalC;
  List<HistoricalChartRes>? get dataHistoricalC => _dataHistoricalC;

  setStatusHistoricalC(status) {
    _statusHistoricalC = status;
    notifyListeners();
  }

  LineChartData avgData({
    bool showDate = true,
    required List<HistoricalChartRes> reversedData,
  }) {
    List<FlSpot> spots = [];
    String? symbol;

    for (int i = 0; i < reversedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), reversedData[i].close.toDouble()));
      symbol=reversedData[i].currencySymbol??"";
    }

    return LineChartData(
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        getTouchLineEnd: (barData, spotIndex) {
          return double.infinity;
        },
        getTouchLineStart: (barData, spotIndex) {
          return 0.0;
        },
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: spots.first.y > spots.last.y
                    ? ThemeColors.sos
                    : ThemeColors.accent,
                strokeWidth: 1,
                dashArray: [5, 0],
              ),
              FlDotData(
                show: true,
                checkToShowDot: (spot, barData) {
                  return true;
                },
              ),
            );
          }).toList();
        },
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipHorizontalOffset: 0,
          tooltipRoundedRadius: 4.0,
          showOnTopOfTheChartBoxArea: true,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          maxContentWidth: 300,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
                  (LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  children: [
                    TextSpan(
                      text: "$symbol${touchedSpot.y.toStringAsFixed(2)}\n",
                      style: styleBaseBold(
                          fontSize: 18,
                          fontFamily: 'Roboto'
                      ),
                    ),
                    TextSpan(
                      text: !showDate
                          ? DateFormat('dd MMM, yyyy')
                          .format(reversedData[touchedSpot.x.toInt()].date)
                          : '${DateFormat('dd MMM').format(reversedData[touchedSpot.x.toInt()].date)}, ${DateFormat('h:mm a').format(reversedData[touchedSpot.x.toInt()].date)}',
                      style: styleBaseBold(
                          height: 1.5,
                        //  color: ThemeColors.primary,
                          fontSize: 13),
                    ),
                  ],
                  '',
                  styleBaseBold(fontSize: 10),
                );
              },
            ).toList();
          },
          getTooltipColor: (touchedSpot) {
            return ThemeColors.greyText;
          },
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            )),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            )),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 32,
            showTitles: false,
          ),
        ),
      ),
      gridData: FlGridData(
        show: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ThemeColors.black,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ThemeColors.black,
            strokeWidth: 1,
          );
        },
      ),
      minX: 0,
      maxX: reversedData.length.toDouble() - 1,
      minY: reversedData
          .map((data) => data.close.toDouble())
          .reduce((a, b) => a < b ? a : b),
      maxY: reversedData
          .map((data) => data.close.toDouble())
          .reduce((a, b) => a > b ? a : b),
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: spots,
          color: spots.first.y > spots.last.y
              ? ThemeColors.sos
              : ThemeColors.accent,
          isCurved: true,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: spots.first.y > spots.last.y
                  ? [
                const Color.fromRGBO(255, 99, 99, 0.18),
                const Color.fromRGBO(255, 150, 150, 0.15),
                const Color.fromRGBO(255, 255, 255, 0.0),
              ]
                  : [
                const Color.fromRGBO(71, 193, 137, 0.18),
                const Color.fromRGBO(171, 227, 201, 0.15),
                const Color.fromRGBO(255, 255, 255, 0.0),
              ],
              stops: [0.0, 0.6, 4],
            ),
          ),
        ),
      ],
    );
  }

  Future getCrHistoricalC({String range = '1hour', bool reset = false,String? symbol,String? currency}) async {
    if (symbol == '') return;
    if (reset) _dataHistoricalC = null;
    try {
      setStatusHistoricalC(Status.loading);
      Map request = {
        'symbol': symbol,
        'range': range,
        'currency': currency??"",
      };

      ApiResponse response = await apiRequest(
        url: Apis.cryptoChart,
        request: request,
        showProgress: _dataHistoricalC != null,
      );
      if (response.status) {
        _dataHistoricalC = baseChartResFromJson(jsonEncode(response.data));
        _errorHistoricalC = null;
      } else {
        _dataHistoricalC = null;
        _errorHistoricalC = response.message;
      }
    } catch (e) {
      _dataHistoricalC = null;
      _errorHistoricalC = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoChart}: $e');
    } finally {
      setStatusHistoricalC(Status.loaded);
    }
  }


  Future getWatchList() async {
    setStatusCrypto(Status.loading);
    try {
      Map request = {
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoWatchList,
        showProgress: false,
        request: request,
      );

      if (response.status) {
        _cryptoWatchRes = cryptoWatchlistResFromJson(jsonEncode(response.data));
      }
      else {
        _cryptoWatchRes = null;
        _error = response.message;
      }
      setStatusCrypto(Status.loaded);
    } catch (e) {
      _cryptoWatchRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoWatchList}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
      setStatusCrypto(Status.loaded);
    }
  }

  CryptoFiatRes? _cryptoFiatRes;
  CryptoFiatRes? get cryptoFiatRes=> _cryptoFiatRes;

  Status _statusFiat = Status.ideal;
  Status get statusFiat => _statusFiat;

  bool get isLoadingFiat => _statusFiat == Status.loading || _statusFiat == Status.ideal;

  setStatusFiat(status) {
    _statusFiat = status;
    notifyListeners();
  }

  final TextEditingController btcController = TextEditingController(text: '1');
  final TextEditingController usdController = TextEditingController();
  Rate? selectedItem;
  Rate? selectedSymbol;
  bool isSwapped = false;
  int isActiveField = 1;

  void clearValues(){
    btcController.text="1";
    usdController.text="";
    selectedItem=null;
    selectedSymbol=null;
    isSwapped=false;
    isActiveField=1;
    notifyListeners();
  }

  void calculateConversion(){
    if (btcController.text.isEmpty) {
      Utils().showLog('btcController is empty, setting USD to 0');
      usdController.text = "0";
      notifyListeners();
      return;
    }

    usdController.text = (((selectedSymbol?.price??0)*(selectedItem?.price??0))*double.parse(btcController.text)).toStringAsFixed(2);
    Utils().showLog('usdController in ${usdController.text}');
    notifyListeners();
  }

  void calculateWithPriceChange(){
    if (usdController.text.isEmpty) {
      Utils().showLog('usdController is empty, setting USD to 0');
      btcController.text = "0";
      notifyListeners();
      return;
    }
    btcController.text = "${(double.parse(usdController.text)/((selectedSymbol?.price??0)*(selectedItem?.price??0)))}";
    Utils().showLog('btcController in ${btcController.text}');
    notifyListeners();
  }

  void swapUI() {
    isSwapped = !isSwapped;
    notifyListeners();
  }
  void isActiveChange(int active) {
    isActiveField = active;
    Utils().showLog('isActiveField in $isActiveField');
    notifyListeners();
  }

  Future getCryptoFiat() async {
    clearValues();
    _cryptoFiatRes = null;
    setStatusFiat(Status.loading);
    try {
      Map request = {};
      ApiResponse response = await apiRequest(
        url: Apis.cryptoFiat,
        showProgress: false,
        request: request,
      );

      if (response.status) {
        _cryptoFiatRes = cryptoFiatResFromMap(jsonEncode(response.data));

        if(_cryptoFiatRes?.cryptoData?.cryptoSymbol!=null && _cryptoFiatRes?.cryptoData?.cryptoSymbol?.isNotEmpty==true){
          selectedSymbol=_cryptoFiatRes?.cryptoData?.cryptoSymbol?.isNotEmpty==true?_cryptoFiatRes?.cryptoData?.cryptoSymbol?.first:null;
        }
        if( _cryptoFiatRes?.cryptoData?.rates!=null &&  _cryptoFiatRes?.cryptoData?.rates?.isNotEmpty==true){
          selectedItem= _cryptoFiatRes?.cryptoData?.rates?.isNotEmpty==true? _cryptoFiatRes?.cryptoData?.rates?.first:null;
        }
        usdController.text = (((selectedSymbol?.price??0)*(selectedItem?.price??0)) * double.parse(btcController.text)).toStringAsFixed(2);
      }
      else {
        _cryptoFiatRes = null;
        _error = response.message;
      }
      setStatusFiat(Status.loaded);
    } catch (e) {
      _cryptoFiatRes = null;
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoFiat}: $e');
      setStatusFiat(Status.loaded);
    }
  }

  List<Rate> searchSymbol=[];
  List<Rate> searchCurrency=[];
  Future getSearchOfSymbol(String searchQuery) async {
    try {
      Map request = {
        "search":searchQuery ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoSearchSymbol,
        showProgress: false,
        request: request,
      );
      if (response.status) {
        searchSymbol = rateResFromMap(jsonEncode(response.data));
        notifyListeners();
      }
      else {
        searchSymbol = [];
        _error = response.message;
      }
    } catch (e) {
      searchSymbol = [];
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoSearchSymbol}: $e');
    }
  }

  Future getSearchOfCurrency(String searchQuery) async {
    try {
      Map request = {
        "search":searchQuery ?? "",
      };
      ApiResponse response = await apiRequest(
        url: Apis.cryptoSearchCurrency,
        showProgress: false,
        request: request,
      );
      if (response.status) {
        searchCurrency = rateResFromMap(jsonEncode(response.data));
        notifyListeners();
      }
      else {
        searchCurrency = [];
        _error = response.message;
      }
    } catch (e) {
      searchCurrency = [];
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.cryptoSearchCurrency}: $e');
    }
  }

  Future requestAddToFav(String twitName,{CryptoTweetPost? profiles}) async {
    try {
      Map request = {
        "twitter_name":twitName
      };
      ApiResponse response = await apiRequest(
        url: Apis.addFav,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        //_billionairesDetailRes?.billionaireInfo?.isFavoritePersonAdded=1;
        profiles?.isFavoritePersonAdded=1;
      }
      else {
        _error = response.message;
      }
      popUpAlert(
        message: response.message ?? Const.errSomethingWrong,
        title: response.status ?"Success":"Alert",
        icon: response.status ?Images.alertTickGIF:Images.alertPopGIF,
      );
      notifyListeners();

    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.addFav}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }
  Future requestRemoveToFav(String twitName,{int? from,CryptoTweetPost? profiles}) async {
    try {
      Map request = {
        "twitter_name":twitName
      };
      ApiResponse response = await apiRequest(
        url: Apis.removeFav,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        if(from==1){
          getWatchList();
        }
        else{
          //_billionairesDetailRes?.billionaireInfo?.isFavoritePersonAdded=0;
          profiles?.isFavoritePersonAdded=0;
        }
      }
      else {
        _error = response.message;

      }
      popUpAlert(
        message: response.message ?? Const.errSomethingWrong,
        title: response.status ?"Success":"Alert",
        icon: response.status ?Images.alertTickGIF:Images.alertPopGIF,
      );
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.removeFav}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }

  Future requestAddToWatch(String symbol, {BaseTickerRes? cryptos}) async {
    try {
      Map request = {
        "symbol":symbol
      };
      ApiResponse response = await apiRequest(
        url: Apis.addWatch,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        cryptos?.isCryptoAdded=1;
        // _cryptoDetailRes?.cryptoInfo?.isCryptoAdded=1;
      }
      else {
        _error = response.message;
      }
      popUpAlert(
        message: response.message ?? Const.errSomethingWrong,
        title: response.status ?"Success":"Alert",
        icon: response.status ?Images.alertTickGIF:Images.alertPopGIF,
      );
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.addWatch}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }
  Future requestRemoveToWatch(String symbol, {BaseTickerRes? cryptos}) async {
    try {
      Map request = {
        "symbol":symbol
      };
      ApiResponse response = await apiRequest(
        url: Apis.removeWatch,
        showProgress: true,
        request: request,
      );
      if (response.status) {
        cryptos?.isCryptoAdded=0;
        //  _cryptoDetailRes?.cryptoInfo?.isCryptoAdded=0;
      }
      else {
        _error = response.message;

      }
      popUpAlert(
        message: response.message ?? Const.errSomethingWrong,
        title: response.status ?"Success":"Alert",
        icon: response.status ?Images.alertTickGIF:Images.alertPopGIF,
      );
      notifyListeners();
    } catch (e) {
      _error = Const.errSomethingWrong;
      Utils().showLog('Error in ${Apis.removeWatch}: $e');
      TopSnackbar.show(
        message: Const.errSomethingWrong,
        type: ToasterEnum.error,
      );
    }
  }


  int? selectedScreen=-1;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      notifyListeners();
      switch (selectedScreen) {
        case 0:
          getCryptoCurrencies();
          break;

        case 1:
          getWatchList();
          break;

        case 2:
          clearValues();
          getCryptoFiat();
          break;
        default:
      }
      }
    }


  int? selectedInnerScreen=0;
  onScreenChangeInner(index) {
    if (selectedInnerScreen != index) {
      selectedInnerScreen = index;
      notifyListeners();
    }
  }
}