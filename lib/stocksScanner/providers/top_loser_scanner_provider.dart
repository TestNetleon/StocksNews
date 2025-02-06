import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/stocksScanner/modals/filter_params_gaienr_loser.dart';
import 'package:stocks_news_new/stocksScanner/modals/market_scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../manager/losers_stream.dart';
import '../screens/sorting/shorting.dart';

class TopLoserScannerProvider extends ChangeNotifier {
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  // List<ScannerRes>? _fullOfflineDataList;
  List<ScannerRes>? _offlineDataList;
  List<ScannerRes>? get offlineDataList => _offlineDataList;

  // List<MarketScannerRes>? _fullDataList;
  List<MarketScannerRes>? _dataList;
  List<MarketScannerRes>? get dataList => _dataList;

  FilterParamsGainerLoser? _filterParams = FilterParamsGainerLoser(
    sortBy: 2,
    sortByAsc: true,
    sortByHeader: SortByEnums.perChange.name,
  );
  // FilterParamsGainerLoser? _filterParams;
  FilterParamsGainerLoser? get filterParams => _filterParams;

  Extra? _extra;
  Extra? get extra => _extra;

  // int? get page => _page;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() {
    _offlineDataList = null;
    // _fullOfflineDataList = null;
    _dataList = null;
    notifyListeners();
    MarketLosersStream().initializePorts();
  }

  void stopListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    MarketLosersStream().stopListeningPorts();
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

  void updateOfflineData(List<ScannerRes>? data, {applyFilter = false}) {
    // Utils().showLog("Length %%% => ${data?.length}");
    // _offlineDataList = data;
    // notifyListeners();

    // if (!applyFilter) {
    //   if (_fullOfflineDataList == null && data != null) {
    //     _fullOfflineDataList = List.empty(growable: true);
    //     _fullOfflineDataList?.addAll(data);
    //   }
    //   _offlineDataList = data?.toList();
    // } else {
    // if (_fullOfflineDataList == null && data != null) {
    // if (data != null) {
    //   _fullOfflineDataList = List.empty(growable: true);
    //   _fullOfflineDataList?.addAll(data);
    // }
    // List<ScannerRes>? list = List.empty(growable: true);
    // list.addAll(data!);
    updateOfflineDataFilter(data);
    // }
    notifyListeners();
  }

  void updateOfflineDataFilter(List<ScannerRes>? data) {
    Utils().showLog("Length => ${data?.length}");
    if (data == null) return;

    if (_filterParams == null) {
      // _offlineDataList = data.take(50).toList();
      // _offlineDataList = data.toList();
      _offlineDataList = List.empty(growable: true);
      _offlineDataList?.addAll(data);
      notifyListeners();
      return;
    }

    if (_filterParams?.sortBy == 2) {
      data.sort((a, b) {
        num valueA = a.changesPercentage ?? 0;
        num valueB = b.changesPercentage ?? 0;
        if (_filterParams?.sortByAsc == true) {
          return valueB.compareTo(valueA);
        }
        return valueA.compareTo(valueB);
      });
    }

    if (_filterParams?.sortBy == 3) {
      data.sort((a, b) {
        num valueA = a.volume ?? 0;
        num valueB = b.volume ?? 0;
        if (_filterParams?.sortByAsc == true) {
          return valueB.compareTo(valueA);
        }
        return valueA.compareTo(valueB);
      });
    }

    if (_filterParams?.sortByHeader != null) {
      data.sort((a, b) {
        return sortByCompareOffline(
          a,
          b,
          _filterParams?.sortByHeader ?? "",
          _filterParams?.sortByAsc ?? true,
        );
      });
    }

    // _offlineDataList = data.take(50).toList();
    _offlineDataList = List.empty(growable: true);
    _offlineDataList?.addAll(data);
    // Notify listeners to update UI
    notifyListeners();
  }

  // void updateOfflineData(List<ScannerRes>? data) {
  //   _offlineDataList = data;
  //   notifyListeners();
  // }

  Future updateData(List<MarketScannerRes>? data) async {
    if (data == null) return;
    Utils().showLog("1. ${data[0].identifier}  vol=> ${data[0].volume}");
    List<MarketScannerRes> prChangeAr = data;

    // for (var item in data) {
    //   if (item.identifier != null) {
    //     int volume = item.volume ?? 0;
    //     String extendedHoursType = item.extendedHoursType ?? "";
    //     double lastTrade = item.last ?? 0;
    //     // Perform specific logic based on conditions
    //     if (volume == 0) continue; // Skip if volume is 0
    //     // Check if ExtendedHoursType is "PostMarket" or "PreMarket"
    //     if (extendedHoursType == "PostMarket" ||
    //         extendedHoursType == "PreMarket") {
    //       if ((volume * (item.extendedHoursPrice ?? 0)) < 100000) {
    //         continue; // Skip if conditions are met
    //       }
    //       if ((item.extendedHoursPercentChange ?? 0) >= 0) {
    //         continue;
    //       }
    //     } else {
    //       if ((volume * lastTrade) < 100000) {
    //         continue; // Skip if conditions are met
    //       }
    //       if ((item.percentChange ?? 0) >= 0) {
    //         continue;
    //       }
    //     }
    //     prChangeAr.add(item);
    //   } else {
    //     debugPrint("Invalid item or missing Identifier: $item");
    //   }
    // }

    // storeFullLiveData(prChangeAr);

    // if (_dataList != null) {
    //   // prChangeAr.addAll(_dataList!);
    //   for (var dataItem in _dataList!) {
    //     // Check if identifier is already in prChangeAr
    //     bool exists =
    //         prChangeAr.any((entry) => entry.identifier == dataItem.identifier);
    //     // Only add the new item if its identifier doesn't already exist
    //     if (!exists) {
    //       prChangeAr.add(dataItem);
    //     }
    //   }
    // }

    // Sort the array based on `shortIndex`
    // prChangeAr.sort((a, b) {
    //   double valueA = a.percentChange ?? 0;
    //   if (a.extendedHoursType == "PostMarket" ||
    //       a.extendedHoursType == "PreMarket") {
    //     valueA = a.extendedHoursPercentChange ?? 0;
    //   }
    //   double valueB = b.percentChange ?? 0;
    //   if (b.extendedHoursType == "PostMarket" ||
    //       b.extendedHoursType == "PreMarket") {
    //     valueB = b.extendedHoursPercentChange ?? 0;
    //   }
    //   return valueA.compareTo(valueB);
    // });

    if (_filterParams?.sortByHeader != null) {
      prChangeAr.sort((a, b) {
        return sortByCompare(
          a,
          b,
          _filterParams?.sortByHeader ?? "",
          _filterParams?.sortByAsc ?? true,
        );
      });
    } else if (_filterParams?.sortBy != 3 &&
        _filterParams?.sortByHeader == null) {
      prChangeAr.sort((a, b) {
        num valueA = a.percentChange ?? 0;
        num valueB = b.percentChange ?? 0;
        if ((a.extendedHoursType == "PostMarket" ||
            a.extendedHoursType == "PreMarket")) {
          Utils().showLog("++++++++++++++++++++++++++++++++");
          valueA = a.extendedHoursPercentChange ?? 0;
          valueB = b.extendedHoursPercentChange ?? 0;
        }
        if (_filterParams?.sortByAsc == true) {
          return valueB.compareTo(valueA);
        } else {
          return valueA.compareTo(valueB);
        }
      });
    } else if (_filterParams?.sortBy == 3) {
      prChangeAr.sort((a, b) {
        num valueA = a.volume ?? 0;
        num valueB = b.volume ?? 0;
        if (_filterParams?.sortByAsc == true) {
          return valueB.compareTo(valueA);
        } else {
          return valueA.compareTo(valueB);
        }
      });
    }

    Utils().showLog("2. ${prChangeAr[0].identifier} vol => ${data[0].volume}");
    // _dataList = prChangeAr.take(50).toList();
    _dataList = prChangeAr;

    notifyListeners();
  }

  // void storeFullLiveData(List<MarketScannerRes>? data) async {
  //   if (_fullDataList == null || _fullDataList?.isEmpty == true) {
  //     _fullDataList = data;
  //     return;
  //   } else {
  //     if (data != null && data.isNotEmpty) {
  //       // Iterate over the new data list
  //       for (var newItem in data) {
  //         // Find if an item with the same identifier exists in the list
  //         int index = _fullDataList!.indexWhere(
  //             (existingItem) => existingItem.identifier == newItem.identifier);
  //         if (index != -1) {
  //           // If the item exists (index != -1), replace the existing one
  //           _fullDataList![index] = newItem;
  //         } else {
  //           // If the item doesn't exist, add the new item
  //           _fullDataList!.add(newItem);
  //         }
  //       }
  //     }
  //   }
  //   _fullDataList!.sort((a, b) {
  //     return sortByCompare(
  //       a,
  //       b,
  //       "% Change",
  //       false,
  //     );
  //   });
  // }

  // void applyFilterValuesOnly(String sortByHeader, bool isAscending,
  //     {int? sortBy}) {
  //   _filterParams = FilterParamsGainerLoser(
  //     sortBy: _filterParams?.sortBy,
  //     sortByAsc: isAscending,
  //     sortByHeader: sortByHeader,
  //   );
  //   notifyListeners();
  // }

  void applyFilter(sortBy) {
    if (sortBy != _filterParams?.sortBy) {
      if (MarketLosersStream().listening) {
        MarketLosersStream().stopListeningPorts();
      }
      _filterParams = FilterParamsGainerLoser(
        sortBy: sortBy,
        sortByAsc: true,
        sortByHeader:
            sortBy == 2 ? SortByEnums.perChange.name : SortByEnums.volume.name,
      );
      Timer(const Duration(milliseconds: 500), () {
        MarketLosersStream().initializePorts();
      });
    } else {
      _filterParams = FilterParamsGainerLoser(
        sortBy: sortBy,
        sortByAsc: true,
        sortByHeader:
            sortBy == 2 ? SortByEnums.perChange.name : SortByEnums.volume.name,
      );
    }

    // if (sortBy == _filterParams?.sortBy) {
    //   _filterParams = FilterParamsGainerLoser(
    //     sortBy: sortBy,
    //     sortByAsc: !(_filterParams?.sortByAsc ?? true),
    //     sortByHeader: null,
    //   );
    // } else {
    //   _filterParams = FilterParamsGainerLoser(
    //     sortBy: sortBy,
    //     sortByAsc: (_filterParams?.sortByAsc ?? true),
    //     sortByHeader: null,
    //   );
    // }
    // if (MarketLosersStream().listening) {
    //   MarketLosersStream().stopListeningPorts();
    // }

    if (_dataList != null) {
      // Utils().showLog("----");
      updateData(_dataList);
      // updateData(_fullDataList);
    } else if (_offlineDataList != null) {
      // Utils().showLog("---- ******  ${_fullOfflineDataList?.length}");
      // updateOfflineData(_fullOfflineDataList, applyFilter: true);
      updateOfflineData(_offlineDataList, applyFilter: true);
    } else {
      notifyListeners();
    }
    notifyListeners();
  }

  void clearFilter() {
    _filterParams = null;
    notifyListeners();
  }

  void resetLiveFilter() {
    _filterParams = FilterParamsGainerLoser(
      sortBy: 2,
      sortByAsc: true,
      sortByHeader: SortByEnums.perChange.name,
    );
    notifyListeners();
  }

  void applySorting(String sortBy, bool isAscending) {
    // if (sortBy == _filterParams?.sortByHeader) {
    //   _filterParams = FilterParamsGainerLoser(
    //     sortByHeader: sortBy,
    //     sortBy: null,
    //     // sortByAsc: !(_filterParams?.sortByAsc ?? true),
    //     sortByAsc: isAscending,
    //   );
    // } else {
    _filterParams = FilterParamsGainerLoser(
      sortByHeader: sortBy,
      sortBy: _filterParams?.sortBy,
      sortByAsc: isAscending,
    );
    // }
    // if (MarketLosersStream().listening) {
    //   MarketLosersStream().stopListeningPorts();
    // }

    if (_dataList != null) {
      _dataList!.sort((a, b) {
        return sortByCompare(
          a,
          b,
          _filterParams?.sortByHeader ?? "",
          _filterParams?.sortByAsc ?? true,
        );
      });
      notifyListeners();
    } else if (_offlineDataList != null) {
      // updateOfflineData(_fullOfflineDataList, applyFilter: true);
      updateOfflineData(_offlineDataList, applyFilter: true);
    }
  }

  int sortByCompare(
      MarketScannerRes a, MarketScannerRes b, String sortBy, bool isAsc) {
    if (sortBy == SortByEnums.symbol.name) {
      if (a.identifier == null && b.identifier == null) return 0;
      if (a.identifier == null) return -1;
      if (b.identifier == null) return 1;
      if (isAsc) {
        return a.identifier!.compareTo(b.identifier!);
      } else {
        return b.identifier!.compareTo(a.identifier!);
      }
    } else if (sortBy == SortByEnums.company.name) {
      if (a.security?.name == null && b.security?.name == null) return 0;
      if (a.security?.name == null) return -1;
      if (b.security?.name == null) return 1;
      if (isAsc) {
        return a.security!.name!.compareTo(b.security!.name!);
      } else {
        return b.security!.name!.compareTo(a.security!.name!);
      }
    } else if (sortBy == SortByEnums.bid.name) {
      if (a.bid == null && b.bid == null) return 0;
      if (a.bid == null) return -1;
      if (b.bid == null) return 1;
      if (isAsc) {
        return a.bid!.compareTo(b.bid!);
      } else {
        return b.bid!.compareTo(a.bid!);
      }
    } else if (sortBy == SortByEnums.ask.name) {
      if (a.ask == null && b.ask == null) return 0;
      if (a.ask == null) return -1;
      if (b.ask == null) return 1;
      if (isAsc) {
        return a.ask!.compareTo(b.ask!);
      } else {
        return b.ask!.compareTo(a.ask!);
      }
    } else if (sortBy == SortByEnums.sector.name) {
      if (a.sector == null && b.sector == null) return 0;
      if (a.sector == null) return -1;
      if (b.sector == null) return 1;
      if (isAsc) {
        return a.sector!.compareTo(b.sector!);
      } else {
        return b.sector!.compareTo(a.sector!);
      }
    } else if (sortBy == SortByEnums.lastTrade.name) {
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
    } else if (sortBy == SortByEnums.postMarket.name) {
      if (a.extendedHoursPrice == null && b.extendedHoursPrice == null) {
        return 0;
      }
      if (a.extendedHoursPrice == null) return -1;
      if (b.extendedHoursPrice == null) return 1;
      if (isAsc) {
        return a.extendedHoursPrice!.compareTo(b.extendedHoursPrice!);
      } else {
        return b.extendedHoursPrice!.compareTo(a.extendedHoursPrice!);
      }
    } else if (sortBy == SortByEnums.postMarketNetChange.name) {
      num? valueA = a.extendedHoursChange ?? 0;
      num? valueB = b.extendedHoursChange ?? 0;

      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarketPerChange.name) {
      num? valueA = a.extendedHoursPercentChange ?? 0;
      num? valueB = b.extendedHoursPercentChange ?? 0;

      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.netChange.name) {
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
    } else if (sortBy == SortByEnums.perChange.name) {
      num? valueA = a.percentChange;
      num? valueB = b.percentChange;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursPercentChange ?? 0;
      //   valueB = b.extendedHoursPercentChange ?? 0;
      // }

      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.volume.name) {
      if (a.volume == null && b.volume == null) return 0;
      if (a.volume == null) return -1;
      if (b.volume == null) return 1;
      if (isAsc) {
        return a.volume!.compareTo(b.volume!);
      } else {
        return b.volume!.compareTo(a.volume!);
      }
    } else if (sortBy == SortByEnums.dollarVolume.name) {
      num dolorVolumeA = (a.volume ?? 0) * (a.last ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.last ?? 0);
      if (a.extendedHoursType == "PostMarket" ||
          a.extendedHoursType == "PreMarket") {
        dolorVolumeA = (a.volume ?? 0) * (a.extendedHoursPrice ?? 0);
        dolorVolumeB = (b.volume ?? 0) * (b.extendedHoursPrice ?? 0);
      }
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
    Utils().showLog("Compare => $sortBy $isAsc");

    if (sortBy == SortByEnums.symbol.name) {
      if (a.identifier == null && b.identifier == null) return 0;
      if (a.identifier == null) return -1;
      if (b.identifier == null) return 1;
      if (isAsc) {
        return a.identifier!.compareTo(b.identifier!);
      } else {
        return b.identifier!.compareTo(a.identifier!);
      }
    } else if (sortBy == SortByEnums.company.name) {
      if (a.name == null && b.name == null) return 0;
      if (a.name == null) return -1;
      if (b.name == null) return 1;
      if (isAsc) {
        return a.name!.compareTo(b.name!);
      } else {
        return b.name!.compareTo(a.name!);
      }
    } else if (sortBy == SortByEnums.sector.name) {
      if (a.sector == null && b.sector == null) return 0;
      if (a.sector == null) return -1;
      if (b.sector == null) return 1;
      if (isAsc) {
        return a.sector!.compareTo(b.sector!);
      } else {
        return b.sector!.compareTo(a.sector!);
      }
    } else if (sortBy == SortByEnums.bid.name) {
      if (a.bid == null && b.bid == null) return 0;
      if (a.bid == null) return -1;
      if (b.bid == null) return 1;
      if (isAsc) {
        return a.bid!.compareTo(b.bid!);
      } else {
        return b.bid!.compareTo(a.bid!);
      }
    } else if (sortBy == SortByEnums.ask.name) {
      if (a.ask == null && b.ask == null) return 0;
      if (a.ask == null) return -1;
      if (b.ask == null) return 1;
      if (isAsc) {
        return a.ask!.compareTo(b.ask!);
      } else {
        return b.ask!.compareTo(a.ask!);
      }
    } else if (sortBy == SortByEnums.lastTrade.name) {
      num? valueA = a.price;
      num? valueB = b.price;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursPrice ?? 0;
      //   valueB = b.extendedHoursPrice ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarket.name) {
      num? valueA = a.ext?.extendedHoursPrice ?? 0;
      num? valueB = b.ext?.extendedHoursPrice ?? 0;
      if (valueA == null && valueB == null) {
        return 0;
      }
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarketNetChange.name) {
      num? valueA = a.ext?.extendedHoursChange ?? 0;
      num? valueB = b.ext?.extendedHoursChange ?? 0;

      if (valueA == null && valueB == null) {
        return 0;
      }
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.postMarketPerChange.name) {
      num? valueA = a.ext?.extendedHoursPercentChange ?? 0;
      num? valueB = b.ext?.extendedHoursPercentChange ?? 0;
      if (valueA == null && valueB == null) {
        return 0;
      }
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.netChange.name) {
      // num? valueA = a.ext?.extendedHoursChange;
      // num? valueB = b.ext?.extendedHoursChange;
      num? valueA = a.change;
      num? valueB = b.change;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursChange ?? 0;
      //   valueB = b.extendedHoursChange ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.perChange.name) {
      // num valueA = a.ext?.extendedHoursPercentChange ?? 0;
      // num valueB = b.ext?.extendedHoursPercentChange ?? 0;
      num? valueA = a.changesPercentage;
      num? valueB = b.changesPercentage;
      // if (a.extendedHoursType == "PostMarket" ||
      //     a.extendedHoursType == "PreMarket") {
      //   valueA = a.extendedHoursPercentChange ?? 0;
      //   valueB = b.extendedHoursPercentChange ?? 0;
      // }
      if (valueA == null && valueB == null) return 0;
      if (valueA == null) return -1;
      if (valueB == null) return 1;
      if (isAsc) {
        return valueA.compareTo(valueB);
      } else {
        return valueB.compareTo(valueA);
      }
    } else if (sortBy == SortByEnums.volume.name) {
      if (a.volume == null && b.volume == null) return 0;
      if (a.volume == null) return -1;
      if (b.volume == null) return 1;
      if (isAsc) {
        return a.volume!.compareTo(b.volume!);
      } else {
        return b.volume!.compareTo(a.volume!);
      }
    } else if (sortBy == SortByEnums.dollarVolume.name) {
      num dolorVolumeA = (a.volume ?? 0) * (a.price ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.price ?? 0);
      if (isAsc) {
        return dolorVolumeA.compareTo(dolorVolumeB);
      } else {
        return dolorVolumeB.compareTo(dolorVolumeA);
      }
    }
    return 0;
  }
}
