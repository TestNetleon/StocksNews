import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/live.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/models/offline.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../../routes/my_app.dart';
import '../data/gainers.dart';
import 'filters.dart';
import 'scanner.dart';

class ScannerGainersManager extends ChangeNotifier {
  Status _status = Status.ideal;
  bool get isLoading => _status == Status.loading || _status == Status.ideal;

  String? _error;
  String? get error => _error ?? Const.errSomethingWrong;

  List<OfflineScannerRes>? _offlineDataList;
  List<OfflineScannerRes>? get offlineDataList => _offlineDataList;

  List<LiveScannerRes>? _dataList;
  List<LiveScannerRes>? get dataList => _dataList;

  FilterParamsGainerLoser? _filterParams = FilterParamsGainerLoser(
    sortBy: 2,
    sortByAsc: false,
    sortByHeader: SortByEnums.perChange.name,
  );

  FilterParamsGainerLoser? get filterParams => _filterParams;

  Extra? _extra;
  Extra? get extra => _extra;

  void setStatus(status) {
    _status = status;
    notifyListeners();
  }

  void startListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    notifyListeners();
    MarketGainersStream().initializePorts();
  }

  setTotalResult(num total) {
    navigatorKey.currentContext!.read<ScannerManager>().setTotalResults(total);
  }

  void stopListeningPorts() {
    _offlineDataList = null;
    _dataList = null;
    MarketGainersStream().stopListeningPorts();
  }

  void updateOfflineData(List<OfflineScannerRes>? data, {applyFilter = false}) {
    updateOfflineDataFilter(data);
    notifyListeners();
  }

  void updateOfflineDataFilter(List<OfflineScannerRes>? data) {
    if (data == null) return;
    Utils().showLog('SORT BY L: ${_filterParams?.sortBy}');
    if (_filterParams == null) {
      // _offlineDataList = data.take(50).toList();
      _offlineDataList = List.empty(growable: true);
      _offlineDataList?.addAll(data);
      notifyListeners();
      return;
    }

    if (_filterParams?.sortBy == 2) {
      print('Sort by 2');
      data.sort((a, b) {
        // num valueA = a.changesPercentage ?? 0;
        // num valueB = b.changesPercentage ?? 0;

        num valueA = a.ext?.extendedHoursPercentChange ?? 0;
        num valueB = b.ext?.extendedHoursPercentChange ?? 0;

        if (_filterParams?.sortByAsc == true) {
          return valueB.compareTo(valueA);
        }
        return valueA.compareTo(valueB);
      });
    } else if (_filterParams?.sortBy == 3) {
      print('Sort by 3');

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
      print('Sort by sortByHeader !=null');

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
    notifyListeners();
    setTotalResult(_offlineDataList?.length ?? 0);

    // Notify listeners to update UI
  }

  Future updateData(List<LiveScannerRes>? data) async {
    if (data == null) return;

    List<LiveScannerRes> prChangeAr = data;

    Utils().showLog('SORT BY G: ${_filterParams?.sortBy}');
    if (_filterParams?.sortByHeader != null) {
      prChangeAr.sort((a, b) {
        return sortByCompare(
          a,
          b,
          _filterParams?.sortByHeader ?? "",
          _filterParams?.sortByAsc ?? true,
        );
      });
    } else if (_filterParams?.sortBy != 2) {
      Utils().showLog("-----------------------------------------------");
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
          return valueA.compareTo(valueB);
        } else {
          return valueB.compareTo(valueA);
        }
      });
    } else if (_filterParams?.sortBy == 3) {
      prChangeAr.sort((a, b) {
        num valueA = a.volume ?? 0;
        num valueB = b.volume ?? 0;
        if (_filterParams?.sortByAsc == true) {
          return valueA.compareTo(valueB);
        } else {
          return valueB.compareTo(valueA);
        }
      });
    }
    // _dataList = prChangeAr.take(50).toList();
    _dataList = prChangeAr;
    notifyListeners();

    setTotalResult(_dataList?.length ?? 0);

    // _dataList = List.empty(growable: true);
    // _dataList?.addAll(prChangeAr);
  }

  void applyFilter(int sortBy) {
    if (MarketGainersStream().listening) {
      MarketGainersStream().stopListeningPorts();
    }

    ScannerManager manager =
        navigatorKey.currentContext!.read<ScannerManager>();

    bool isLIVE =
        manager.portData?.port?.checkMarketOpenApi?.isMarketOpen == true;

    _filterParams = FilterParamsGainerLoser(
      sortBy: sortBy,
      sortByAsc: false,
      sortByHeader: sortBy == 2
          ? isLIVE
              ? SortByEnums.perChange.name
              : SortByEnums.postMarketPerChange.name
          : SortByEnums.volume.name,
    );
    notifyListeners();
    Timer(const Duration(milliseconds: 500), () {
      MarketGainersStream().initializePorts();
    });

    if (_dataList != null) {
      _dataList = null;
      notifyListeners();
      updateData(_dataList);
    } else if (_offlineDataList != null) {
      _offlineDataList = null;
      notifyListeners();
      updateOfflineData(_offlineDataList, applyFilter: true);
    } else {
      notifyListeners();
    }
  }

  void resetLiveFilter() {
    ScannerManager manager =
        navigatorKey.currentContext!.read<ScannerManager>();

    bool isLIVE =
        manager.portData?.port?.checkMarketOpenApi?.isMarketOpen == true;
    _filterParams = FilterParamsGainerLoser(
      sortBy: 2,
      sortByAsc: false,
      sortByHeader: isLIVE
          ? SortByEnums.perChange.name
          : SortByEnums.postMarketPerChange.name,
    );
    notifyListeners();
  }

  void applySorting(String sortBy, bool isAscending) {
    _filterParams = FilterParamsGainerLoser(
      sortByHeader: sortBy,
      sortBy: _filterParams?.sortBy,
      sortByAsc: isAscending,
    );

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
      updateOfflineData(_offlineDataList, applyFilter: true);
    }
  }

  int sortByCompare(
      LiveScannerRes a, LiveScannerRes b, String sortBy, bool isAsc) {
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
      OfflineScannerRes a, OfflineScannerRes b, String sortBy, bool isAsc) {
    Utils().showLog('sortByCompareOffline in => $sortBy, is ASC => $isAsc');

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
      num? valueA = a.change;
      num? valueB = b.change;
      // num? valueA = a.ext?.extendedHoursChange;
      // num? valueB = b.ext?.extendedHoursChange;
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
      // num? valueA = a.ext?.extendedHoursPercentChange;
      // num? valueB = b.ext?.extendedHoursPercentChange;
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
      num dolorVolumeA = (a.volume ?? 0) * (a.ext?.extendedHoursPrice ?? 0);
      num dolorVolumeB = (b.volume ?? 0) * (b.ext?.extendedHoursPrice ?? 0);
      if (isAsc) {
        return dolorVolumeA.compareTo(dolorVolumeB);
      } else {
        return dolorVolumeB.compareTo(dolorVolumeA);
      }
    }
    return 0;
  }
}
