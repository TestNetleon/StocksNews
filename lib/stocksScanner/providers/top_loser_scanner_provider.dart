import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/stocksScanner/apis/top_loser_scanner_manager.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:http/http.dart' as http;

class TopLoserScannerProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  List<ScannerRes>? _offlineDataList;
  List<ScannerRes>? get offlineDataList => _offlineDataList;

  List<MarketScannerRes>? _dataList;
  List<MarketScannerRes>? get dataList => _dataList;

  Extra? _extra;
  Extra? get extra => _extra;

  // int? get page => _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    notifyListeners();
    TopLoserScannerDataManager.initializePorts();
  }

  void stopListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    TopLoserScannerDataManager.stopListeningPorts();
  }

  Future getOfflineData({showProgress = false}) async {
    showGlobalProgressDialog();
    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/topLoser?shortBy=2',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utils().showLog("$url");
        Utils().showLog(response.body);
        // _dataList = scannerResFromJson(jsonDecode(response.body));
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        _offlineDataList = scannerResFromJson(decodedResponse);
      } else {
        Utils().showLog('Error fetching data from $url');
      }
    } catch (err) {
      Utils().showLog('Error: $err');
    }
    closeGlobalProgressDialog();
    notifyListeners();
  }

  void updateOfflineData(List<ScannerRes>? data) {
    _offlineDataList = data;
    notifyListeners();
  }

  Future updateData(List<MarketScannerRes>? data) async {
    if (data == null) return;

    List<MarketScannerRes> prChangeAr = [];

    for (var item in data) {
      if (item.identifier != null) {
        int volume = item.volume ?? 0;
        String extendedHoursType = item.extendedHoursType ?? "";
        double lastTrade = item.last ?? 0;

        // Perform specific logic based on conditions
        if (volume == 0) continue; // Skip if volume is 0

        // Check if ExtendedHoursType is "PostMarket" or "PreMarket"
        if (extendedHoursType == "PostMarket" ||
            extendedHoursType == "PreMarket") {
          if ((volume * (item.extendedHoursPrice ?? 0)) < 100000) {
            continue; // Skip if conditions are met
          }
        } else {
          if ((volume * lastTrade) < 100000) {
            continue; // Skip if conditions are met
          }
        }

        prChangeAr.add(item);
      } else {
        debugPrint("Invalid item or missing Identifier: $item");
      }
    }

    if (_dataList != null) {
      // prChangeAr.addAll(_dataList!);
      for (var dataItem in _dataList!) {
        // Check if identifier is already in prChangeAr
        bool exists =
            prChangeAr.any((entry) => entry.identifier == dataItem.identifier);

        // Only add the new item if its identifier doesn't already exist
        if (!exists) {
          prChangeAr.add(dataItem);
        }
      }
    }

    // Sort the array based on `shortIndex`
    prChangeAr.sort((a, b) {
      double valueA = a.percentChange ?? 0;
      if (a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket") {
        valueA = a.extendedHoursPercentChange ?? 0;
      }
      double valueB = b.percentChange ?? 0;
      if (b.extendedHoursType == "PostMarket" ||
          b.extendedHoursType == "PreMarket") {
        valueB = b.extendedHoursPercentChange ?? 0;
      }
      return valueA.compareTo(valueB);
    });

    _dataList = prChangeAr.take(50).toList();
    notifyListeners();
  }
}
