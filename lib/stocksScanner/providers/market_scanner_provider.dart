import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/stocksScanner/apis/market_scanner_manager.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:http/http.dart' as http;

class MarketScannerProvider extends ChangeNotifier {
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

  String? _marketStatus;
  String? get marketStatus => _marketStatus;
  // int? get page => _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    notifyListeners();
    MarketScannerDataManager.initializePorts();
  }

  void stopListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    MarketScannerDataManager.stopListeningPorts();
  }

  Future getOfflineData({showProgress = false}) async {
    showGlobalProgressDialog();
    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/getScreener?sector=Basic Materials',
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

  void updateData(List<MarketScannerRes>? data) {
    Utils().showLog("Updating data .... ${data?.length}");

    if (data == null) return;
    // _marketStatus = data[0].extendedHoursType;

    // Remove items based on conditions
    data.removeWhere((item) {
      if (item.identifier == "LIN") {
        Utils().showLog("SYMBOL  =>>>>>>>>>>>>>> ${item.identifier}");
      }

      if (item.sector == "Basic Materials") {
        double lastTrade = (item.last ?? 0);

        if (item.extendedHoursType == "PostMarket" ||
            item.extendedHoursType == "PreMarket") {
          lastTrade = item.extendedHoursPrice ?? 0;
        }

        if (lastTrade == 0) {
          return true;
        }

        if (item.volume == 0) {
          return true; // Remove if volume is 0
        }

        if (item.extendedHoursType == "PostMarket" ||
            item.extendedHoursType == "PreMarket") {
          // Remove if volume * extendedHoursPrice is less than 100000 in Extended Hours
          if ((item.volume ?? 0) * (item.extendedHoursPrice ?? 0) < 100000) {
            return true;
          }
        } else {
          // Remove if volume * last is less than 100000 in regular hours
          if ((item.volume ?? 0) * (item.last ?? 0) < 100000) {
            return true;
          }
        }
        return false; // Keep the item if none of the conditions matched
      } else {
        return true; //remove
      }
    });

    Utils().showLog("FILTERDE  =>>>>>>>>>>>>>> ${_dataList?.length}");

    if (_dataList == null) {
      _dataList = List.empty(growable: true);
      _dataList!.addAll(data);
      notifyListeners();
    } else {
      for (var newItem in data) {
        // Check if the item already exists based on the identifier
        int index = _dataList!
            .indexWhere((item) => item.identifier == newItem.identifier);

        if (index != -1) {
          // If the item exists, update it
          _dataList![index] = newItem;
        } else {
          // If the item does not exist, add it to the top of the list
          _dataList!.insert(0, newItem); // Insert at the top
        }
      }
    }
    // Update the data list after removal
    // _dataList = data;

    Utils().showLog("Current length =>>>>>>>>>>>>>> ${_dataList?.length}");

    // Notify listeners to update UI
    notifyListeners();
  }
}
