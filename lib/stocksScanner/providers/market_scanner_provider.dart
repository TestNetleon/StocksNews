import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_requester.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/api/apis.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/stocksScanner/apis/market_scanner_manager.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/sectors_res.dart';
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

  List<String>? _sectors;
  List<String>? get sectors => _sectors;

  FilterParams? _filterParams;
  FilterParams? get filterParams => _filterParams;

  Extra? _extra;
  Extra? get extra => _extra;

  String? _marketStatus;
  String? get marketStatus => _marketStatus;

  bool _visible = false;
  bool get visible => _visible;
  // int? get page => _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    _visible = true;
    _filterParams = null;
    _filterParams = FilterParams(sector: "Healthcare");
    notifyListeners();
    MarketScannerDataManager.initializePorts();
  }

  void stopListeningPorts() {
    _visible = false;
    _offlineDataList = null;
    _dataList = null;
    _filterParams = null;
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
    if (data == null) return;
    data.removeWhere((item) {
      if (item.sector == (_filterParams?.sector ?? "Healthcare")) {
        double lastTrade = (item.last ?? 0);
        if (item.extendedHoursType == "PostMarket" ||
            item.extendedHoursType == "PreMarket") {
          lastTrade = item.extendedHoursPrice ?? 0;
        }
        if (lastTrade == 0) {
          return true;
        }
        if (item.volume == 0) {
          return true;
        }
        if (item.extendedHoursType == "PostMarket" ||
            item.extendedHoursType == "PreMarket") {
          if ((item.volume ?? 0) * (item.extendedHoursPrice ?? 0) < 100000) {
            return true;
          }
        } else {
          if ((item.volume ?? 0) * (item.last ?? 0) < 100000) {
            return true;
          }
        }

        if (_filterParams == null) return false;

        // Return false (item is not removed) if the item passes all filter conditions
        bool shouldRemove = false;

        // Apply filter for bid range (bidStart <= item.bid <= bidEnd)
        if (_filterParams?.bidStart != null && _filterParams?.bidEnd != null) {
          if (!(item.bid! >= _filterParams!.bidStart! &&
              item.bid! <= _filterParams!.bidEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.bidStart != null) {
          if (!(item.bid! >= _filterParams!.bidStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.bidEnd != null) {
          if (!(item.bid! <= _filterParams!.bidEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for ask range (askStart <= item.ask <= askEnd)
        if (_filterParams?.askStart != null && _filterParams?.askEnd != null) {
          if (!(item.ask! >= _filterParams!.askStart! &&
              item.ask! <= _filterParams!.askEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.askStart != null) {
          if (!(item.ask! >= _filterParams!.askStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.askEnd != null) {
          if (!(item.ask! <= _filterParams!.askEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for percentChange range
        if (_filterParams?.perChangeStart != null &&
            _filterParams?.perChangeEnd != null) {
          if (!(item.percentChange! >= _filterParams!.perChangeStart! &&
              item.percentChange! <= _filterParams!.perChangeEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.perChangeStart != null) {
          if (!(item.percentChange! >= _filterParams!.perChangeStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.perChangeEnd != null) {
          if (!(item.percentChange! <= _filterParams!.perChangeEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for volume range
        if (_filterParams?.volumeStart != null &&
            _filterParams?.volumeEnd != null) {
          if (!(item.volume! >= _filterParams!.volumeStart! &&
              item.volume! <= _filterParams!.volumeEnd!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.volumeStart != null) {
          if (!(item.volume! >= _filterParams!.volumeStart!)) {
            shouldRemove = true;
          }
        } else if (_filterParams?.volumeEnd != null) {
          if (!(item.volume! <= _filterParams!.volumeEnd!)) {
            shouldRemove = true;
          }
        }

        // Apply filter for symbolCompany
        if (_filterParams?.symbolCompany != null) {
          if (!(item.identifier
                  ?.toLowerCase()
                  .contains(_filterParams!.symbolCompany!.toLowerCase()) ??
              false)) {
            shouldRemove = true;
          }
        }

        // Apply filter for sector
        if (_filterParams?.sector != null) {
          if (!(item.sector == _filterParams!.sector)) {
            shouldRemove = true;
          }
        }

        // If any filter fails, return true to remove the item
        return shouldRemove;
      } else {
        return true;
      }
    });
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

    _dataList!.take(50).toList();
    // Notify listeners to update UI
    notifyListeners();
  }

  Future getSectors({showProgress = false}) async {
    setStatus(Status.loading);
    try {
      Map request = {
        "token":
            navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
      };

      ApiResponse response = await apiRequest(
        url: Apis.trendingSectors,
        request: request,
        showProgress: showProgress,
      );

      if (response.status) {
        _error = null;
        _sectors = sectorsResFromJson(jsonEncode(response.data));
      } else {
        _sectors = null;
        _error = response.message;
      }
      setStatus(Status.loaded);
    } catch (e) {
      // _data = null;
      Utils().showLog(e.toString());
      setStatus(Status.loaded);
    }
  }

  void applyFilter(FilterParams params) {
    _filterParams = params;
    notifyListeners();
  }

  void clearFilter() {
    _filterParams = FilterParams(sector: "Healthcare");
    notifyListeners();
  }

  bool isFilterApplied() {
    if (_filterParams == null) return false;

    if (_filterParams?.bidStart != null) {
      return true;
    }
    if (_filterParams?.bidEnd != null) {
      return true;
    }
    if (_filterParams?.askStart != null) {
      return true;
    }
    if (_filterParams?.askEnd != null) {
      return true;
    }
    if (_filterParams?.lastTradeStart != null) {
      return true;
    }
    if (_filterParams?.lastTradeEnd != null) {
      return true;
    }
    if (_filterParams?.netChangeStart != null) {
      return true;
    }
    if (_filterParams?.netChangeEnd != null) {
      return true;
    }
    if (_filterParams?.perChangeStart != null) {
      return true;
    }
    if (_filterParams?.perChangeEnd != null) {
      return true;
    }
    if (_filterParams?.volumeStart != null) {
      return true;
    }
    if (_filterParams?.volumeEnd != null) {
      return true;
    }
    if (_filterParams?.volumeEnd != null) {
      return true;
    }
    if (_filterParams?.dolorVolumeStart != null) {
      return true;
    }
    if (_filterParams?.dolorVolumeEnd != null) {
      return true;
    }
    if (_filterParams?.sector != null) {
      return true;
    }
    if (_filterParams?.symbolCompany != null) {
      return true;
    }
    return false;
  }
}

class FilterParams {
  double? bidStart, bidEnd;
  double? askStart, askEnd;
  double? lastTradeStart, lastTradeEnd;
  double? netChangeStart, netChangeEnd;
  double? perChangeStart, perChangeEnd;
  double? volumeStart, volumeEnd;
  double? dolorVolumeStart, dolorVolumeEnd;
  String? sector;
  String? symbolCompany;

  FilterParams({
    this.bidStart,
    this.bidEnd,
    this.askStart,
    this.askEnd,
    this.lastTradeStart,
    this.lastTradeEnd,
    this.netChangeStart,
    this.netChangeEnd,
    this.perChangeStart,
    this.perChangeEnd,
    this.volumeStart,
    this.volumeEnd,
    this.dolorVolumeStart,
    this.dolorVolumeEnd,
    this.sector,
    this.symbolCompany,
  });
}
