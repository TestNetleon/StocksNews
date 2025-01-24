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

import '../modals/ports.dart';

class MarketScannerProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  List<String> tableHeader = [
    "Company Name",
    "Sector",
    "Bid",
    "Ask",
    "Last Trade",
    "Net Change",
    "% Change",
    "Volume",
    "\$ Volume"
  ];

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  List<ScannerRes>? _fullOfflineDataList;
  List<ScannerRes>? _offlineDataList;
  List<ScannerRes>? get offlineDataList => _offlineDataList;

  List<MarketScannerRes>? _fullDataList;
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

  int _scannerIndex = 1;
  int get scannerIndex => _scannerIndex;
  // int? get page => _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() async {
    _offlineDataList = null;
    _dataList = null;
    _visible = true;
    _filterParams = null;
    _filterParams = FilterParams(
      sector: "Consumer Cyclical",
      // sortBy: "% Change",
      // sortByAsc: false,
    );
    notifyListeners();

    MarketScannerDataManager.instance.initializePorts();
  }

  void stopListeningPorts() {
    _visible = false;
    notifyListeners();
    _offlineDataList = null;
    _dataList = null;
    _filterParams = null;
    MarketScannerDataManager.instance.stopListeningPorts();
    notifyListeners();
  }

  Future getOfflineData({showProgress = false}) async {
    showGlobalProgressDialog();
    try {
      final url = Uri.parse(
        'https://dev.stocks.news:8080/getScreener?sector=Consumer Cyclical',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Utils().showLog("$url");
        Utils().showLog(response.body);
        // _dataList = scannerResFromJson(jsonDecode(response.body));
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        _offlineDataList = scannerResFromJson(decodedResponse);
        _fullOfflineDataList = List.empty(growable: true);
        _fullOfflineDataList?.addAll(_offlineDataList ?? []);
        _offlineDataList = _offlineDataList?.take(50).toList();
        Utils().showLog("LENGTH => ${_offlineDataList?.length}");
        notifyListeners();
      } else {
        Utils().showLog('Error fetching data from $url');
      }
    } catch (err) {
      Utils().showLog('Error: $err');
    }
    closeGlobalProgressDialog();
    // notifyListeners();
  }

  void updateOfflineData(List<ScannerRes>? data, {applyFilter = false}) {
    if (!applyFilter) {
      if (_fullOfflineDataList == null && data != null) {
        _fullOfflineDataList = List.empty(growable: true);
        _fullOfflineDataList?.addAll(data);
      }
      _offlineDataList = data?.take(50).toList();
    } else {
      if (_fullOfflineDataList == null && data != null) {
        _fullOfflineDataList = List.empty(growable: true);
        _fullOfflineDataList?.addAll(data);
      }
      List<ScannerRes>? list = List.empty(growable: true);
      list.addAll(data!);
      updateOfflineDataFilter(list);
    }
    notifyListeners();
  }

  void updateOfflineDataFilter(List<ScannerRes>? data) {
    if (data == null) return;

    data.removeWhere((item) {
      print('item bid ${item.bid}');

      if (item.identifier == _filterParams!.symbolCompany) {
        Utils().showLog(
          "***********************************************************${item.identifier}  ${_filterParams!.symbolCompany}",
        );
        Utils().showLog(
          " ===>>>> ******** ${item.sector}  ${_filterParams?.sector} ${item.sector == (_filterParams?.sector ?? "Consumer Cyclical")}",
        );
      }
      if (item.sector == (_filterParams?.sector ?? "Consumer Cyclical")) {
        num lastTrade = (item.price ?? 0);
        if (lastTrade == 0) {
          return true;
        }
        if (item.volume == 0) {
          return true;
        }

        if (_filterParams == null) return false;

        // If any filter fails, return true to remove the item
        bool visible = isVisibleOffline(item, _filterParams!);
        return !visible;
      } else {
        return true;
      }
    });

    Utils().showLog("Filtered data length => ${data.length}");

    // if (_offlineDataList == null) {
    //   _offlineDataList = List.empty(growable: true);
    //   _offlineDataList!.addAll(data);
    //   notifyListeners();
    // } else {
    //   for (var newItem in data) {
    //     // Check if the item already exists based on the identifier
    //     int index = _offlineDataList!
    //         .indexWhere((item) => item.identifier == newItem.identifier);
    //     if (index != -1) {
    //       // If the item exists, update it
    //       _offlineDataList![index] = newItem;
    //     } else {
    //       // If the item does not exist, add it to the top of the list
    //       _offlineDataList!.insert(0, newItem); // Insert at the top
    //     }
    //   }
    // }

    _offlineDataList = data.take(50).toList();

    if (_filterParams?.sortBy != null) {
      _offlineDataList?.sort((a, b) {
        return sortByCompareOffline(
          a,
          b,
          _filterParams?.sortBy ?? "",
          _filterParams?.sortByAsc ?? false,
        );
      });
    }

    // Notify listeners to update UI
    notifyListeners();
  }

  bool isVisibleOffline(ScannerRes item, FilterParams filterParams) {
    num lastTrade = item.price ?? 0;
    num netChange = item.change ?? 0;
    num percentChange = item.changesPercentage ?? 0;
    num volume = item.volume ?? 0;
    num dollarVolume = (volume * lastTrade);

    // Bid Range Conditions
    bool bidStartCondition = filterParams.bidStart == null ||
        (item.bid ?? 0) >= filterParams.bidStart!;
    bool bidEndCondition =
        filterParams.bidEnd == null || (item.bid ?? 0) <= filterParams.bidEnd!;

    // Ask Range Conditions
    bool askStartCondition = filterParams.askStart == null ||
        (item.ask ?? 0) >= filterParams.askStart!;
    bool askEndCondition =
        filterParams.askEnd == null || (item.ask ?? 0) <= filterParams.askEnd!;

    // Last Trade Range Conditions
    bool lastTradeStartCondition = filterParams.lastTradeStart == null ||
        lastTrade >= filterParams.lastTradeStart!;
    bool lastTradeEndCondition = filterParams.lastTradeEnd == null ||
        lastTrade <= filterParams.lastTradeEnd!;

    // Net Change Range Conditions
    bool netChangeStartCondition = filterParams.netChangeStart == null ||
        netChange >= filterParams.netChangeStart!;
    bool netChangeEndCondition = filterParams.netChangeEnd == null ||
        netChange <= filterParams.netChangeEnd!;

    // Percent Change Range Conditions
    bool percentChangeStartCondition = filterParams.perChangeStart == null ||
        percentChange >= filterParams.perChangeStart!;
    bool percentChangeEndCondition = filterParams.perChangeEnd == null ||
        percentChange <= filterParams.perChangeEnd!;

    // Volume Range Conditions
    bool volumeStartCondition =
        filterParams.volumeStart == null || volume >= filterParams.volumeStart!;
    bool volumeEndCondition =
        filterParams.volumeEnd == null || volume <= filterParams.volumeEnd!;

    // Dollar Volume Range Conditions
    bool dollarVolumeStartCondition = filterParams.dolorVolumeStart == null ||
        dollarVolume >= filterParams.dolorVolumeStart!;
    bool dollarVolumeEndCondition = filterParams.dolorVolumeEnd == null ||
        dollarVolume <= filterParams.dolorVolumeEnd!;

    // Sector Condition
    bool sectorCondition =
        filterParams.sector == null || item.sector == filterParams.sector;

    // Symbol Condition (case-insensitive check)
    bool symbolCondition = filterParams.symbolCompany == null ||
        item.identifier
            .toLowerCase()
            .contains(filterParams.symbolCompany!.toLowerCase());

    bool nameCondition = filterParams.symbolCompany == null ||
        item.name
            .toLowerCase()
            .contains(filterParams.symbolCompany!.toLowerCase());

    // Combine all conditions using logical AND (&&)
    return bidStartCondition &&
        bidEndCondition &&
        askStartCondition &&
        askEndCondition &&
        lastTradeStartCondition &&
        lastTradeEndCondition &&
        netChangeStartCondition &&
        netChangeEndCondition &&
        percentChangeStartCondition &&
        percentChangeEndCondition &&
        volumeStartCondition &&
        volumeEndCondition &&
        dollarVolumeStartCondition &&
        dollarVolumeEndCondition &&
        sectorCondition &&
        (symbolCondition || nameCondition);
  }

  void updateData(List<MarketScannerRes>? data) {
    if (data == null) return;

    data.removeWhere((item) {
      if (item.sector == (_filterParams?.sector ?? "Consumer Cyclical")) {
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

        // HERE
        // bool visible = isVisible(item, _filterParams!);
        // return !visible;

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
        // if (_filterParams?.sector != null) {
        //   if (!(item.sector == _filterParams!.sector)) {
        //     shouldRemove = true;
        //   }
        // }

        // If any filter fails, return true to remove the item
        return shouldRemove;
      } else {
        return true;
      }
    });

    storeFullLiveData(data);

    if (_dataList == null || _dataList?.isEmpty == true) {
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
          if (_filterParams?.sortBy != null) {
            _dataList!.insert(0, newItem); // Insert at the top
          } else {
            _dataList!
                .insert(_dataList!.length - 1, newItem); // Insert at the last
          }
        }
      }
    }

    if (_filterParams?.sortBy != null) {
      _dataList?.sort((a, b) {
        return sortByCompare(
          a,
          b,
          _filterParams?.sortBy ?? "",
          _filterParams?.sortByAsc ?? false,
        );
      });
    }

    // _dataList = _dataList!.take(50).toList();

    // Notify listeners to update UI
    notifyListeners();
  }

  void storeFullLiveData(List<MarketScannerRes>? data) async {
    if (_fullDataList == null) {
      _fullDataList = data;
      return;
    } else {
      if (data != null && data.isNotEmpty) {
        // Iterate over the new data list
        for (var newItem in data) {
          // Find if an item with the same identifier exists in the list

          int index = _fullDataList!.indexWhere(
              (existingItem) => existingItem.identifier == newItem.identifier);

          if (index != -1) {
            // If the item exists (index != -1), replace the existing one
            _fullDataList![index] = newItem;
          } else {
            // If the item doesn't exist, add the new item
            _fullDataList!.add(newItem);
          }
        }
      }
    }
  }

  int sortByCompare(
      MarketScannerRes a, MarketScannerRes b, String sortBy, bool isAsc) {
    if (sortBy == "Symbol") {
      if (a.identifier == null && b.identifier == null) return 0;
      if (a.identifier == null) return -1;
      if (b.identifier == null) return 1;
      if (isAsc) {
        return a.identifier!.compareTo(b.identifier!);
      } else {
        return b.identifier!.compareTo(a.identifier!);
      }
    } else if (sortBy == "Company Name") {
      if (a.security?.name == null && b.security?.name == null) return 0;
      if (a.security?.name == null) return -1;
      if (b.security?.name == null) return 1;
      if (isAsc) {
        return a.security!.name!.compareTo(b.security!.name!);
      } else {
        return b.security!.name!.compareTo(a.security!.name!);
      }
    } else if (sortBy == "Bid") {
      if (a.bid == null && b.bid == null) return 0;
      if (a.bid == null) return -1;
      if (b.bid == null) return 1;
      if (isAsc) {
        return a.bid!.compareTo(b.bid!);
      } else {
        return b.bid!.compareTo(a.bid!);
      }
    } else if (sortBy == "Ask") {
      if (a.ask == null && b.ask == null) return 0;
      if (a.ask == null) return -1;
      if (b.ask == null) return 1;
      if (isAsc) {
        return a.ask!.compareTo(b.ask!);
      } else {
        return b.ask!.compareTo(a.ask!);
      }
    } else if (sortBy == "Last Trade") {
      num? valueA = a.last;
      num? valueB = b.last;
      if (a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket") {
        valueA = a.extendedHoursPrice ?? 0;
        valueB = b.extendedHoursPrice ?? 0;
      }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == "Net Change") {
      num? valueA = a.change;
      num? valueB = b.change;
      if (a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket") {
        valueA = a.extendedHoursChange ?? 0;
        valueB = b.extendedHoursChange ?? 0;
      }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == "% Change") {
      num? valueA = a.percentChange;
      num? valueB = b.percentChange;
      if (a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket") {
        valueA = a.extendedHoursPercentChange ?? 0;
        valueB = b.extendedHoursPercentChange ?? 0;
      }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == "Volume") {
      if (a.volume == null && b.volume == null) return 0;
      if (a.volume == null) return -1;
      if (b.volume == null) return 1;
      if (isAsc) {
        return a.volume!.compareTo(b.volume!);
      } else {
        return b.volume!.compareTo(a.volume!);
      }
    } else if (sortBy == "\$ Volume") {
      num dolorVolumeA = (a.volume ?? 0) * (a.volume ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.volume ?? 0);
      if (isAsc) {
        return dolorVolumeA.compareTo(dolorVolumeB);
      } else {
        return dolorVolumeB.compareTo(dolorVolumeA);
      }
    }
    return 0;
  }

  int sortByCompareOffline(
      ScannerRes a, ScannerRes b, String sortBy, bool isAsc) {
    if (sortBy == "Symbol") {
      if (a.identifier == null && b.identifier == null) return 0;
      if (a.identifier == null) return -1;
      if (b.identifier == null) return 1;
      if (isAsc) {
        return a.identifier!.compareTo(b.identifier!);
      } else {
        return b.identifier!.compareTo(a.identifier!);
      }
    }
    if (sortBy == "Company Name") {
      if (a.name == null && b.name == null) return 0;
      if (a.name == null) return -1;
      if (b.name == null) return 1;
      if (isAsc) {
        return a.name!.compareTo(b.name!);
      } else {
        return b.name!.compareTo(a.name!);
      }
    }
    if (sortBy == "Bid") {
      if (a.bid == null && b.bid == null) return 0;
      if (a.bid == null) return -1;
      if (b.bid == null) return 1;
      if (isAsc) {
        return a.bid!.compareTo(b.bid!);
      } else {
        return b.bid!.compareTo(a.bid!);
      }
    }
    if (sortBy == "Ask") {
      if (a.ask == null && b.ask == null) return 0;
      if (a.ask == null) return -1;
      if (b.ask == null) return 1;
      if (isAsc) {
        return a.ask!.compareTo(b.ask!);
      } else {
        return b.ask!.compareTo(a.ask!);
      }
    }
    if (sortBy == "Last Trade") {
      if (a.price == null && b.price == null) return 0;
      if (a.price == null) return -1;
      if (b.price == null) return 1;
      if (isAsc) {
        return a.price!.compareTo(b.price!);
      } else {
        return b.price!.compareTo(a.price!);
      }
    }
    if (sortBy == "Post Market Price") {
      if (a.ext?.extendedHoursPrice == null &&
          b.ext?.extendedHoursPrice == null) {
        return 0;
      }
      if (a.ext?.extendedHoursPrice == null) return -1;
      if (b.ext?.extendedHoursPrice == null) return 1;
      if (isAsc) {
        return a.ext?.extendedHoursPrice!.compareTo(b.ext?.extendedHoursPrice!);
      } else {
        return b.ext?.extendedHoursPrice!.compareTo(a.ext?.extendedHoursPrice!);
      }
    }

    if (sortBy == "Net Change") {
      if (a.change == null && b.change == null) return 0;
      if (a.change == null) return -1;
      if (b.change == null) return 1;
      if (isAsc) {
        return a.change!.compareTo(b.change!);
      } else {
        return b.change!.compareTo(a.change!);
      }
    }
    if (sortBy == "% Change") {
      if (a.changesPercentage == null && b.changesPercentage == null) return 0;
      if (a.changesPercentage == null) return -1;
      if (b.changesPercentage == null) return 1;
      if (isAsc) {
        return a.changesPercentage!.compareTo(b.changesPercentage!);
      } else {
        return b.changesPercentage!.compareTo(a.changesPercentage!);
      }
    }
    if (sortBy == "Volume") {
      if (a.volume == null && b.volume == null) return 0;
      if (a.volume == null) return -1;
      if (b.volume == null) return 1;
      if (isAsc) {
        return a.volume!.compareTo(b.volume!);
      } else {
        return b.volume!.compareTo(a.volume!);
      }
    }
    if (sortBy == "\$ Volume") {
      num dolorVolumeA = (a.volume ?? 0) * (a.volume ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.volume ?? 0);
      if (isAsc) {
        return dolorVolumeA.compareTo(dolorVolumeB);
      } else {
        return dolorVolumeB.compareTo(dolorVolumeA);
      }
    }
    return 0;
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

  void applySorting(String sortBy) {
    if (sortBy == _filterParams?.sortBy) {
      _filterParams?.sortByAsc = !(_filterParams?.sortByAsc ?? true);
    } else {
      _filterParams?.sortBy = sortBy;
      _filterParams?.sortByAsc = true;
    }

    if (MarketScannerDataManager.instance.isListening) {
      MarketScannerDataManager.instance.stopListeningPorts();
    }

    if (_dataList != null) {
      // notifyListeners();
      updateData(_fullDataList);
    } else if (_offlineDataList != null) {
      // _offlineDataList = null;
      updateOfflineData(_fullOfflineDataList, applyFilter: true);
    }
  }

  void applyFilter(FilterParams params) {
    if (_dataList != null) {
      _filterParams = params;
      Utils().showLog("----");
      _dataList = null;
      _offlineDataList = null;
      _fullOfflineDataList = null;
      notifyListeners();
      // MarketScannerDataManager.instance.initializePorts();
      updateData(_fullDataList);
    } else if (_offlineDataList != null) {
      if (params.sector != _filterParams?.sector) {
        _filterParams = params;
        MarketScannerDataManager.instance.getOfflineData();
      } else {
        _filterParams = params;
        updateOfflineData(_fullOfflineDataList, applyFilter: true);
      }
    } else {
      _filterParams = params;
      notifyListeners();
    }
  }

  void clearFilter() {
    _filterParams = FilterParams(sector: "Consumer Cyclical");
    if (_offlineDataList != null && _fullOfflineDataList != null) {
      _offlineDataList = _fullOfflineDataList;
      _offlineDataList = _offlineDataList?.take(50).toList();
    }
    MarketScannerDataManager.instance.getOfflineData();
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

  // Future getScannerType({showProgress = false, loadMore = false}) async {
  //   setStatus(Status.loading);
  //   try {
  //     Map request = {
  //       "token":
  //           navigatorKey.currentContext!.read<UserProvider>().user?.token ?? "",
  //     };
  //     ApiResponse response = await apiRequest(
  //       url: Apis.stockScannerChange,
  //       request: request,
  //       showProgress: false,
  //     );

  //     if (response.status) {
  //       _scannerIndex = response.data['webviewStatus'];
  //     } else {
  //       // _error = response.message;
  //     }
  //     setStatus(Status.loaded);
  //   } catch (e) {
  //     Utils().showLog(e.toString());
  //     setStatus(Status.loaded);
  //   }
  // }

//MARK: Scanner Ports

  ScannerPortsRes? _port;
  ScannerPortsRes? get port => _port;

  Future getScannerPorts({loading = true}) async {
    setStatus(Status.loading);
    try {
      ApiResponse response = await apiRequest(
        url: Apis.stockScannerPort,
        showProgress: loading,
      );
      if (response.status) {
        _port = scannerPortsResFromJson(jsonEncode(response.data));

        startListeningPorts();
      } else {
        _port = null;
      }
      setStatus(Status.loaded);
      return ApiResponse(
        status: response.status,
        data: _port,
      );
    } catch (e) {
      _port = null;
      setStatus(Status.loaded);
      return ApiResponse(status: false);
    }
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
  String? sortBy;
  bool? sortByAsc;

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
    this.sortBy,
    this.sortByAsc,
  });
}
